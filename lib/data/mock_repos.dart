import 'dart:async';

import '../domain/models.dart';
import '../domain/offer_rule.dart';
import '../domain/repos.dart';
import '../domain/settings.dart';
import '../domain/user.dart';
import 'mock_menu.dart';
import 'mock_rules.dart';

class InMemoryAuthRepository implements AuthRepository {
  UserProfile? _user;

  @override
  Future<UserProfile?> currentUser() async => _user;

  @override
  Future<UserProfile> signUp({
    required String email,
    String? phone,
    bool isStudent = false,
    Map<ConsentType, Consent>? consents,
  }) async {
    final profile = UserProfile(
      id: 'user-1',
      email: email,
      phone: phone,
      isStudent: isStudent,
      phoneVerified: false,
      createdAt: DateTime.now(),
      consents: consents ?? UserProfile.createDefaultConsents(),
    );
    _user = profile;
    return profile;
  }

  @override
  Future<void> updateConsents(Map<ConsentType, Consent> consents) async {
    if (_user != null) {
      _user = _user!.copyWith(consents: consents);
    }
  }
}

class InMemoryMenuRepository implements MenuRepository {
  @override
  Future<List<MenuItem>> fetchMenu() async => kMenuItems;

  @override
  Future<List<Topping>> fetchToppings() async => kDemoToppings;
}

class InMemoryOrderRepository implements OrderRepository {
  final List<List<CartLine>> submitted = [];

  @override
  Future<void> submitOrder(List<CartLine> lines) async {
    submitted.add(List<CartLine>.from(lines));
  }
}

class InMemoryOffersRepository implements OffersRepository {
  final List<OfferRule> _rules =
      kDefaultOfferRules.map((rule) => OfferRule(
            id: rule.id,
            title: rule.title,
            trigger: rule.trigger,
            eventKey: rule.eventKey,
            percentOff: rule.percentOff,
            oneTime: rule.oneTime,
            enabled: rule.enabled,
          )).toList();

  @override
  Future<List<OfferRule>> fetchRules() async => _rules;

  @override
  Future<void> updateRule(OfferRule rule) async {
    final index = _rules.indexWhere((r) => r.id == rule.id);
    if (index != -1) {
      _rules[index] = rule;
    }
  }
}

class InMemorySettingsRepository implements SettingsRepository {
  AdminSettings _settings = AdminSettings(
    preorderEnabled: true,
    slotIntervalMinutes: 30,
    leadTimeMinutes: 45,
    openHour: 11,
    closeHour: 22,
    pickupDiscountPercent: 10,
    activeEventKey: 'champions_league',
  );

  @override
  Future<AdminSettings> fetchSettings() async => _settings;

  @override
  Future<void> saveSettings(AdminSettings settings) async {
    _settings = settings;
  }
}
