import 'dart:math';

import 'package:flutter/material.dart';

import '../core/utils.dart';
import '../data/mock_menu.dart';
import '../domain/models.dart';
import '../domain/offer_rule.dart';
import '../domain/repos.dart';
import '../domain/settings.dart';
import '../domain/user.dart';

class AppState extends ChangeNotifier {
  AppState({
    required this.authRepository,
    required this.menuRepository,
    required this.orderRepository,
    required this.offersRepository,
    required this.settingsRepository,
  });

  final AuthRepository authRepository;
  final MenuRepository menuRepository;
  final OrderRepository orderRepository;
  final OffersRepository offersRepository;
  final SettingsRepository settingsRepository;

  List<MenuItem> menu = const [];
  List<Topping> toppings = kDemoToppings;
  List<CartLine> cartLines = [];
  List<OfferRule> offerRules = [];
  AdminSettings adminSettings = AdminSettings();
  UserProfile? user;

  PizzaConfig currentConfig = PizzaConfig(
    dough: DoughType.italian,
    crust: CrustEdge.none,
    sizeCm: 30,
  );
  int designerQuantity = 1;
  bool pizzaRotating = false;

  DeliveryMethod deliveryMethod = DeliveryMethod.delivery;
  DateTime? selectedPreorderSlot;
  List<DateTime> preorderSlots = [];

  bool get isPickup => deliveryMethod == DeliveryMethod.pickup;

  double get currentConfigPrice => calculateConfigPrice(currentConfig);

  double calculateConfigPrice(PizzaConfig config) {
    double price = 6.9;
    if (config.sizeCm >= 30 && config.sizeCm < 34) {
      price += 1;
    } else if (config.sizeCm >= 34) {
      price += 2;
    }

    if (config.dough == DoughType.american) {
      price += 1;
    }
    if (config.crust == CrustEdge.cheeseCrust) {
      price += 2;
    }

    final toppingMap = {for (final t in toppings) t.id: t};
    for (final toppingId in config.toppingIds) {
      final topping = toppingMap[toppingId];
      if (topping == null) continue;
      price += topping.isMeat ? 1.5 : 1.0;
    }
    return price;
  }

  double get subtotal =>
      cartLines.fold(0, (previousValue, line) => previousValue + line.total);

  double get activeOfferPercent {
    if (offerRules.isEmpty) return 0;
    final applicable = offerRules.where(_ruleApplies).toList();
    if (applicable.isEmpty) return 0;
    return applicable.map((e) => e.percentOff).reduce(max);
  }

  double get pickupDiscountPercent =>
      isPickup ? adminSettings.pickupDiscountPercent : 0;

  double get discountAmount => subtotal * (activeOfferPercent / 100);

  double get pickupDiscountAmount =>
      (subtotal - discountAmount) * (pickupDiscountPercent / 100);

  double get total => subtotal - discountAmount - pickupDiscountAmount;

