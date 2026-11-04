import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final int count;
  final int total;

  const CartBadge({super.key, required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$total ₸', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Badge(
          label: Text('$count'),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Open cart',
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
