import 'package:flutter/material.dart';

import '../models/movie_genre.dart';
import '../models/screening.dart';
import '../routes.dart';

class FormScreen extends StatefulWidget {
  final FormArgs args;
  const FormScreen({super.key, required this.args});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _venueController;
  late final TextEditingController _limitController;
  late final FocusNode _titleFocus;
  late final FocusNode _venueFocus;
  late final FocusNode _limitFocus;

  late MovieGenre _genre;
  late DateTime _date;
  late TimeOfDay _time;
  late bool _isOnline;
  late int _currentCount;
  String? _description;
  bool _saving = false;
  bool _savedSuccessfully =
      false; // R30: чтобы Save не спрашивал "Discard changes?"

  // R30: значения на момент открытия формы, для сравнения "dirty"
  late final String _initialTitle;
  late final String _initialVenue;
  late final String _initialLimit;
  late final MovieGenre _initialGenre;
  late final DateTime _initialDate;
  late final TimeOfDay _initialTime;
  late final bool _initialOnline;

  Screening? get _editing => widget.args.screening;

  @override
  void initState() {
    super.initState();
    final s = _editing;

    _titleController = TextEditingController(text: s?.title ?? '');
    _venueController = TextEditingController(text: s?.venue ?? '');
    _limitController = TextEditingController(
      text: s != null ? '${s.limit}' : '',
    );
    _titleFocus = FocusNode();
    _venueFocus = FocusNode();
    _limitFocus = FocusNode();

    _genre = s?.genre ?? MovieGenre.action;
    _date = s?.when ?? DateTime.now().add(const Duration(days: 1));
    _time = TimeOfDay.fromDateTime(
      s?.when ?? DateTime.now().add(const Duration(hours: 1)),
    );
    _isOnline = s?.isOnline ?? false;
    _currentCount = s?.count ?? 0;
    _description = s?.description;

    _initialTitle = _titleController.text;
    _initialVenue = _venueController.text;
    _initialLimit = _limitController.text;
    _initialGenre = _genre;
    _initialDate = _date;
    _initialTime = _time;
    _initialOnline = _isOnline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _venueController.dispose();
    _limitController.dispose();
    _titleFocus.dispose();
    _venueFocus.dispose();
    _limitFocus.dispose();
    super.dispose();
  }

  bool get _isDirty =>
      _titleController.text != _initialTitle ||
      _venueController.text != _initialVenue ||
      _limitController.text != _initialLimit ||
      _genre != _initialGenre ||
      _date != _initialDate ||
      _time != _initialTime ||
      _isOnline != _initialOnline;

  String? _validateTitle(String? v) {
    if (v == null || v.length < 3 || v.length > 60) {
      return '3 to 60 characters';
    }
    return null;
  }

  String? _validateVenue(String? v) {
    if (v == null || v.isEmpty) {
      return 'Required';
    }
    if (_isOnline && !v.contains('://')) {
      return 'Must be a link (contains ://)';
    }
    return null;
  }

  String? _validateLimit(String? v) {
    final n = int.tryParse(v ?? '');
    if (n == null || n < 1 || n > 500) {
      return '1 to 500';
    }
    if (_editing != null && n < _currentCount) {
      return 'Below current attendee count';
    }
    return null;
  }

  DateTime get _combined =>
      DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // R34: дата/время в будущем обязательны для нового элемента (не зависит от isOnline)
    if (_editing == null && _combined.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date and time must be in the future')),
      );
      return;
    }

    setState(() => _saving = true);
    await Future.delayed(
      const Duration(seconds: 1),
    ); // R17: имитация сохранения
    if (!mounted) return;

    final result = (_editing ?? Screening.empty()).copyWith(
      title: _titleController.text,
      genre: _genre,
      when: _combined,
      venue: _venueController.text,
      limit: int.parse(_limitController.text),
      isOnline: _isOnline,
      description: _description,
    );

    _savedSuccessfully =
        true; // R30: разрешаем pop без вопроса "Discard changes?"
    Navigator.pop(context, result);
  }

  Future<bool> _confirmDiscard() async {
    if (!_isDirty) return true;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Discard changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDirty || _savedSuccessfully,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final navigator = Navigator.of(context);
        final shouldDiscard = await _confirmDiscard();

        if (shouldDiscard && mounted) {
          navigator.pop();
        }
      },

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(_editing == null ? 'New screening' : 'Edit screening'),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _titleController,
                focusNode: _titleFocus,
                maxLength: 60,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: _validateTitle,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onFieldSubmitted: (_) => _venueFocus.requestFocus(),
              ),
              SwitchListTile(
                title: const Text('Online screening'),
                value: _isOnline,
                onChanged: (v) => setState(() => _isOnline = v),
              ),
              TextFormField(
                controller: _venueController,
                focusNode: _venueFocus,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: _isOnline ? 'Stream link' : 'Venue',
                ),
                keyboardType: _isOnline
                    ? TextInputType.url
                    : TextInputType.text,
                validator: _validateVenue,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onFieldSubmitted: (_) => _limitFocus.requestFocus(),
              ),
              TextFormField(
                controller: _limitController,
                focusNode: _limitFocus,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Capacity'),
                validator: _validateLimit,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<MovieGenre>(
                initialValue: _genre,
                decoration: const InputDecoration(labelText: 'Genre'),
                items: [
                  for (final g in MovieGenre.values)
                    DropdownMenuItem(value: g, child: Text(g.label)),
                ],
                onChanged: (g) => setState(() => _genre = g!),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text('${_date.day}/${_date.month}/${_date.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              ListTile(
                title: Text(_time.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 3,
                onChanged: (v) => _description = v.isEmpty ? null : v,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving
                    ? null
                    : _save, // R17: disabled пока сохраняется
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
