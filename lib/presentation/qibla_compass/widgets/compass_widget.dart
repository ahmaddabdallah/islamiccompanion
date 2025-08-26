import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class CompassWidget extends StatefulWidget {
  final double qiblaAngle;
  final double currentDirection;
  final bool isAligned;
  final double accuracy;

  const CompassWidget({
    super.key,
    required this.qiblaAngle,
    required this.currentDirection,
    required this.isAligned,
    required this.accuracy,
  });

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isAligned) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CompassWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAligned && !oldWidget.isAligned) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isAligned && oldWidget.isAligned) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final compassSize = size.width * 0.8;

    return Center(
      child: SizedBox(
        width: compassSize,
        height: compassSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer compass ring
            _buildCompassRing(theme, compassSize),

            // Compass face
            _buildCompassFace(theme, compassSize * 0.85),

            // Qibla indicator
            _buildQiblaIndicator(theme, compassSize * 0.7),

            // Center dot
            _buildCenterDot(theme),

            // Direction labels
            _buildDirectionLabels(theme, compassSize * 0.9),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassRing(ThemeData theme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildCompassFace(ThemeData theme, double size) {
    return Transform.rotate(
      angle: -widget.currentDirection * pi / 180,
      child: CustomPaint(
        size: Size(size, size),
        painter: CompassPainter(
          primaryColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          onSurfaceColor: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildQiblaIndicator(ThemeData theme, double size) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.qiblaAngle * pi / 180,
          child: Transform.scale(
            scale: widget.isAligned ? _pulseAnimation.value : 1.0,
            child: Container(
              width: size,
              height: size,
              child: CustomPaint(
                painter: QiblaIndicatorPainter(
                  color: widget.isAligned
                      ? Colors.green
                      : theme.colorScheme.tertiary,
                  isAligned: widget.isAligned,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterDot(ThemeData theme) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildDirectionLabels(ThemeData theme, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // North
          _buildDirectionLabel(theme, 'ش', 0, size / 2 - 20),
          // East
          _buildDirectionLabel(theme, 'ق', size / 2 - 20, 0),
          // South
          _buildDirectionLabel(theme, 'ج', 0, -size / 2 + 20),
          // West
          _buildDirectionLabel(theme, 'غ', -size / 2 + 20, 0),
        ],
      ),
    );
  }

  Widget _buildDirectionLabel(
      ThemeData theme, String label, double dx, double dy) {
    return Positioned(
      left: dx,
      top: dy,
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final Color primaryColor;
  final Color backgroundColor;
  final Color onSurfaceColor;

  CompassPainter({
    required this.primaryColor,
    required this.backgroundColor,
    required this.onSurfaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Paint compass background
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Paint degree markings
    final markPaint = Paint()
      ..color = onSurfaceColor.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    final thickMarkPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2;

    for (int i = 0; i < 360; i += 5) {
      final angle = i * pi / 180;
      final isMainDirection = i % 90 == 0;
      final isMajorMark = i % 30 == 0;

      final paint = isMainDirection
          ? thickMarkPaint
          : isMajorMark
              ? markPaint
              : markPaint;

      final startRadius = isMainDirection
          ? radius - 25
          : isMajorMark
              ? radius - 15
              : radius - 8;

      final start = Offset(
        center.dx + cos(angle - pi / 2) * startRadius,
        center.dy + sin(angle - pi / 2) * startRadius,
      );

      final end = Offset(
        center.dx + cos(angle - pi / 2) * radius,
        center.dy + sin(angle - pi / 2) * radius,
      );

      canvas.drawLine(start, end, paint);
    }

    // Paint Islamic geometric pattern
    final patternPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * 0.3 * i, patternPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class QiblaIndicatorPainter extends CustomPainter {
  final Color color;
  final bool isAligned;

  QiblaIndicatorPainter({
    required this.color,
    required this.isAligned,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw Qibla arrow
    final arrowPath = Path();
    final arrowLength = radius * 0.8;
    final arrowWidth = 12.0;

    // Arrow tip
    arrowPath.moveTo(center.dx, center.dy - arrowLength);
    // Arrow sides
    arrowPath.lineTo(center.dx - arrowWidth, center.dy - arrowLength + 20);
    arrowPath.lineTo(center.dx - arrowWidth / 2, center.dy - arrowLength + 15);
    arrowPath.lineTo(center.dx - arrowWidth / 2, center.dy + arrowLength * 0.3);
    arrowPath.lineTo(center.dx + arrowWidth / 2, center.dy + arrowLength * 0.3);
    arrowPath.lineTo(center.dx + arrowWidth / 2, center.dy - arrowLength + 15);
    arrowPath.lineTo(center.dx + arrowWidth, center.dy - arrowLength + 20);
    arrowPath.close();

    canvas.drawPath(arrowPath, paint);

    // Draw Kaaba symbol at the tip
    if (isAligned) {
      final kaabaPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      final kaabaRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - arrowLength + 5),
          width: 8,
          height: 8,
        ),
        const Radius.circular(2),
      );

      canvas.drawRRect(kaabaRect, kaabaPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
