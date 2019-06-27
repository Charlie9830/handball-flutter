import 'package:flutter/material.dart';

class UserColor {
  static List<ColorPair> _colors = <ColorPair> [
    ColorPair(
      backgroundColor: Colors.amber,
    ),
    ColorPair(
      backgroundColor: Colors.blue
    ),
    ColorPair(
      backgroundColor: Colors.blueGrey
    ),
    ColorPair(
      backgroundColor: Colors.brown
    ),
    ColorPair(
      backgroundColor: Colors.cyan
    ),
    ColorPair(
      backgroundColor: Colors.deepOrange
    ),
    ColorPair(
      backgroundColor: Colors.deepPurple
    ),
    ColorPair(
      backgroundColor: Colors.green
    ),
    ColorPair(
      backgroundColor: Colors.indigo
    ),
    ColorPair(
      backgroundColor: Colors.lightBlue
    ),
    ColorPair(
      backgroundColor: Colors.lightGreen
    ),
    ColorPair(
      backgroundColor: Colors.lime
    ),
    ColorPair(
      backgroundColor: Colors.orange
    ),
    ColorPair(
      backgroundColor: Colors.pink
    ),
    ColorPair(
      backgroundColor: Colors.red
    ),
    ColorPair(
      backgroundColor: Colors.teal
    ),
  ];

  static ColorPair getColorPair(String id) {
    if (id == null || id == '') {
      return _colors.first;
    }

    return _colors[id.hashCode % _colors.length];
  }
}

class ColorPair {
  final Color backgroundColor;

  ColorPair({
    this.backgroundColor,
  });

  Color get textColor {
    if (backgroundColor.computeLuminance() > 0.5) {
      return Colors.black;
    }

    else {
      return Colors.white;
    }
  }
}