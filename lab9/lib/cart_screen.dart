import 'package:flutter/material.dart';

import 'main.dart';

class CartScreen extends StatelessWidget {
  final List<Book> items;
  final void Function(Book) onRemove;

  const CartScreen({super.key, required this.items, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final total = items.fold<int>(0, (sum, book) => sum + book.price);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView(
                    children: [
                      for (final book in items)
                        ListTile(
                          leading: const Icon(Icons.book),
                          title: Text(book.title),
                          subtitle: Text('${book.price} ₸'),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'Remove book',
                            onPressed: () {
                              onRemove(book);
                            },
                          ),
                        ),
                    ],
                  ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total: $total ₸',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}
