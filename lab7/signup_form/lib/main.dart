import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() => runApp(const MyApp());

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthController = TextEditingController();

  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _password,
      _confirm,
      _birthController,
    ]) {
      controller.dispose();
    }

    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Account created')));

      setState(() {
        _done = true;
      });
    }
  }

  Future<void> _pickDate() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final selected = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (selected == null) return;
    if (!mounted) return;

    setState(() {
      _birth = selected;

      final day = selected.day.toString().padLeft(2, '0');
      final month = selected.month.toString().padLeft(2, '0');
      final year = selected.year.toString();

      _birthController.text = '$day.$month.$year';
    });
  }

  void _startOver() {
    setState(() {
      _name.clear();
      _email.clear();
      _password.clear();
      _confirm.clear();
      _birthController.clear();

      _group = null;
      _birth = null;
      _agreed = false;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: _done ? _buildSummary() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create your account',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Name
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                _emailFocus.requestFocus();
              },
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (value) {
                if ((value ?? '').trim().length < 2) {
                  return 'Name is too short';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: _email,
              focusNode: _emailFocus,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'name@kbtu.kz',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (value) {
                final email = (value ?? '').trim();
                final at = email.indexOf('@');

                if (at <= 0 ||
                    email.indexOf('.', at + 1) <= at + 1 ||
                    email.endsWith('.')) {
                  return 'Email looks wrong';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Password',
                helperText: 'At least 8 characters',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                setState(() {});
              },
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (value) {
                if ((value ?? '').length < 8) {
                  return 'Password is too short';
                }
                return null;
              },
            ),

            Text('${_password.text.length} of 8', textAlign: TextAlign.right),

            const SizedBox(height: 16),

            // Confirm password
            TextFormField(
              controller: _confirm,
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                if (_agreed) {
                  _submit();
                }
              },
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (value) {
                if ((value ?? '') != _password.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Group
            DropdownButtonFormField<String>(
              initialValue: _group,
              decoration: const InputDecoration(
                labelText: 'Group',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final group in groups)
                  DropdownMenuItem<String>(value: group, child: Text(group)),
              ],
              onChanged: (value) {
                setState(() {
                  _group = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Choose a group';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Date of birth
            TextFormField(
              controller: _birthController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date of birth',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _pickDate,
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (value) {
                if (_birth == null) {
                  return 'Choose your birth date';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Agreement
            CheckboxListTile(
              title: const Text('I agree to the rules'),
              value: _agreed,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  _agreed = value ?? false;
                });
              },
            ),

            const SizedBox(height: 24),

            // Submit button
            FilledButton(
              onPressed: _agreed ? _submit : null,
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SummaryCard(
            name: _name.text,
            email: _email.text,
            group: _group ?? '',
            birthDate: _birthController.text,
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: _startOver, child: const Text('Start over')),
        ],
      ),
    );
  }
}
