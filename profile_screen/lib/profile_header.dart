import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/profile.jpg',
          width: 140,
          height: 140,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontFamily: 'ProfileFont',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(university, textAlign: TextAlign.center),
      ],
    );
  }
}
