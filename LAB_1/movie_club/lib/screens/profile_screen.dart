import 'package:flutter/material.dart';

import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;
  final ValueChanged<Profile> onProfileChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final int memberCount;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onProfileChanged,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.memberCount,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _groupController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _groupController = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _nameController.text = widget.profile.name;
      _groupController.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  String? _validateGroup(String? value) {
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(r'^[A-Za-z]{2,4}-\d{2,3}$');
    return regex.hasMatch(value) ? null : 'Format: AB-123';
  }

  void _save() {
    widget.onProfileChanged(
      Profile(name: _nameController.text, group: _groupController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _groupController,
          decoration: InputDecoration(
            labelText: 'Group',
            errorText: _validateGroup(_groupController.text),
          ),
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 16),
        Text('You are on ${widget.memberCount} lists'),
        const SizedBox(height: 24),
        Text('Theme', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Light'),
              selected: widget.themeMode == ThemeMode.light,
              onSelected: (_) => widget.onThemeModeChanged(ThemeMode.light),
            ),
            ChoiceChip(
              label: const Text('Dark'),
              selected: widget.themeMode == ThemeMode.dark,
              onSelected: (_) => widget.onThemeModeChanged(ThemeMode.dark),
            ),
            ChoiceChip(
              label: const Text('System'),
              selected: widget.themeMode == ThemeMode.system,
              onSelected: (_) => widget.onThemeModeChanged(ThemeMode.system),
            ),
          ],
        ),
      ],
    );
  }
}
