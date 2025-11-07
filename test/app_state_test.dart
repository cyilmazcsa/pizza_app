import 'package:flutter_test/flutter_test.dart';

import 'package:customizza/data/mock_rules.dart';
import 'package:customizza/data/mock_repos.dart';
import 'package:customizza/domain/models.dart';
import 'package:customizza/domain/settings.dart';
import 'package:customizza/domain/user.dart';
import 'package:customizza/state/app_state.dart';

void main() {
  AppState createState() {
    return AppState(
      authRepository: InMemoryAuthRepository(),
      menuRepository: InMemoryMenuRepository(),
      orderRepository: InMemoryOrderRepository(),
      offersRepository: InMemoryOffersRepository(),
      settingsRepository: InMemorySettingsRepository(),
    );
  }

  test('calculates pizza price with modifiers', () {
    final state = createState();
    final config = PizzaConfig(
      dough: DoughType.american,
      crust: CrustEdge.cheeseCrust,
      sizeCm: 34,
      toppingIds: const ['ham', 'corn'],
    );

    final price = state.calculateConfigPrice(config);
    expect(price, closeTo(14.4, 0.01));
  });

  test('selects best applicable offer', () {
    final state = createState();
    state.offerRules = kDefaultOfferRules;
    state.adminSettings = AdminSettings(activeEventKey: 'super_bowl');
    state.user = UserProfile(
      id: 'u1',
      email: 'demo@example.com',
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
      lastOrderAt: DateTime.now().subtract(const Duration(days: 40)),
      isStudent: true,
    );

    final percent = state.activeOfferPercent;
    expect(percent, 20);
  });
}
