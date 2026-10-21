import 'package:flutter/material.dart';

import '../models/screening.dart';
import '../utils/format.dart';

// R18: одна переиспользуемая карточка
class ScreeningCard extends StatelessWidget {
  final Screening screening;
  final VoidCallback onTap;
  final VoidCallback onFavouriteToggle;

  const ScreeningCard({
    super.key,
    required this.screening,
    required this.onTap,
    required this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final places = screening.places;
    final scheme = Theme.of(context).colorScheme;
    final badgeTextStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: scheme.onError);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // R18/R19: Stack с картинкой фильма и бейджем
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      screening.imageAsset,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (screening.isFull || places.free <= 5)
                    Positioned(
                      bottom: -4,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: screening.isFull
                              ? scheme.error
                              : scheme.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          screening.isFull ? 'FULL' : '${places.free} left',
                          style: badgeTextStyle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screening.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      screening.genre.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: screening.genre.colorOf(scheme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(formatDate(screening.when)),
                    Text(
                      screening.venue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${places.taken} reserved · ${places.free} available',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  screening.favourite ? Icons.favorite : Icons.favorite_border,
                  color: screening.favourite ? scheme.error : null,
                ),
                onPressed: onFavouriteToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
