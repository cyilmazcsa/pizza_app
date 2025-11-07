enum DeliveryMethod { delivery, pickup }

class AdminSettings {
  AdminSettings({
    this.preorderEnabled = true,
    this.slotIntervalMinutes = 30,
    this.leadTimeMinutes = 45,
    this.openHour = 11,
    this.closeHour = 22,
    this.pickupDiscountPercent = 10,
    this.activeEventKey,
  });

  bool preorderEnabled;
  int slotIntervalMinutes;
  int leadTimeMinutes;
  int openHour;
  int closeHour;
  double pickupDiscountPercent;
  String? activeEventKey;
}
