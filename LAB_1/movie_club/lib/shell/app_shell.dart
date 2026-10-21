import 'package:flutter/material.dart';

import '../models/screening.dart';
import '../models/profile.dart';
import '../models/seed.dart';
import '../screens/list_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/profile_screen.dart';

class AppShell extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const AppShell({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late List<Screening> _screenings;
  late Profile _profile;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _screenings = List.of(seedScreenings);
    _profile = const Profile.empty();
  }

  void _updateScreening(Screening updated) {
    setState(() {
      _screenings = [
        for (final s in _screenings)
          if (s.id == updated.id) updated else s,
      ];
    });
  }

  void _addScreening(Screening s) =>
      setState(() => _screenings = [..._screenings, s]);

  void _deleteScreening(Screening s) => setState(
    () => _screenings = _screenings.where((e) => e.id != s.id).toList(),
  );

  void _updateProfile(Profile p) => setState(() => _profile = p);

  void _goToTab(int index) => setState(() => _tabIndex = index);

  void _resetData() {
    setState(() {
      _screenings = List.of(seedScreenings);
      _profile = const Profile.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ListScreen(
        screenings: _screenings,
        profile: _profile,
        onUpdate: _updateScreening,
        onAdd: _addScreening,
        onDelete: _deleteScreening,
        onGoToProfileTab: () => _goToTab(2),
      ),
      FavouritesScreen(
        screenings: _screenings,
        profile: _profile,
        onUpdate: _updateScreening,
        onDelete: _deleteScreening,
        onGoToProfileTab: () => _goToTab(2),
      ),
      ProfileScreen(
        profile: _profile,
        onProfileChanged: _updateProfile,
        themeMode: widget.themeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
        memberCount: _screenings.where((s) => s.contains(_profile.name)).length,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Club')),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('About'),
                      content: const Text('Movie Club — Lab 1 project.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Reset data'),
                onTap: () async {
                  Navigator.pop(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Reset data?'),
                      content: const Text(
                        'This restores the seed data and clears your profile.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && mounted) _resetData();
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _tabIndex, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: _goToTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'List'),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
