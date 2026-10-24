import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Immersive Faded Pulse & Wave Background derived from the CareerPulse logo geometry.
/// Features subtle ECG/heartbeat pulse peaks, ascending trajectory waves, and soft radial glows.
/// Designed with calibrated low opacity (4%-8%) to maintain strict WCAG AA contrast standards.
class PulseBackground extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;

  const PulseBackground({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.zero;
    return ClipRRect(
      borderRadius: effectiveRadius,
      child: Stack(
        children: [
          // Underlying decorative pulse canvas
          Positioned.fill(
            child: CustomPaint(
              painter: PulseWavePainter(),
            ),
          ),
          // Content overlay
          child,
        ],
      ),
    );
  }
}

/// Elegant Section Divider displaying a subtle ECG heartbeat pulse motif derived from the logo.
class PulseDivider extends StatelessWidget {
  final double height;
  final double opacity;

  const PulseDivider({
    super.key,
    this.height = 32,
    this.opacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: CustomPaint(
          size: Size(double.infinity, height),
          painter: _PulseDividerPainter(opacity: opacity),
        ),
      ),
    );
  }
}

class _PulseDividerPainter extends CustomPainter {
  final double opacity;

  _PulseDividerPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cy = h / 2;

    // 1. Tapered horizontal rule fading into transparency on edges
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.primaryBlue.withAlpha((120 * opacity).toInt()),
          AppColors.teal.withAlpha((140 * opacity).toInt()),
          Colors.transparent,
        ],
        stops: const [0.0, 0.25, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // 2. ECG pulse wave centered in the divider
    final pulsePath = Path();
    final midX = w * 0.5;
    final pulseWidth = (w > 400) ? 120.0 : 80.0;
    final startX = midX - pulseWidth / 2;

    // Left line to pulse start
    pulsePath.moveTo(0, cy);
    pulsePath.lineTo(startX, cy);

    // Minor tremor
    pulsePath.lineTo(startX + pulseWidth * 0.15, cy - 3);
    pulsePath.lineTo(startX + pulseWidth * 0.25, cy + 2);
    pulsePath.lineTo(startX + pulseWidth * 0.35, cy);

    // Characteristic Heartbeat Peak & Valley (logo rhythm)
    pulsePath.lineTo(startX + pulseWidth * 0.45, cy + 6);   // slight dip
    pulsePath.lineTo(startX + pulseWidth * 0.55, cy - 12);  // sharp peak
    pulsePath.lineTo(startX + pulseWidth * 0.65, cy + 10);  // plunge
    pulsePath.lineTo(startX + pulseWidth * 0.75, cy - 14);  // ascending surge
    pulsePath.lineTo(startX + pulseWidth * 0.85, cy);       // return to baseline

    // Right line to end
    pulsePath.lineTo(w, cy);

    canvas.drawPath(pulsePath, linePaint);

    // Glowing node dot at the highest surge crest
    final dotPaint = Paint()
      ..color = AppColors.teal.withAlpha((200 * opacity).toInt())
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(startX + pulseWidth * 0.75, cy - 14), 2.2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _PulseDividerPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class PulseWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // 1. Soft atmospheric radial glows inspired by the logo's blue and teal gradient
    final radialPaintTeal = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.7, -0.4),
        radius: 0.9,
        colors: [
          AppColors.teal.withAlpha(22), // ~8% opacity
          AppColors.teal.withAlpha(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), radialPaintTeal);

    final radialPaintBlue = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.8, 0.6),
        radius: 0.8,
        colors: [
          AppColors.primaryBlue.withAlpha(18), // ~7% opacity
          AppColors.primaryBlue.withAlpha(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), radialPaintBlue);

    // 2. Primary Pulse Motif Wave (matching the CareerPulse 'a' pulse arrow rhythm)
    final primaryPulsePaint = Paint()
      ..color = AppColors.primaryBlue.withAlpha(25) // ~10% opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final primaryPulsePath = Path();
    final yBase1 = height * 0.68;

    primaryPulsePath.moveTo(0, yBase1);
    primaryPulsePath.lineTo(width * 0.20, yBase1);
    
    // Minor initial tremor
    primaryPulsePath.lineTo(width * 0.24, yBase1 - 8);
    primaryPulsePath.lineTo(width * 0.28, yBase1 + 6);
    primaryPulsePath.lineTo(width * 0.32, yBase1);
    primaryPulsePath.lineTo(width * 0.45, yBase1);

    // Signature Heartbeat Pulse Peak & Valley (from logo)
    primaryPulsePath.lineTo(width * 0.52, yBase1 + 18); // Downward dip
    primaryPulsePath.lineTo(width * 0.58, yBase1 - 42); // Sharp upward peak
    primaryPulsePath.lineTo(width * 0.63, yBase1 + 32); // Deep plunge
    primaryPulsePath.lineTo(width * 0.70, yBase1 - 58); // Ascending surge
    primaryPulsePath.lineTo(width * 0.76, yBase1 - 24); // Recovery
    primaryPulsePath.lineTo(width * 0.82, yBase1);      // Return to baseline
    primaryPulsePath.lineTo(width, yBase1);

    canvas.drawPath(primaryPulsePath, primaryPulsePaint);

    // 3. Secondary Echo Pulse Wave (Teal tone, offset for visual depth)
    final secondaryPulsePaint = Paint()
      ..color = AppColors.teal.withAlpha(18) // ~7% opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final secondaryPulsePath = Path();
    final yBase2 = height * 0.36;

    secondaryPulsePath.moveTo(0, yBase2);
    secondaryPulsePath.lineTo(width * 0.12, yBase2);
    secondaryPulsePath.lineTo(width * 0.16, yBase2 + 10);
    secondaryPulsePath.lineTo(width * 0.20, yBase2 - 24);
    secondaryPulsePath.lineTo(width * 0.24, yBase2 + 16);
    secondaryPulsePath.lineTo(width * 0.29, yBase2 - 36);
    secondaryPulsePath.lineTo(width * 0.34, yBase2);
    secondaryPulsePath.lineTo(width * 0.65, yBase2);
    secondaryPulsePath.lineTo(width * 0.70, yBase2 - 12);
    secondaryPulsePath.lineTo(width * 0.75, yBase2 + 10);
    secondaryPulsePath.lineTo(width * 0.80, yBase2);
    secondaryPulsePath.lineTo(width, yBase2);

    canvas.drawPath(secondaryPulsePath, secondaryPulsePaint);

    // 4. Subtle trajectory growth arrow head at pulse crest
    final arrowPaint = Paint()
      ..color = AppColors.teal.withAlpha(30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final arrowPath = Path();
    final ax = width * 0.70;
    final ay = yBase1 - 58;
    arrowPath.moveTo(ax - 10, ay + 6);
    arrowPath.lineTo(ax, ay);
    arrowPath.lineTo(ax + 2, ay + 12);
    canvas.drawPath(arrowPath, arrowPaint);

    // 5. Subtle tech rhythm grid nodes
    final dotPaint = Paint()
      ..color = AppColors.deepBlue.withAlpha(12) // ~5% opacity
      ..style = PaintingStyle.fill;

    const spacing = 36.0;
    for (double x = 20; x < width; x += spacing) {
      for (double y = 20; y < height; y += spacing) {
        if ((x + y).toInt() % 72 == 0) {
          canvas.drawCircle(Offset(x, y), 1.2, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
