import 'dart:ui';

import 'package:ak_azm_flutter/models/case/case.dart';
import 'package:flutter/cupertino.dart';

class ChartPainter {
  static paintGrid(
    Canvas canvas,
    Paint paint,
    int rows,
    int cols,
    double gridSize, {
    int leftTickInterval = 0,
    int rightTickInterval = 0,
    int topTickInterval = 0,
    int bottomTickInterval = 0,
    double tickSize = 10,
  }) {
    // Draw vertical line
    for (var i = 0; i < cols + 1; i++) {
      final topTick = topTickInterval != 0 && i % topTickInterval == 0;
      final bottomTick = bottomTickInterval != 0 && i % bottomTickInterval == 0;
      canvas.drawLine(
        Offset(i.toDouble() * gridSize, topTick ? -tickSize : 0),
        Offset(i.toDouble() * gridSize,
            rows * gridSize + (bottomTick ? tickSize : 0)),
        paint,
      );
    }
    // Draw horizontal line
    for (var i = 0; i < rows + 1; i++) {
      final leftTick = leftTickInterval != 0 && i % leftTickInterval == 0;
      final rightTick = rightTickInterval != 0 && i % rightTickInterval == 0;

      canvas.drawLine(
        Offset(leftTick ? -tickSize : 0, i.toDouble() * gridSize),
        Offset(cols * gridSize + (rightTick ? tickSize : 0),
            i.toDouble() * gridSize),
        paint,
      );
    }
  }

  static paintXAxis(
    Canvas canvas,
    Paint paint,
    int length,
    double size, {
    int bottomTickInterval = 0,
    int topTickInterval = 0,
    double tickSize = 10,
  }) {
    canvas.drawLine(const Offset(0, 0), Offset(length * size, 0), paint);
    for (var i = 0; i < length + 1; i++) {
      final topTick = topTickInterval != 0 && i % topTickInterval == 0;
      final bottomTick = bottomTickInterval != 0 && i % bottomTickInterval == 0;
      if (topTick) {
        canvas.drawLine(
            Offset(i * size, -tickSize), Offset(i * size, 0), paint);
      }
      if (bottomTick) {
        canvas.drawLine(Offset(i * size, tickSize), Offset(i * size, 0), paint);
      }
    }
  }

  static paintYAxis(
    Canvas canvas,
    Paint paint,
    int length,
    double size, {
    int leftTickOffset = 0,
    int leftTickInterval = 0,
    int rightTickInterval = 0,
    double tickSize = 10,
  }) {
    canvas.drawLine(const Offset(0, 0), Offset(0, length * size), paint);
    for (var i = 0; i < length + 1; i++) {
      final leftTick =
          leftTickInterval != 0 && (i - leftTickOffset) % leftTickInterval == 0;
      final rightTick = rightTickInterval != 0 && i % rightTickInterval == 0;
      if (leftTick) {
        canvas.drawLine(
            Offset(-tickSize, i * size), Offset(0, i * size), paint);
      }
      if (rightTick) {
        canvas.drawLine(Offset(tickSize, i * size), Offset(0, i * size), paint);
      }
    }
  }

  static drawText(Canvas canvas, String text, Color color, double fontSize,
      {TextAlign textAlign = TextAlign.center,
      FontWeight fontWeight = FontWeight.normal}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style:
            TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    if (textAlign == TextAlign.center) {
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    } else if (textAlign == TextAlign.left) {
      textPainter.paint(canvas, Offset(0, -textPainter.height / 2));
    }
  }

  static drawGraph(
      Canvas canvas, Paint paint, List<Sample> samples, double sx, double sy) {
    final path = Path();
    final firstSecond = samples.first.inSeconds;
    for (var e in samples) {
      path.lineTo((e.inSeconds - firstSecond) * sx, e.value * sy * -1);
    }
    canvas.drawPath(path, paint);
  }
}
