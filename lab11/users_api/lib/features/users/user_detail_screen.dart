import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              child: Text(
                user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Personal information',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text('ID'),
            subtitle: Text('${user.id}'),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name'),
            subtitle: Text(user.name),
          ),

          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),

          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(user.email),
          ),

          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Website'),
            subtitle: Text(user.website ?? 'Not available'),
            onTap: () {},
          ),

          const Divider(height: 32),

          Text('Address', style: Theme.of(context).textTheme.titleLarge),

          ListTile(
            title: const Text('Street'),
            subtitle: Text(user.address.street),
          ),

          ListTile(
            title: const Text('Suite'),
            subtitle: Text(user.address.suite),
          ),

          ListTile(
            title: const Text('City'),
            subtitle: Text(user.address.city),
          ),

          ListTile(
            title: const Text('Zipcode'),
            subtitle: Text(user.address.zipcode),
          ),

          ListTile(
            title: const Text('Latitude'),
            subtitle: Text('${user.address.geo.lat}'),
          ),

          ListTile(
            title: const Text('Longitude'),
            subtitle: Text('${user.address.geo.lng}'),
          ),

          const Divider(height: 32),

          Text('Company', style: Theme.of(context).textTheme.titleLarge),

          ListTile(
            title: const Text('Company name'),
            subtitle: Text(user.company.name),
          ),

          ListTile(
            title: const Text('Catch phrase'),
            subtitle: Text(user.company.catchPhrase),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
