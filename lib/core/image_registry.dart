import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

/// Base64 encoded PNG placeholders for menu imagery to avoid binary assets.
const Map<String, String> _menuImageBase64 = {
  'pizza_marg':
      'iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAIAAAC2BqGFAAABSElEQVR4nO3OQQ0AIAwAsfm3hTDmgnuUpAI698z3QD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANEP0D0A0Q/QPQDRD9A9ANE3zPu+Y/n+CNkwAAAABJRU5ErkJggg==',
  'pizza_funghi':
      'iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAIAAAC2BqGFAAAA7ElEQVR4nO3QAQkAIADAMPtjHJOYyBYKd/AAZ2OvqQuN5wefBBp0K9CgW4EG3Qo06FagQbcCDboVaNCtQINuBRp0K9CgW4EG3Qo06FagQbcCDboVaNCtQINuBRp0K9CgW4EG3Qo06FagQbcCDboVaNCtQINuBRp0K9CgW4EG3Qo06FagQbcCDboVaNCtQINuBRp0K9CgW4EG3Qo06FagQbcCDboVaNCtQINuBRp0K9CgW4EG3Qo06FagQbcCDboVaNCtQINuBRp0K9CgW4EG3eoAgVZ7Td7t2a8AAAAASUVORK5CYII=',
  'pizza_4cheese':
      'iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAIAAAC2BqGFAAAA60lEQVR4nO3QAQkAIADAMPsXsZsltIXCHTzA2dhr6kLj+cEngQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtzqw9Cxx7L93pQAAAABJRU5ErkJggg==',
  'pizza_pepperoni':
      'iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAIAAAC2BqGFAAAA7UlEQVR4nO3QAQkAIADAMGtYyf4ZzGELhTt4gLOx19SFxvODTwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag251AG1aTnlOR008AAAAAElFTkSuQmCC',
  'salad_greek':
      'iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAIAAAC2BqGFAAAA60lEQVR4nO3QQQkAIADAQAP6sKkVbaEwDxZg3Jh76ULj+cEngQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtzo6R775jy008QAAAABJRU5ErkJggg==',
  'drink_cola':
      'iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAIAAAC2BqGFAAAA7UlEQVR4nO3QQQkAIADAQBP5Mof949hCYR4swLix19SFxvODTwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag251AETwrjuQTgE+AAAAAElFTkSuQmCC',
  'drink_fanta':
      'iVBORw0KGgoAAAANSUhEUgAAAHgAAAB4CAIAAAC2BqGFAAAA6klEQVR4nO3QAQkAIADAMMtaxtLaQuEOHuBs7DV1ofH84JNAg24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbgQbdCjToVqBBtwINuhVo0K1Ag24FGnQr0KBbHcIBkdUEEKbqAAAAAElFTkSuQmCC',
};

final Map<String, Uint8List> _decodedCache = {};

Uint8List menuImageBytes(String key) {
  return _decodedCache.putIfAbsent(key, () {
    final data = _menuImageBase64[key];
    if (data == null) {
      throw ArgumentError('Unknown menu image key: $key');
    }
    return base64Decode(data);
  });
}

ImageProvider menuImageProvider(String key) => MemoryImage(menuImageBytes(key));

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
