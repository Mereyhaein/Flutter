import 'dart:async';

import 'package:flutter/material.dart';

import '../models/countdown.dart';
import '../models/screening.dart';
import '../utils/format.dart';
import '../routes.dart';

class DetailScreen extends StatefulWidget {
  final DetailArgs args;
  const DetailScreen({super.key, required this.args});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Screening _screening;
  Timer? _timer;
  Countdown _countdown = const Ended();

  @override
  void initState() {
    super.initState();
    _screening = widget.args.screening;
    _tick();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _tick());
  }

  void _tick() {
    setState(() {
      _countdown = Countdown.fromNow(_screening.when, const Duration(hours: 2));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _countdownLabel(Countdown c) => switch (c) {
    Upcoming(remaining: var r) =>
      'Starts in ${r.inHours}h ${r.inMinutes % 60}m',
    Started(elapsed: var e) => 'Started ${e.inMinutes} min ago',
    Ended() => 'Ended',
  };

  void _update(Screening updated) {
    setState(() => _screening = updated);
    widget.args.onUpdate(updated);
  }

  Future<void> _toggleAttendance() async {
    final myName = widget.args.profile.name;

    // R15: пустое имя профиля -> SnackBar с переключением на таб профиля
    if (myName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Set your name in Profile first'),
          action: SnackBarAction(
            label: 'Go to Profile',
            onPressed: widget.args.onGoToProfileTab,
          ),
        ),
      );
      return;
    }

    final isJoined = _screening.contains(myName);
    if (!isJoined && _screening.isFull) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isJoined ? 'Cancel your booking?' : 'Book this screening?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final names = isJoined
        ? _screening.attendees.where((n) => n != myName).toList()
        : [..._screening.attendees, myName];

    _update(_screening.copyWith(attendees: names));
  }

  Future<void> _editOrDelete(String action) async {
    if (action == 'edit') {
      final result = await Navigator.pushNamed<Screening>(
        context,
        Routes.form,
        arguments: FormArgs(screening: _screening),
      );
      if (result != null && mounted) _update(result);
    } else if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Delete this screening?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed == true && mounted) {
        widget.args.onDelete();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myName = widget.args.profile.name;
    final isJoined = _screening.contains(myName);
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            _screening.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: _editOrDelete,
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
          bottom: TabBar(
            tabs: [
              const Tab(text: 'About'),
              Tab(text: 'Names (${_screening.count})'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    _screening.imageAsset,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Chip(
                      avatar: Icon(_screening.genre.icon, size: 18),
                      label: Text(_screening.genre.label),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Chip(label: Text(_countdownLabel(_countdown))),
                  ),
                ],
              ),
              SizedBox(
                height: 400,
                child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatDate(_screening.when)),
                          Text(_screening.venue),
                          Text(
                            '${_screening.places.taken}/${_screening.limit} places',
                          ),
                          if (_screening.description != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _screening.description!,
                            ), // null проверен строкой выше
                          ],
                        ],
                      ),
                    ),
                    ListView(
                      children: [
                        for (final name in _screening.attendees)
                          ListTile(
                            title: Text(
                              name,
                              style: name == myName
                                  ? Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.bold)
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: (!isJoined && _screening.isFull)
                      ? null
                      : _toggleAttendance,
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.primary,
                  ),
                  child: Text(isJoined ? 'Cancel booking' : 'Book'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
