import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  late final DateTime openedAt;

  String? _cachedReport;

  void add(LibraryItem item) {
    items.add(item);
  }

  void open() {
    openedAt = DateTime.now();
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }
    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  String get report {
    _cachedReport ??= displayList.join('\n');
    return _cachedReport ?? '';
  }

  // Level 4: every title
  List<String> get titles =>
      items.map((item) => item.title).toList();

  // Level 4: books published after 2010
  List<Book> get booksAfter2010 =>
      items.whereType<Book>().where((book) => book.year > 2010).toList();

  // fold works with an empty collection; reduce would have no initial value.
  double get averagePageCount {
    final books = items.whereType<Book>().toList();

    return books.isEmpty
        ? 0
        : books.fold<int>(0, (sum, book) => sum + book.pages) / books.length;
  }

  // Author name -> number of books
  Map<String, int> get booksPerAuthor => {
        for (final book in items.whereType<Book>())
          book.author.name:
              items
                  .whereType<Book>()
                  .where((b) => b.author.name == book.author.name)
                  .length,
      };

  // Distinct author names
  Set<String> get authorNames =>
      items.whereType<Book>().map((book) => book.author.name).toSet();

  // Every genre present
  Set<Genre> get genres =>
      items.whereType<Book>().map((book) => book.genre).toSet();

  // One display list built as a single literal
  List<String> get displayList => [
        'CATALOGUE',
        for (final book in items.whereType<Book>())
          '${book.title} (${book.year})',
        ...authorNames,
        if (items.whereType<Book>().any((book) => book.pages == 0))
          '(incomplete data)',
      ];
}