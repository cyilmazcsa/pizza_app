import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils.dart';
import '../../domain/models.dart';
import '../../state/app_state.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final lines = state.cartLines;

    return Scaffold(
      appBar: AppBar(title: const Text('Warenkorb')),
      body: lines.isEmpty
          ? const Center(child: Text('Dein Warenkorb ist leer.'))
          : Column(
              children: [
                if (state.activeOfferPercent > 0)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      'Angebot aktiv: -${state.activeOfferPercent.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: lines.length,
                    itemBuilder: (context, index) {
                      final line = lines[index];
                      return _CartLineTile(line: line);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Zwischensumme',
                        value: formatCurrency(state.subtotal),
                      ),
                      _SummaryRow(
                        label:
                            'Rabatt (${state.activeOfferPercent.toStringAsFixed(0)}%)',
                        value: '-${formatCurrency(state.discountAmount)}',
                      ),
                      if (state.pickupDiscountPercent > 0)
                        _SummaryRow(
                          label:
                              'Abhol-Rabatt (${state.pickupDiscountPercent.toStringAsFixed(0)}%)',
                          value: '-${formatCurrency(state.pickupDiscountAmount)}',
                        ),
                      const Divider(),
                      _SummaryRow(
                        label: 'Gesamt',
                        value: formatCurrency(state.total),
                        bold: true,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          CheckoutPage.routeName,
                        ),
                        child: const Text('Zur Kasse'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.line});

  final CartLine line;

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
                    line.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => state.removeLine(line),
                ),
              ],
            ),
            if (line.config != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(state.describeConfig(line)),
              ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => state.decreaseQty(line),
                      ),
                      Text('${line.qty}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => state.increaseQty(line),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  formatCurrency(line.total),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
