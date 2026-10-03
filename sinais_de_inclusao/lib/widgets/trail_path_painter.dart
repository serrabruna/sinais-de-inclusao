import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class TrailPathPainter extends CustomPainter {
  final int count;
  final double itemHeight;
  final double circleOffset;
 
  TrailPathPainter({
    required this.count,
    this.itemHeight = 175.0,
    this.circleOffset = 47.5,
  });
 
  @override
  void paint(Canvas canvas, Size size) {
    if (count <= 1) return;
 
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0 
      ..strokeCap = StrokeCap.round 
      ..isAntiAlias = true;
 
    final fullPath = Path();
    final centerX = size.width / 2;
 
    double getX(int index) {
      double bias = index % 3 == 0 ? 0.0 : (index % 3 == 1 ? -0.6 : 0.6);
      return centerX + (bias * (size.width - 140) / 2);
    }
 
    double getY(int index) => (index * itemHeight) + circleOffset;
 
    fullPath.moveTo(getX(0), getY(0));
 
    for (int i = 0; i < count - 1; i++) {
      final p1X = getX(i);
      final p1Y = getY(i);
      final p2X = getX(i + 1);
      final p2Y = getY(i + 1);
 
      final controlY = (p1Y + p2Y) / 2;
      fullPath.cubicTo(p1X, controlY, p2X, controlY, p2X, p2Y);
    }
 
    const double dashLength = 9.0; 
    const double dashGap = 10.0; 
    const double padding = 55.0; 
 
    for (final metric in fullPath.computeMetrics()) {
      double distance = padding;
      final double maxDistance = metric.length - padding;
 
      while (distance < maxDistance) {
        final double end = math.min(distance + dashLength, maxDistance);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + dashGap;
      }
    }
  }
 
  @override
  bool shouldRepaint(covariant TrailPathPainter oldDelegate) {
    return oldDelegate.count != count ||
        oldDelegate.itemHeight != itemHeight ||
        oldDelegate.circleOffset != circleOffset;
  }
}