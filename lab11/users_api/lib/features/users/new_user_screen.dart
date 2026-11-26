import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';

import 'user.dart';
import 'users_model.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() {
    return _NewUserScreenState();
  }
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _key = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !(_key.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final draft = User(
      id: 0,
      name: _name.text.trim(),
      username: _username.text.trim(),
      email: _email.text.trim(),
      phone: '',
      website: null,
      address: const Address(
        street: '',
        suite: '',
        city: '',
        zipcode: '',
        geo: Geo(lat: 0, lng: 0),
      ),
      company: (name: '', catchPhrase: ''),
    );

    try {
      await context.read<UsersModel>().create(draft);

      if (!mounted) return;

      Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not save: '
            '${error.runtimeType}',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Save failed: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New user')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value?.trim().isEmpty ?? true) ? 'Name is required' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value?.trim().isEmpty ?? true)
                    ? 'Username is required'
                    : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final email = value?.trim() ?? '';

                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Saving...' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
