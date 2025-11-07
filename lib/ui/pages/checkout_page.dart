import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils.dart';
import '../../domain/settings.dart';
import '../../state/app_state.dart';
import '../widgets/kitchen_ticket_view.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  static const routeName = '/checkout';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final slots = state.preorderSlots;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Lieferoption',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: DeliveryMethod.values.map((method) {
              final selected = state.deliveryMethod == method;
              return ChoiceChip(
                label: Text(method == DeliveryMethod.delivery
                    ? 'Lieferung'
                    : 'Abholung'),
                selected: selected,
                onSelected: (_) => state.setDeliveryMethod(method),
              );
            }).toList(),
          ),
          if (state.isPickup)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Abhol-Rabatt aktiv: -${state.pickupDiscountPercent.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          const SizedBox(height: 24),
          Text(
            'Vorbestellung',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<DateTime?>(
            value: state.selectedPreorderSlot,
            items: [
              DropdownMenuItem(
                value: null,
                child: const Text('Sofort'),
              ),
              ...slots.map(
                (slot) => DropdownMenuItem(
                  value: slot,
                  child: Text(formatSlot(slot)),
                ),
              ),
            ],
            onChanged: state.adminSettings.preorderEnabled
                ? state.setPreorderSlot
                : null,
          ),
          const SizedBox(height: 24),
          Text(
            'Zahlung (Demo)',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: const [
              _PaymentChip(label: 'Karte (Stripe)'),
              _PaymentChip(label: 'Apple Pay'),
              _PaymentChip(label: 'Google Pay'),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              final linesSnapshot = List.of(state.cartLines);
              final totalSnapshot = state.total;
              await state.completeOrder();
              if (context.mounted) {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder: (_) => KitchenTicketView(
                    lines: linesSnapshot,
                    total: totalSnapshot,
                  ),
                );
              }
            },
            child: Text('Jetzt bezahlen (Demo) – ${formatCurrency(state.total)}'),
          ),
        ],
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: false,
      onSelected: (_) {},
    );
  }
}
