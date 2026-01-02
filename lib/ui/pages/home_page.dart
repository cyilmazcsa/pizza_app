import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/image_registry.dart';
import '../../core/l10n.dart';
import '../../domain/models.dart';
import '../../state/app_state.dart';
import '../widgets/popular_card.dart';
import '../widgets/section_header.dart';
import 'admin_page.dart';
import 'auth_page.dart';
import 'specials_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final popular = state.menu.where((item) => item.isPizza).toList();
    final recentOrders = state.menu.where((item) => item.isPizza).take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () =>
                Navigator.pushNamed(context, AdminPage.routeName),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AuthPage.routeName),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          Text(
            'Guten Appetit 👋',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Starte deinen Abend mit deinen Favoriten.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: strings.t('searchHint'),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 24),
          if (recentOrders.isNotEmpty) ...[
            SectionHeader(title: 'Meine letzten Bestellungen', onTap: () {}),
            const SizedBox(height: 12),
            Column(
              children: recentOrders
                  .map((item) => _RecentOrderCard(item: item))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],
          SectionHeader(title: strings.t('popularPizzas'), onTap: () {}),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popular.length,
              itemBuilder: (context, index) {
                final item = popular[index];
                return PopularCard(item: item);
              },
            ),
          ),
          const SizedBox(height: 32),
          SectionHeader(title: strings.t('nearbyTitle')),
          const SizedBox(height: 12),
          _NearbyHeroCard(),
        ],
      ),
    );
  }
}

class _RecentOrderCard extends StatelessWidget {
  const _RecentOrderCard({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: menuImageWidget(
            item.image,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(item.title),
        subtitle: Text(item.description),
        trailing: FilledButton.tonal(
          onPressed: () => context.read<AppState>().addMenuItem(item),
          child: const Text('Nochmal'),
        ),
      ),
    );
  }
}

class _NearbyHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: menuImageWidget(
              'pizza_marg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.t('nearbyTitle'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: () =>
                      Navigator.pushNamed(context, SpecialsPage.routeName),
                  child: Text(strings.t('nearbyCta')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
