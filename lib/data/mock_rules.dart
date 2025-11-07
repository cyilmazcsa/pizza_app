import '../domain/offer_rule.dart';

final List<OfferRule> kDefaultOfferRules = [
  OfferRule(
    id: 'first_order',
    title: 'Willkommensrabatt',
    trigger: RuleTrigger.firstOrder,
    percentOff: 15,
    oneTime: true,
  ),
  OfferRule(
    id: 'inactive_30',
    title: 'Komm zurück! 30 Tage inaktiv',
    trigger: RuleTrigger.inactivity30d,
    percentOff: 10,
    oneTime: true,
  ),
  OfferRule(
    id: 'student_verified',
    title: 'Studentenrabatt',
    trigger: RuleTrigger.studentVerified,
    percentOff: 12,
  ),
  OfferRule(
    id: 'event_champs',
    title: 'Champions League Special',
    trigger: RuleTrigger.eventTag,
    percentOff: 18,
    eventKey: 'champions_league',
  ),
  OfferRule(
    id: 'event_superbowl',
    title: 'Super Bowl Deal',
    trigger: RuleTrigger.eventTag,
    percentOff: 20,
    eventKey: 'super_bowl',
  ),
  OfferRule(
    id: 'event_clasico',
    title: 'El Clásico Fest',
    trigger: RuleTrigger.eventTag,
    percentOff: 16,
    eventKey: 'el_clasico',
  ),
];
