import 'dart:async';

import 'package:flutter/material.dart';

import 'api/countdown.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _version = 0;

  late final Stream<int> _stream;

  StreamSubscription<int>? _sub;

  int _left = 10;

  @override
  void initState() {
    super.initState();

    _stream = countdown(10);
  }

  void _startManual() {
    _left = 10;

    _sub = countdown(10).listen((i) {
      if (!mounted) return;

      setState(() {
        _left = i;
      });
    });
  }

  void _changeVersion(int value) {
    if (value == _version) return;

    _sub?.cancel();
    _sub = null;

    setState(() {
      _version = value;
      _left = 10;
    });

    if (value == 1) {
      _startManual();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('A: StreamBuilder')),
                ButtonSegment(value: 1, label: Text('B: listen')),
              ],
              selected: {_version},
              onSelectionChanged: (values) {
                _changeVersion(values.first);
              },
            ),
          ),
          const SizedBox(height: 32),
          if (_version == 0)
            StreamBuilder<int>(
              stream: _stream,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data ?? 10}',
                  style: Theme.of(context).textTheme.displayLarge,
                );
              },
            )
          else
            Text('$_left', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 16),
          const Text('Leave this screen mid-count to test cancellation.'),
        ],
      ),
    );
  }
}
