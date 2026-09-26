import 'package:flutter/material.dart';

class TrailPathPainter extends CustomPainter {
  final int count;
  final double itemHeight;
  final double circleOffset;

  TrailPathPainter({
    required this.count,
    this.itemHeight = 175.0,
    this.circleOffset = 57.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (count <= 1) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

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

    final dashedPath = _createDashedPath(
      source: fullPath,
      dashLength: 10.0, 
      dashGap: 8.0,   
    );

    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath({
    required Path source,
    required double dashLength,
    required double dashGap,
  }) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;

      while (distance < metric.length) {
        final length = draw ? dashLength : dashGap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant TrailPathPainter oldDelegate) {
    return oldDelegate.count != count;
  }
}