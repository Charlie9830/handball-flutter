import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

Position getPositionFromGlobalKey(GlobalKey globalKey) {
  var renderBox = globalKey.currentContext.findRenderObject() as RenderBox;
  var offset = renderBox.localToGlobal(Offset.zero);

  return Position(
    right: offset.dx,
    top: offset.dy - renderBox.size.height - 8,
  );
}

class Position {
  final double top;
  final double right;

  Position({
    @required this.top,
    @required this.right,
  });
}
