import 'package:flutter/material.dart';
import 'add_book_screen.dart';
import 'detail_screen.dart';
import 'models/book.dart';
import 'widgets/book_tile.dart';

enum Filter { all, unread, read }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> _books = [...seed];
  Filter _filter = Filter.all;

  List<Book> get _visible => switch (_filter) {
        Filter.all => _books,
        Filter.unread => unread(_books),
        Filter.read => _books.where((b) => b.read).toList(),
      };

  Future<void> _openDetail(Book book) async {
    final action = await Navigator.of(context).push<BookAction>(
      MaterialPageRoute(builder: (context) => DetailScreen(book: book)),
    );
    if (!mounted) return;
    switch (action) {
      case null:
        break;
      case BookAction.toggleRead:
        setState(() => book.read = !book.read);
      case BookAction.delete:
        setState(() => _books.remove(book));
    }
  }

  Future<void> _openAddBook() async {
    final book = await Navigator.of(context).push<Book>(
      MaterialPageRoute(builder: (context) => const AddBookScreen()),
    );
    if (!mounted) return;
    if (book == null) return;
    setState(() => _books.add(book));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Reading list (${_visible.length})')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddBook,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        label: 'Books',
                        value: '${_books.length}',
                        textTheme: textTheme,
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        label: 'Pages',
                        value: '${totalPages(_books)}',
                        textTheme: textTheme,
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        label: 'Unread',
                        value: '${unread(_books).length}',
                        textTheme: textTheme,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _filter == Filter.all,
                  onSelected: (_) => setState(() => _filter = Filter.all),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Unread'),
                  selected: _filter == Filter.unread,
                  onSelected: (_) => setState(() => _filter = Filter.unread),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Read'),
                  selected: _filter == Filter.read,
                  onSelected: (_) => setState(() => _filter = Filter.read),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _visible.length,
                itemBuilder: (context, i) {
                  final book = _visible[i];
                  return InkWell(
                    onTap: () => _openDetail(book),
                    child: BookTile(
                      book: book,
                      onToggle: () =>
                          setState(() => book.read = !book.read),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.textTheme,
  });

  final String label;
  final String value;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: textTheme.headlineSmall),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}