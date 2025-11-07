enum RuleTrigger { firstOrder, inactivity30d, eventTag, studentVerified }

class OfferRule {
  OfferRule({
    required this.id,
    required this.title,
    required this.trigger,
    this.eventKey,
    required this.percentOff,
    this.oneTime = false,
    this.enabled = true,
  });

  final String id;
  final String title;
  final RuleTrigger trigger;
  final String? eventKey;
  double percentOff;
  final bool oneTime;
  bool enabled;
}
