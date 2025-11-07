import 'package:flutter/material.dart';
import '../../core/utils.dart';
import '../../domain/models.dart';

class KitchenTicketView extends StatelessWidget {
  const KitchenTicketView({super.key, required this.lines, required this.total});

  final List<CartLine> lines;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Küchenbon (Demo)',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${line.qty}× ${line.title}',
                      style: Theme.of(context).textTheme.titleMedium),
                  if (line.config != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _describe(line),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
          const Divider(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Gesamt: ${formatCurrency(total)}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _describe(CartLine line) {
    final config = line.config;
    if (config == null) return '';
    final buffer = StringBuffer();
    buffer.write('${config.sizeCm.toStringAsFixed(0)} cm');
    buffer.write(', ');
    buffer.write(config.dough == DoughType.italian ? 'Italienisch' : 'Amerikanisch');
    buffer.write(', ');
    buffer.write(config.crust == CrustEdge.cheeseCrust ? 'Cheese Crust' : 'Normaler Rand');
    if (config.toppingIds.isNotEmpty) {
      buffer.write('\nToppings: ${config.toppingIds.join(', ')}');
    }
    return buffer.toString();
  }
}
