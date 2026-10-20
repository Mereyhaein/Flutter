import 'package:flutter/material.dart';
import 'models/book.dart';

enum BookAction { toggleRead, delete }

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.book});
  final Book book;

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete '${book.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (confirmed ?? false) {
      Navigator.of(context).pop(BookAction.delete);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('by ${book.author}', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('${book.pages} pages', style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              book.year == null ? 'Year unknown' : 'Published ${book.year}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(BookAction.toggleRead),
              child: Text(book.read ? 'Mark as unread' : 'Mark as read'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => _delete(context),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}