import 'package:flutter/widgets.dart';

const Map<String, String> _menuImageUrls = {
  'pizza_marg':
      'https://upload.wikimedia.org/wikipedia/commons/4/4b/Margherita_Originale.jpg',
  'pizza_funghi':
      'https://upload.wikimedia.org/wikipedia/commons/1/1d/Pizza_funghi.jpg',
  'pizza_4cheese':
      'https://upload.wikimedia.org/wikipedia/commons/3/33/Pizza_quattro_formaggi.jpg',
  'pizza_pepperoni':
      'https://upload.wikimedia.org/wikipedia/commons/d/d3/Supreme_pizza.jpg',
  'salad_greek':
      'https://upload.wikimedia.org/wikipedia/commons/9/9e/Greek_salad.jpg',
  'drink_cola':
      'https://upload.wikimedia.org/wikipedia/commons/5/5a/Coca-Cola_glass.jpg',
  'drink_fanta':
      'https://upload.wikimedia.org/wikipedia/commons/8/86/Fanta_Orange_%282019%29.jpg',
};

const Map<String, String> _toppingImageUrls = {
  'olives':
      'https://upload.wikimedia.org/wikipedia/commons/1/1b/Green_olive_with_pit.jpg',
};

String? toppingImageUrl(String id) => _toppingImageUrls[id];

ImageProvider menuImageProvider(String key) {
  final url = _menuImageUrls[key];
  if (url == null) {
    throw ArgumentError('Unknown menu image key: $key');
  }
  return NetworkImage(url);
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
