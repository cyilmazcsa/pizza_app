import 'package:flutter/widgets.dart';

const Map<String, String> _menuImageAssets = {
  'pizza_marg': 'assets/images/pizza_marg.jpg',
  'pizza_funghi': 'assets/images/pizza_funghi.jpg',
  'pizza_4cheese': 'assets/images/pizza_4cheese.jpg',
  'pizza_pepperoni': 'assets/images/pizza_pepperoni.jpg',
  'special_champions': 'assets/images/special_champions.png',
  'special_superbowl': 'assets/images/special_superbowl.png',
  'special_el_clasico': 'assets/images/special_el_clasico.png',
  'special_family': 'assets/images/special_family.png',
  'salad_greek': 'assets/images/salad_greek.jpg',
  'drink_cola': 'assets/images/drink_cola.jpg',
  'drink_fanta': 'assets/images/drink_fanta.jpg',
};

const Map<String, String> _toppingImageAssets = {
  'olives': 'assets/images/topping_olives.png',
};

String? toppingImageAsset(String id) => _toppingImageAssets[id];

ImageProvider menuImageProvider(String key) {
  final asset = _menuImageAssets[key];
  if (asset == null) {
    throw ArgumentError('Unknown menu image key: $key');
  }
  return AssetImage(asset);
}

Image menuImageWidget(
  String key, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  AlignmentGeometry alignment = Alignment.center,
}) {
  return Image(
    image: menuImageProvider(key),
    fit: fit,
    width: width,
    height: height,
    alignment: alignment,
  );
}
