enum DoughType { italian, american }

enum CrustEdge { none, cheeseCrust }

class Topping {
  Topping({
    required this.id,
    required this.name,
    required this.emoji,
    this.isMeat = false,
  });

  final String id;
  final String name;
  final String emoji;
  final bool isMeat;
}

class PizzaConfig {
  PizzaConfig({
    required this.dough,
    required this.crust,
    required this.sizeCm,
    List<String>? toppingIds,
  }) : toppingIds = List.unmodifiable(toppingIds ?? <String>[]);

  final DoughType dough;
  final CrustEdge crust;
  final double sizeCm;
  final List<String> toppingIds;

  PizzaConfig copyWith({
    DoughType? dough,
    CrustEdge? crust,
    double? sizeCm,
    List<String>? toppingIds,
  }) {
    return PizzaConfig(
      dough: dough ?? this.dough,
      crust: crust ?? this.crust,
      sizeCm: sizeCm ?? this.sizeCm,
      toppingIds: toppingIds ?? this.toppingIds,
    );
  }
}

class MenuItem {
  MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.basePrice,
    required this.isPizza,
    this.preset,
  });

  final String id;
  final String title;
  final String description;
  final String image;
  final double basePrice;
  final bool isPizza;
  final PizzaConfig? preset;
}

class CartLine {
  CartLine({
    required this.id,
    required this.title,
    required this.qty,
    required this.unitPrice,
    this.config,
  });

  final String id;
  final String title;
  int qty;
  double unitPrice;
  PizzaConfig? config;

  double get total => unitPrice * qty;
}
