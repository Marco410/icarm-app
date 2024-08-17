import 'package:flutter/material.dart';

class OpenPainter extends CustomPainter {
  final Color color;
  final bool isSender;

  OpenPainter({
    required this.color,
    required this.isSender,
  });
  @override
  void paint(Canvas canvas, Size size) {
    if (isSender) {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - 8,
            size.height,
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      path.moveTo(size.width - 10, 0);
      path.lineTo(size.width - 10, 10);
      path.lineTo(size.width, 0);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            size.width - 10,
            0.0,
            size.width,
            size.height,
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
    } else {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            10,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      path.moveTo(10, 0);
      path.lineTo(10, 10);
      path.lineTo(0, 0);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0.0,
            10,
            size.height,
            topLeft: Radius.circular(3),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
