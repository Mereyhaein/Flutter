import 'package:flutter/material.dart';

import 'main.dart';
import 'cart_badge.dart';

class BooksScreen extends StatelessWidget {
  final List<Book> cart;
  final void Function(Book) onAdd;

  const BooksScreen({super.key, required this.cart, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');

    final total = cart.fold<int>(0, (sum, book) => sum + book.price);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [CartBadge(count: cart.length, total: total)],
      ),
      body: ListView(
        children: [
          for (final book in books)
            Builder(
              builder: (context) {
                debugPrint('row ${book.title}');

                final isAdded = cart.contains(book);

                return ListTile(
                  leading: const Icon(Icons.menu_book, color: Colors.orange),
                  title: Text(book.title),
                  subtitle: Text('${book.author}\n${book.price} ₸'),
                  isThreeLine: true,
                  trailing: isAdded
                      ? const Text('Added')
                      : OutlinedButton(
                          onPressed: () {
                            onAdd(book);
                          },
                          child: const Text('Add'),
                        ),
                );
              },
            ),
        ],
      ),
    );
  }
}
