import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/image_registry.dart';
import '../../core/l10n.dart';
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
          TextField(
            decoration: InputDecoration(
              hintText: strings.t('searchHint'),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 24),
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
