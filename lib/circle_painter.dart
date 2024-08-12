import 'dart:math';

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.innerColor,
    required this.animation,
    this.initialSweepAngle = 0,
  }) : super(repaint: animation);

  final Animation<Offset> animation;
  final double initialSweepAngle;

  final Color innerColor;
  final outer = Paint()
    ..color = Colors.white.withOpacity(0.3)
    ..style = PaintingStyle.fill;

  final paintShadow = Paint()
    ..color = Colors.grey.withOpacity(1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(
      size.width / 2.0 + animation.value.dx,
      size.height / 2.0 + animation.value.dy,
    );
    final radius = size.width / 2;

    canvas.drawCircle(c, radius + 2, paintShadow);
    canvas.drawCircle(c, radius, outer);
    canvas.drawCircle(
      c,
      radius - 4,
      Paint()
        ..color = innerColor.withOpacity(0.4)
        ..style = PaintingStyle.fill,
    );

    drawSmallCircle(radius, canvas, c, 0 + initialSweepAngle);
  }

  void drawSmallCircle(
    double radius,
    Canvas canvas,
    Offset center,
    double addSweepAngle,
  ) {
    const startAngle = 2.9;
    final dx = radius * cos(startAngle + (animation.value.dx * 5 + addSweepAngle) / 180 * pi);
    final dy = radius * sin(startAngle + (animation.value.dx * 5 + addSweepAngle) / 180 * pi);
    final position = center + Offset(dx, dy);

    canvas.drawCircle(position, 10, paintShadow);
    canvas.drawCircle(position, 10, outer);
    canvas.drawCircle(
      position,
      7,
      Paint()
        ..color = innerColor.withOpacity(0.9)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
