import 'package:flutter/material.dart';

class DecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var topRightYellowPath = Path();
    topRightYellowPath.moveTo(size.width / 4, 0);
    topRightYellowPath.quadraticBezierTo(size.width, 0, size.width, size.height / 2 );

    // Closing
    topRightYellowPath.lineTo(size.width, size.height / 4 );
    topRightYellowPath.lineTo(size.width, 0);
    topRightYellowPath.close();

    var topRightPinkPath = Path();
    topRightPinkPath.moveTo(size.width / 1.85, 0);
    topRightPinkPath.quadraticBezierTo(size.width, 0, size.width, size.height / 2);

    // Closing
    topRightPinkPath.lineTo(size.width, size.height / 4);
    topRightPinkPath.lineTo(size.width, 0);
    topRightPinkPath.close();

    var yellowPaint = Paint();
    yellowPaint.style = PaintingStyle.fill;
    yellowPaint.strokeWidth = 8;
    yellowPaint.color = Color.fromRGBO(255, 180, 16, 1);

    var pinkPaint = Paint();
    pinkPaint.style = PaintingStyle.fill;
    pinkPaint.strokeWidth = 8;
    pinkPaint.color = Color.fromRGBO(255, 10, 101, 1);

    canvas.drawPath(topRightYellowPath, yellowPaint);
    canvas.drawPath(topRightPinkPath, pinkPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}