import 'data.dart';
import 'models.dart';
import 'catalogue.dart';
import 'shelf_state.dart';

void main() {
  final books = rawBooks.map(Book.fromJson).toList();

  final library = Library();
  library.open();

  for (final book in books) {
    library.add(book);
  }

  print('=== LIBRARY CATALOGUE ===');
  print(library.report);

  print('\n=== QUERIES ===');

  print('All titles:');
  print(library.titles);

  print('\nBooks published after 2010:');
  print(library.booksAfter2010);

  print('\nAverage page count:');
  print(library.averagePageCount);

  print('\nBooks per author:');
  print(library.booksPerAuthor);

  print('\nDistinct authors:');
  print(library.authorNames);

  print('\nGenres:');
  print(library.genres);

  print('\nCountry of Clean Code:');
  print(library.countryOf('Clean Code'));

  print('\nCountry of Design Patterns:');
  print(library.countryOf('Design Patterns'));

  print('\nFind Broken Record:');
  print(library.findByTitle('Broken Record'));

  print('\n=== RECORD ===');

  final stats = statsOf(books);

  print('Count: ${stats.count}');
  print('Average pages: ${stats.avgPages}');

  print('\n=== SHELF STATES ===');

  const empty = Empty();
  final ready = Ready(books);
  const broken = Broken('Shelf data could not be loaded');

  print(describe(empty));
  print(describe(ready));
  print(describe(broken));
}