  Future<void> load() async {
    user = await authRepository.currentUser();
    menu = await menuRepository.fetchMenu();
    toppings = await menuRepository.fetchToppings();
    offerRules = await offersRepository.fetchRules();
    adminSettings = await settingsRepository.fetchSettings();
    _generatePreorderSlots();
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    String? phone,
    bool isStudent = false,
  }) async {
    final consents = user?.consents ?? UserProfile.createDefaultConsents();
    user = await authRepository.signUp(
      email: email,
      phone: phone,
      isStudent: isStudent,
      consents: consents,
    );
    notifyListeners();
  }

  void setStudent(bool value) {
    if (user != null) {
      user = user!.copyWith(isStudent: value);
      notifyListeners();
    }
  }

  void updateConsent(ConsentType type, bool granted) {
    final current = user ??
        UserProfile(
          id: 'temp',
          email: '',
          createdAt: DateTime.now(),
        );
    final map = Map<ConsentType, Consent>.from(current.consents);
    map[type] = map[type]!.copyWith(
      granted: granted,
      updatedAt: DateTime.now(),
    );
    if (user != null) {
      user = user!.copyWith(consents: map);
      authRepository.updateConsents(map);
    }
    notifyListeners();
  }

  void verifyPhone() {
    if (user != null) {
      user = user!.copyWith(phoneVerified: true);
      notifyListeners();
    }
  }

  void setDesignerSize(double size) {
    currentConfig = currentConfig.copyWith(sizeCm: size);
    notifyListeners();
  }

  void toggleDough(DoughType dough) {
    currentConfig = currentConfig.copyWith(dough: dough);
    notifyListeners();
  }

  void toggleCrust(bool cheeseCrust) {
    currentConfig = currentConfig.copyWith(
      crust: cheeseCrust ? CrustEdge.cheeseCrust : CrustEdge.none,
    );
    notifyListeners();
  }

  void toggleTopping(String toppingId) {
    final toppingsList = currentConfig.toppingIds.toList();
    if (toppingsList.contains(toppingId)) {
      toppingsList.remove(toppingId);
    } else {
      toppingsList.add(toppingId);
    }
    currentConfig = currentConfig.copyWith(toppingIds: toppingsList);
    notifyListeners();
  }

  void setDesignerQuantity(int qty) {
    designerQuantity = max(1, qty);
    notifyListeners();
  }

  void addDesignerToCart() {
    for (var i = 0; i < designerQuantity; i++) {
      cartLines.add(CartLine(
        id: 'custom-${DateTime.now().millisecondsSinceEpoch}-$i',
        title: 'Custom Pizza',
        qty: 1,
        unitPrice: currentConfigPrice,
        config: currentConfig,
      ));
    }
    designerQuantity = 1;
    notifyListeners();
  }

  void addMenuItem(MenuItem item) {
    final config = item.preset;
    cartLines.add(CartLine(
      id: '${item.id}-${DateTime.now().millisecondsSinceEpoch}',
      title: item.title,
      qty: 1,
      unitPrice: config != null ? calculateConfigPrice(config) : item.basePrice,
      config: config,
    ));
    notifyListeners();
  }

  void increaseQty(CartLine line) {
    line.qty += 1;
    notifyListeners();
  }

  void decreaseQty(CartLine line) {
    if (line.qty > 1) {
      line.qty -= 1;
    } else {
      cartLines.remove(line);
    }
    notifyListeners();
  }

  void removeLine(CartLine line) {
    cartLines.remove(line);
    notifyListeners();
  }

  void setDeliveryMethod(DeliveryMethod method) {
    deliveryMethod = method;
    notifyListeners();
  }

  void setPreorderSlot(DateTime? slot) {
    selectedPreorderSlot = slot;
    notifyListeners();
  }

  void togglePizzaRotation() {
    pizzaRotating = !pizzaRotating;
    notifyListeners();
  }

  void updateOfferRule(OfferRule rule) {
    final index = offerRules.indexWhere((element) => element.id == rule.id);
    if (index != -1) {
      offerRules[index] = rule;
      offersRepository.updateRule(rule);
      notifyListeners();
    }
  }

  void updateAdminSettings(AdminSettings settings) {
    adminSettings = settings;
    settingsRepository.saveSettings(settings);
    _generatePreorderSlots();
    notifyListeners();
  }

  void _generatePreorderSlots() {
    preorderSlots = [];
    if (!adminSettings.preorderEnabled) {
      return;
    }
    final now = DateTime.now().add(Duration(minutes: adminSettings.leadTimeMinutes));
    final today = DateTime(now.year, now.month, now.day);
    DateTime slot = DateTime(
      today.year,
      today.month,
      today.day,
      adminSettings.openHour,
    );
    final closeTime = DateTime(
      today.year,
      today.month,
      today.day,
      adminSettings.closeHour,
    );
    while (slot.isBefore(closeTime) || slot.isAtSameMomentAs(closeTime)) {
      if (slot.isAfter(now)) {
        preorderSlots.add(slot);
      }
      slot = slot.add(Duration(minutes: adminSettings.slotIntervalMinutes));
    }
  }

  bool _ruleApplies(OfferRule rule) {
    if (!rule.enabled) return false;
    switch (rule.trigger) {
      case RuleTrigger.firstOrder:
        return user?.lastOrderAt == null;
      case RuleTrigger.inactivity30d:
        final lastOrder = user?.lastOrderAt;
        if (lastOrder == null) return false;
        return DateTime.now().difference(lastOrder).inDays >= 30;
      case RuleTrigger.eventTag:
        return adminSettings.activeEventKey != null &&
            adminSettings.activeEventKey == rule.eventKey;
      case RuleTrigger.studentVerified:
        return user?.isStudent == true;
    }
  }

  Future<void> completeOrder() async {
    await orderRepository.submitOrder(cartLines);
    user = user?.copyWith(lastOrderAt: DateTime.now());
    cartLines = [];
    notifyListeners();
  }

  String describeConfig(CartLine line) {
    final config = line.config;
    if (config == null) return '';
    final buffer = StringBuffer();
    buffer.write(describePizzaSize(config.sizeCm));
    buffer.write(', ');
    buffer.write(config.dough == DoughType.italian ? 'Italienisch' : 'Amerikanisch');
    buffer.write(', ');
    buffer.write(config.crust == CrustEdge.cheeseCrust ? 'Cheese Crust' : 'Normaler Rand');
    if (config.toppingIds.isNotEmpty) {
      buffer.write('\nToppings: ');
      final toppingMap = {for (final t in toppings) t.id: t};
      buffer.write(config.toppingIds
          .map((id) => toppingMap[id]?.name ?? id)
          .join(', '));
    }
    return buffer.toString();
  }
}
