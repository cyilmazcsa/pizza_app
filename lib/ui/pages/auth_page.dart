import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/user.dart';
import '../../state/app_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  static const routeName = '/auth';

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _student = false;
  final Map<ConsentType, bool> _consents = {
    for (final type in ConsentType.values) type: false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AppState>().user;
    if (user != null) {
      for (final entry in user.consents.entries) {
        _consents[entry.key] = entry.value.granted;
      }
      _student = user.isStudent;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Registrierung')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Schnell anmelden',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _showAuthSnack(context, 'Apple'),
            icon: const Icon(Icons.apple),
            label: const Text('Mit Apple anmelden'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showAuthSnack(context, 'Gmail'),
            icon: const Icon(Icons.mail_outline),
            label: const Text('Mit Gmail anmelden'),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  validator: (value) =>
                      value != null && value.contains('@') ? null : 'Ungültige E-Mail',
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefon (optional)'),
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  value: _student,
                  onChanged: (value) => setState(() => _student = value),
                  title: const Text('Student/Schule verifiziert'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Einwilligungen',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...ConsentType.values.map(
                  (type) => SwitchListTile(
                    value: _consents[type]!,
                    title: Text(_labelForConsent(type)),
                    onChanged: (value) =>
                        setState(() => _consents[type] = value),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await state.signUp(
                        email: _emailController.text,
                        phone: _phoneController.text.isEmpty
                            ? null
                            : _phoneController.text,
                        isStudent: _student,
                      );
                      for (final entry in _consents.entries) {
                        state.updateConsent(entry.key, entry.value);
                      }
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registrierung gespeichert')),
                        );
                      }
                    }
                  },
                  child: const Text('Speichern'),
                ),
                const SizedBox(height: 24),
                if (user != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aktuelle Daten:',
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('E-Mail: ${user.email}'),
                      Text('Telefon: ${user.phone ?? '-'}'),
                      Text('Student: ${user.isStudent ? 'Ja' : 'Nein'}'),
                      Text('Telefon verifiziert: ${user.phoneVerified ? 'Ja' : 'Nein'}'),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: () => state.verifyPhone(),
                        child: const Text('Telefon verifizieren (Demo)'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _labelForConsent(ConsentType type) {
    switch (type) {
      case ConsentType.email:
        return 'E-Mail Marketing';
      case ConsentType.push:
        return 'Push-Benachrichtigungen';
      case ConsentType.sms:
        return 'SMS Updates';
      case ConsentType.analytics:
        return 'Analytics Zustimmung';
    }
  }

  void _showAuthSnack(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider Login ist in der Demo aktiviert.')),
    );
  }
}
