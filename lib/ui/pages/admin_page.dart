import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/offer_rule.dart';
import '../../domain/settings.dart';
import '../../state/app_state.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  static const routeName = '/admin';

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();

  late bool _preorderEnabled;
  late int _slotInterval;
  late int _leadTime;
  late int _openHour;
  late int _closeHour;
  late double _pickupDiscount;
  String? _eventKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = context.read<AppState>().adminSettings;
    _preorderEnabled = settings.preorderEnabled;
    _slotInterval = settings.slotIntervalMinutes;
    _leadTime = settings.leadTimeMinutes;
    _openHour = settings.openHour;
    _closeHour = settings.closeHour;
    _pickupDiscount = settings.pickupDiscountPercent;
    _eventKey = settings.activeEventKey;
  }

  void _saveSettings(AppState state) {
    state.updateAdminSettings(AdminSettings(
      preorderEnabled: _preorderEnabled,
      slotIntervalMinutes: _slotInterval,
      leadTimeMinutes: _leadTime,
      openHour: _openHour,
      closeHour: _closeHour,
      pickupDiscountPercent: _pickupDiscount,
      activeEventKey: _eventKey,
    ));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Gespeichert')));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final rules = state.offerRules;

    return Scaffold(
      appBar: AppBar(title: const Text('Admin-Bereich')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            SwitchListTile(
              title: const Text('Vorbestellungen aktiv'),
              value: _preorderEnabled,
              onChanged: (value) => setState(() => _preorderEnabled = value),
            ),
            const SizedBox(height: 8),
            _NumberField(
              label: 'Slot-Intervall (Minuten)',
              initialValue: _slotInterval.toString(),
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                _slotInterval = int.parse(value);
              },
            ),
            _NumberField(
              label: 'Vorbereitungszeit (Minuten)',
              initialValue: _leadTime.toString(),
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                _leadTime = int.parse(value);
              },
            ),
            _NumberField(
              label: 'Öffnungsstunde',
              initialValue: _openHour.toString(),
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                _openHour = int.parse(value);
              },
            ),
            _NumberField(
              label: 'Schließstunde',
              initialValue: _closeHour.toString(),
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                _closeHour = int.parse(value);
              },
            ),
            _NumberField(
              label: 'Abhol-Rabatt (%)',
              initialValue: _pickupDiscount.toStringAsFixed(0),
              onSaved: (value) {
                if (value == null) {
                  return;
                }
                _pickupDiscount = double.parse(value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String?>(
              value: _eventKey,
              decoration: const InputDecoration(labelText: 'Event-Tag'),
              items: const [
                DropdownMenuItem(value: null, child: Text('Keiner')),
                DropdownMenuItem(
                    value: 'champions_league', child: Text('Champions League')),
                DropdownMenuItem(value: 'super_bowl', child: Text('Super Bowl')),
                DropdownMenuItem(value: 'el_clasico', child: Text('El Clásico')),
              ],
              onChanged: (value) => setState(() => _eventKey = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _formKey.currentState?.save();
                _saveSettings(state);
              },
              child: const Text('Einstellungen speichern'),
            ),
            const SizedBox(height: 32),
            Text(
              'Angebotsregeln',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (final rule in rules) _RuleTile(rule: rule),
          ],
        ),
      ),
    );
  }
}

class _RuleTile extends StatefulWidget {
  const _RuleTile({required this.rule});

  final OfferRule rule;

  @override
  State<_RuleTile> createState() => _RuleTileState();
}

class _RuleTileState extends State<_RuleTile> {
  late double _percent;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _percent = widget.rule.percentOff;
    _enabled = widget.rule.enabled;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.rule.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Switch(
                  value: _enabled,
                  onChanged: (value) {
                    setState(() => _enabled = value);
                    state.updateOfferRule(widget.rule..enabled = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(_describeRule(widget.rule)),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: _percent.toStringAsFixed(0),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Prozent'),
              onChanged: (value) {
                final parsed = double.tryParse(value) ?? _percent;
                setState(() => _percent = parsed);
                state.updateOfferRule(widget.rule..percentOff = parsed);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _describeRule(OfferRule rule) {
    switch (rule.trigger) {
      case RuleTrigger.firstOrder:
        return 'Erster Bestellung - einmalig';
      case RuleTrigger.inactivity30d:
        return 'Inaktiv seit 30 Tagen - einmalig';
      case RuleTrigger.studentVerified:
        return 'Studentenstatus bestätigt';
      case RuleTrigger.eventTag:
        return 'Event: ${rule.eventKey ?? 'n/a'}';
    }
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.initialValue,
    required this.onSaved,
  });

  final String label;
  final String initialValue;
  final FormFieldSetter<String>? onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onSaved: onSaved,
      ),
    );
  }
}
