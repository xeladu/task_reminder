import 'package:flutter/material.dart';

class AppColors {
  // Color palette
  static const Color _baseColorDarkest = Color.fromARGB(255, 21, 31, 38);
  static const Color _baseColorDarker = Color.fromARGB(255, 50, 72, 89);
  static const Color _baseColor = Color.fromARGB(255, 78, 114, 140);
  static const Color _baseColorBrighter = Color.fromARGB(255, 107, 155, 191);
  static const Color _baseColorBrightest = Color.fromARGB(255, 135, 197, 242);

  // Text colors
  static Color headingText = _baseColorBrightest;
  static Color subHeadingText = _baseColorBrighter;
  static Color description = _baseColorDarkest;
  static Color descriptionSecondary = _baseColor;
  static Color label = _baseColorBrighter;

  // Element background colors
  static Color appBackground = _baseColorDarkest;
  static Color appBackgroundSecondary = _baseColorDarker;
  static Color taskBackground = _baseColor;
  static Color dialogBackground = _baseColorDarker;
  static Color snackBarBackground = _baseColor;
  static Color splashBackground = _baseColorBrighter;

  static Color warning = const Color.fromARGB(255, 170, 170, 0);
  static Color error = const Color.fromARGB(255, 170, 0, 0);
  static Color success = const Color.fromARGB(255, 0, 170, 0);

  static Color icon = _baseColorBrightest;

  static MaterialColor primarySwatch = MaterialColor(0xFF87C5F2, _swatchColors);

  static final Map<int, Color> _swatchColors = {
    50: const Color.fromRGBO(135, 197, 242, .1),
    100: const Color.fromRGBO(135, 197, 242, .2),
    200: const Color.fromRGBO(135, 197, 242, .3),
    300: const Color.fromRGBO(135, 197, 242, .4),
    400: const Color.fromRGBO(135, 197, 242, .5),
    500: const Color.fromRGBO(135, 197, 242, .6),
    600: const Color.fromRGBO(135, 197, 242, .7),
    700: const Color.fromRGBO(135, 197, 242, .8),
    800: const Color.fromRGBO(135, 197, 242, .9),
    900: const Color.fromRGBO(135, 197, 242, 1),
  };
}
