import 'package:flutter/material.dart';

import '../../core/image_registry.dart';

class SpecialsPage extends StatelessWidget {
  const SpecialsPage({super.key});

  static const routeName = '/specials';

  @override
  Widget build(BuildContext context) {
    final specials = [
      _SpecialCardData(
        title: 'Champions League Nacht',
        description: 'Fan-Angebot mit Gratis-Dip.',
        image: 'pizza_pepperoni',
        tag: 'champions_league',
      ),
      _SpecialCardData(
        title: 'Super Bowl Party',
        description: 'Family-Bundles mit Getränken.',
        image: 'pizza_4cheese',
        tag: 'super_bowl',
      ),
      _SpecialCardData(
        title: 'El Clásico Abend',
        description: 'Zwei große Pizzen + Salat.',
        image: 'pizza_funghi',
        tag: 'el_clasico',
      ),
      _SpecialCardData(
        title: 'Family Friday',
        description: '4er Paket für Großfamilien.',
        image: 'salad_greek',
        tag: 'family_friday',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Specials')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: specials.length,
        itemBuilder: (context, index) {
          final data = specials[index];
          return _SpecialCard(data: data);
        },
      ),
    );
  }
}

class _SpecialCardData {
  _SpecialCardData({
    required this.title,
    required this.description,
    required this.image,
    required this.tag,
  });

  final String title;
  final String description;
  final String image;
  final String tag;
}

class _SpecialCard extends StatelessWidget {
  const _SpecialCard({required this.data});

  final _SpecialCardData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: menuImageWidget(
              data.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(data.description),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Jetzt sichern'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
