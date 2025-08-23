import 'dart:math' as math;
import 'package:fava/core/utils/screen_util.dart';
import 'package:flutter/material.dart';

class CircularButtonWithArc extends StatelessWidget {
  final Color buttonclr;
  final Function onPressed;
  final double? size; // Optional size parameter

  const CircularButtonWithArc({
    super.key, 
    required this.buttonclr, 
    required this.onPressed,
    this.size, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    // Calculate responsive button size
    final double buttonSize = size != null 
        ? context.width(size!) // Convert int to percentage (e.g., 25 = 25% of screen width)
        : context.width(0.2); // Default 20% of screen width
    
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Stack(
          children: [
            // Arc positioned relative to button
            Positioned.fill(
              child: CustomPaint(
                painter: ArcPainter(
                  color: buttonclr,
                  screenWidth: context.screenWidth,
                ),
              ),
            ),
            // Main circular button centered
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.all(buttonSize * 0.125), // Responsive margin (12.5% of button size)
                decoration: BoxDecoration(
                  color: buttonclr,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: buttonSize * 0.3, // Icon size scales with button size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final Color color;
  final double screenWidth;

  ArcPainter({required this.color, required this.screenWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = screenWidth * 0.0025 // Responsive stroke width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final arcRadius = size.width / 2; // Arc radius based on container size

    // Start 15° clockwise from top, draw arc anticlockwise
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      -math.pi / 2 + (15 * math.pi / 180), // Start 15° clockwise from top
      -math.pi * 2 / 3.5, // Draw arc anticlockwise
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}