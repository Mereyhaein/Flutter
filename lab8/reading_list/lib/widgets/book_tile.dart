import 'package:flutter/material.dart';
import '../models/book.dart';

class BookTile extends StatelessWidget {
  const BookTile({super.key, required this.book, required this.onToggle});

  final Book book;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(child: Text(book.title[0])),
                if (!book.read)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.error,
                        border:
                            Border.all(color: colorScheme.surface, width: 2),
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
                    book.title,
                    style: textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${book.author} · ${book.pages} pp.',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Checkbox(value: book.read, onChanged: (_) => onToggle()),
          ],
        ),
      ),
    );
  }
}