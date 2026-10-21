import 'package:flutter/material.dart';

import '../models/screening.dart';
import '../models/profile.dart';
import '../widgets/screening_card.dart';
import '../widgets/empty_state.dart';
import '../routes.dart';

class FavouritesScreen extends StatelessWidget {
  final List<Screening> screenings;
  final Profile profile;
  final ValueChanged<Screening> onUpdate;
  final ValueChanged<Screening> onDelete;
  final VoidCallback onGoToProfileTab;

  const FavouritesScreen({
    super.key,
    required this.screenings,
    required this.profile,
    required this.onUpdate,
    required this.onDelete,
    required this.onGoToProfileTab,
  });

  @override
  Widget build(BuildContext context) {
    final favourites = screenings.where((s) => s.favourite).toList();

    if (favourites.isEmpty) {
      return const EmptyState(
        icon: Icons.favorite_border,
        message: 'No favourites yet',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: favourites.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) => ScreeningCard(
        screening: favourites[i],
        onTap: () => Navigator.pushNamed(
          context,
          Routes.detail,
          arguments: DetailArgs(
            screening: favourites[i],
            profile: profile,
            onUpdate: onUpdate,
            onDelete: () => onDelete(favourites[i]),
            onGoToProfileTab: onGoToProfileTab,
          ),
        ),
        onFavouriteToggle: () => onUpdate(
          favourites[i].copyWith(favourite: !favourites[i].favourite),
        ),
      ),
    );
  }
}
