import 'models.dart';
import 'offer_rule.dart';
import 'settings.dart';
import 'user.dart';

abstract class AuthRepository {
  Future<UserProfile?> currentUser();
  Future<UserProfile> signUp({
    required String email,
    String? phone,
    bool isStudent,
    Map<ConsentType, Consent>? consents,
  });
  Future<void> updateConsents(Map<ConsentType, Consent> consents);
}

abstract class MenuRepository {
  Future<List<MenuItem>> fetchMenu();
  Future<List<Topping>> fetchToppings();
}

abstract class OrderRepository {
  Future<void> submitOrder(List<CartLine> lines);
  // TODO(phase2): integrate payment providers (Stripe, Apple Pay, Google Pay)
  // TODO(phase2): connect kitchen printing / dispatch systems
}

abstract class OffersRepository {
  Future<List<OfferRule>> fetchRules();
  Future<void> updateRule(OfferRule rule);
}

abstract class SettingsRepository {
  Future<AdminSettings> fetchSettings();
  Future<void> saveSettings(AdminSettings settings);
  // TODO(phase2): surface driver routing configuration
}
