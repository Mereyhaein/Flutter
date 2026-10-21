import 'package:flutter/material.dart';

// R23: один виджет для всех пустых состояний
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyLarge),
          if (buttonLabel != null) ...[
            const SizedBox(height: 12),
            FilledButton(onPressed: onButtonPressed, child: Text(buttonLabel!)),
          ],
        ],
      ),
    );
  }
}
