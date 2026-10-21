import 'package:flutter/material.dart';

import '../models/screening.dart';
import '../models/movie_genre.dart';
import '../models/profile.dart';
import '../widgets/screening_card.dart';
import '../widgets/empty_state.dart';
import '../routes.dart';

class ListScreen extends StatefulWidget {
  final List<Screening> screenings;
  final ValueChanged<Screening> onUpdate;
  final ValueChanged<Screening> onAdd;
  final ValueChanged<Screening> onDelete;
  final Profile profile;
  final VoidCallback onGoToProfileTab;

  const ListScreen({
    super.key,
    required this.screenings,
    required this.onUpdate,
    required this.onAdd,
    required this.onDelete,
    required this.profile,
    required this.onGoToProfileTab,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _searchController = TextEditingController();
  MovieGenre? _selectedGenre; // null = "All"
  bool _showPastOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // R7: списки через where/map, без циклов for
  List<Screening> get _filtered {
    final query = _searchController.text.toLowerCase();
    return widget.screenings.where((s) {
      final matchesQuery =
          query.isEmpty || s.title.toLowerCase().contains(query);
      final matchesGenre = _selectedGenre == null || s.genre == _selectedGenre;
      final matchesPast = !_showPastOnly || s.isPast;
      return matchesQuery && matchesGenre && matchesPast;
    }).toList();
  }

  void _openDetail(Screening s) {
    Navigator.pushNamed(
      context,
      Routes.detail,
      arguments: DetailArgs(
        screening: s,
        onUpdate: widget.onUpdate,
        onDelete: () => widget.onDelete(s),
        profile: widget.profile,
        onGoToProfileTab: widget.onGoToProfileTab,
      ),
    );
  }

  Future<void> _openForm() async {
    final result = await Navigator.pushNamed<Screening>(
      context,
      Routes.form,
      arguments: FormArgs(),
    );
    if (result != null && mounted) {
      widget.onAdd(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(_searchController.clear),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedGenre == null,
                  onSelected: (_) => setState(() => _selectedGenre = null),
                ),
                const SizedBox(width: 8),
                for (final g in MovieGenre.values) ...[
                  ChoiceChip(
                    label: Text(g.label),
                    selected: _selectedGenre == g,
                    onSelected: (_) => setState(() => _selectedGenre = g),
                  ),
                  const SizedBox(width: 8),
                ],
                FilterChip(
                  label: const Text('Past'),
                  selected: _showPastOnly,
                  onSelected: (v) => setState(() => _showPastOnly = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? EmptyState(
                    icon: Icons.movie_filter,
                    message: _searchController.text.isNotEmpty
                        ? 'No matches'
                        : 'No screenings yet',
                  )
                // R20: LayoutBuilder решает список/грид, не MediaQuery
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 600) {
                        final columns = (constraints.maxWidth / 360)
                            .floor()
                            .clamp(1, 10);
                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisExtent: 180,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: items.length,
                          itemBuilder: (_, i) => ScreeningCard(
                            screening: items[i],
                            onTap: () => _openDetail(items[i]),
                            onFavouriteToggle: () => widget.onUpdate(
                              items[i].copyWith(favourite: !items[i].favourite),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => ScreeningCard(
                          screening: items[i],
                          onTap: () => _openDetail(items[i]),
                          onFavouriteToggle: () => widget.onUpdate(
                            items[i].copyWith(favourite: !items[i].favourite),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
