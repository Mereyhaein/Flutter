import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/auth_model.dart';
import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  Future<void> _open(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(uri);

      if (!context.mounted) return;

      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No app can open this link')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Cannot open link: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final website = user.website;

    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          CircleAvatar(
            radius: 36,
            child: Text(user.name.isEmpty ? '?' : user.name[0]),
          ),

          const SizedBox(height: 16),

          Text('ID: ${user.id}'),

          ListTile(title: const Text('Name'), subtitle: Text(user.name)),

          ListTile(
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),

          ListTile(
            title: const Text('Email'),
            subtitle: Text(user.email),
            trailing: const Icon(Icons.email_outlined),
            onTap: () =>
                _open(context, Uri(scheme: 'mailto', path: user.email)),
          ),

          ListTile(
            title: const Text('Phone'),
            subtitle: Text(user.phone.isEmpty ? 'Not provided' : user.phone),
            trailing: const Icon(Icons.call_outlined),
            onTap: user.phoneDigits.isEmpty
                ? null
                : () => _open(
                    context,
                    Uri(scheme: 'tel', path: user.phoneDigits),
                  ),
          ),

          if (website != null && website.isNotEmpty)
            ListTile(
              title: const Text('Website'),
              subtitle: Text(website),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _open(
                context,
                Uri.parse(
                  website.startsWith('https://') ||
                          website.startsWith('http://')
                      ? website
                      : 'https://$website',
                ),
              ),
            ),

          const Divider(),

          ListTile(
            title: const Text('Address'),
            subtitle: Text(
              '${user.address.street}, '
              '${user.address.suite}\n'
              '${user.address.city}, '
              '${user.address.zipcode}\n'
              'Geo: ${user.address.geo.lat}, '
              '${user.address.geo.lng}',
            ),
          ),

          ListTile(
            title: const Text('Company'),
            subtitle: Text(
              '${user.company.name}\n'
              '${user.company.catchPhrase}',
            ),
          ),

          if (kDebugMode)
            OutlinedButton.icon(
              onPressed: () async {
                final token = await context
                    .read<AuthModel>()
                    .readTokenForDebug();

                if (!context.mounted) return;

                if (token == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No debug token available')),
                  );

                  return;
                }

                await Clipboard.setData(ClipboardData(text: token));

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debug token copied')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy token (debug only)'),
            ),
        ],
      ),
    );
  }
}
