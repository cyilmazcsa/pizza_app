import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils.dart';
import '../../domain/models.dart';
import '../../state/app_state.dart';

class DesignerPage extends StatefulWidget {
  const DesignerPage({super.key});

  static const routeName = '/designer';

  @override
  State<DesignerPage> createState() => _DesignerPageState();
}

class _DesignerPageState extends State<DesignerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final toppings = state.toppings;
    final config = state.currentConfig;

    if (!state.pizzaRotating) {
      _controller.stop();
    } else {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dein Meisterwerk')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wähle deine Größe',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SizeChip(label: 'S (26 cm)', value: 26, groupValue: config.sizeCm),
                _SizeChip(label: 'M (30 cm)', value: 30, groupValue: config.sizeCm),
                _SizeChip(label: 'L (34 cm)', value: 34, groupValue: config.sizeCm),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => state.togglePizzaRotation(),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final angle = state.pizzaRotating
                          ? _controller.value * 2 * pi
                          : 0.0;
                      return Transform.rotate(
                        angle: angle,
                        child: child,
                      );
                    },
                    child: _PizzaCanvas(config: config, toppings: toppings),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                FilterChip(
                  selected: config.dough == DoughType.italian,
                  onSelected: (_) => state.toggleDough(DoughType.italian),
                  label: const Text('Italienisch'),
                ),
                FilterChip(
                  selected: config.dough == DoughType.american,
                  onSelected: (_) => state.toggleDough(DoughType.american),
                  label: const Text('Amerikanisch'),
                ),
                FilterChip(
                  selected: config.crust == CrustEdge.cheeseCrust,
                  onSelected: (value) => state.toggleCrust(value),
                  label: const Text('Cheese Crust'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final topping = toppings[index];
                  final selected = config.toppingIds.contains(topping.id);
                  return ChoiceChip(
                    label: Text('${topping.emoji} ${topping.name}'),
                    selected: selected,
                    onSelected: (_) => state.toggleTopping(topping.id),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: toppings.length,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () =>
                            state.setDesignerQuantity(state.designerQuantity - 1),
                        icon: const Icon(Icons.remove),
                      ),
                      Text('x${state.designerQuantity}'),
                      IconButton(
                        onPressed: () =>
                            state.setDesignerQuantity(state.designerQuantity + 1),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  formatCurrency(state.currentConfigPrice),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => state.addDesignerToCart(),
              child: const Text('Übernehmen und in den Warenkorb'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.label,
    required this.value,
    required this.groupValue,
  });

  final String label;
  final double value;
  final double groupValue;

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return ChoiceChip(
      label: Text(label),
      selected: value == groupValue,
      onSelected: (_) => state.setDesignerSize(value),
    );
  }
}

class _PizzaCanvas extends StatelessWidget {
  const _PizzaCanvas({required this.config, required this.toppings});

  final PizzaConfig config;
  final List<Topping> toppings;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.6;
    final selectedToppings = toppings
        .where((element) => config.toppingIds.contains(element.id))
        .toList();
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.orange.shade100,
                  Colors.orange.shade200,
                  Colors.deepOrange.shade200,
                ],
              ),
            ),
          ),
          if (config.crust == CrustEdge.cheeseCrust)
            Container(
              width: size * 0.92,
              height: size * 0.92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.yellowAccent.withOpacity(0.6),
                  width: 12,
                ),
              ),
            ),
          for (var i = 0; i < selectedToppings.length; i++)
            _ToppingEmoji(
              emoji: selectedToppings[i].emoji,
              index: i,
              total: selectedToppings.length,
              radius: size * 0.35,
            ),
        ],
      ),
    );
  }
}

class _ToppingEmoji extends StatelessWidget {
  const _ToppingEmoji({
    required this.emoji,
    required this.index,
    required this.total,
    required this.radius,
  });

  final String emoji;
  final int index;
  final int total;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final angle = (2 * pi * index) / (total == 0 ? 1 : total);
    final offset = Offset(radius * cos(angle), radius * sin(angle));
    return Transform.translate(
      offset: offset,
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 32),
      ),
    );
  }
}
