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
      ..style = PaintingStyle.fill;

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

    
    const double stepDistance = 34.0; 
    const double stepWidth = 10.0;    
    bool isLeftFoot = false;

    for (final metric in fullPath.computeMetrics()) {
      
      double distance = 55.0;

      while (distance < metric.length - 55.0) {
        final Tangent? tangent = metric.getTangentForOffset(distance);

        if (tangent != null) {
          final position = tangent.position;
          
          final angle = math.atan2(tangent.vector.dy, tangent.vector.dx);

          
          final perpX = -math.sin(angle) * (isLeftFoot ? -stepWidth : stepWidth);
          final perpY = math.cos(angle) * (isLeftFoot ? -stepWidth : stepWidth);

          canvas.save();
          
          canvas.translate(position.dx + perpX, position.dy + perpY);
          canvas.rotate(angle + math.pi / 2);

          _drawPaw(canvas, paint);

          canvas.restore();
          isLeftFoot = !isLeftFoot;
        }

        distance += stepDistance;
      }
    }
  }

  
  void _drawPaw(Canvas canvas, Paint paint) {
    
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 2), width: 11, height: 9),
      paint,
    );

    
    final toes = [
      [-4.5, -4.5, 3.2, 4.2], 
      [-1.6, -6.5, 3.4, 4.8], 
      [1.6, -6.5, 3.4, 4.8],  
      [4.5, -4.5, 3.2, 4.2],  
    ];

    for (final toe in toes) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(toe[0], toe[1]),
          width: toe[2],
          height: toe[3],
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TrailPathPainter oldDelegate) {
    return oldDelegate.count != count;
  }
}