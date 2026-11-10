import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/student_views.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key, this.empty = false});

  final bool empty;

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student>? _students;
  Object? _error;

  late final FakeApi _api;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _api = FakeApi(empty: widget.empty);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _students = null;
      _error = null;
    });

    try {
      final list = await _api.fetchStudents();

      if (!mounted) return;

      setState(() {
        _students = list;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e;
      });
    }
  }

  Future<void> _save() async {
    if (_saving || _students == null) return;

    setState(() {
      _saving = true;
    });

    try {
      await _api.save(_students!.length);

      if (!mounted) return;

      Navigator.pop(context);
    } on StateError catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_error != null) {
      content = ErrorView(onRetry: _load);
    } else if (_students == null) {
      content = const LoadingView();
    } else if (_students!.isEmpty) {
      content = const EmptyView();
    } else {
      content = StudentList(students: _students!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students — By hand'),
        actions: [
          IconButton(
            tooltip: 'Reload students',
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed:
            _students == null || _saving || _error != null ? null : _save,
        tooltip: 'Save',
        child: _saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
      ),
    );
  }
}
