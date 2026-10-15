import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Фон: мягкий градиент и тонкая сетка, без плоского одноцветного экрана.
class StudioBackdrop extends StatelessWidget {
  const StudioBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      AppColors.night,
                      AppColors.nightMist,
                      Color(0xFF102420),
                    ]
                  : const [AppColors.mist, AppColors.paper, Color(0xFFD9EFE9)],
            ),
          ),
        ),
        CustomPaint(
          painter: _GridPainter(
            color: (isDark ? AppColors.nightLine : AppColors.line).withValues(
              alpha: isDark ? 0.35 : 0.55,
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: _Orb(
            size: 220,
            color: (isDark ? AppColors.tealSoft : AppColors.teal).withValues(
              alpha: isDark ? 0.12 : 0.10,
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -30,
          child: _Orb(
            size: 180,
            color: (isDark ? AppColors.copperSoft : AppColors.copper)
                .withValues(alpha: isDark ? 0.10 : 0.08),
          ),
        ),
        child,
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 28.0;
    for (var x = 0.0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Лёгкий диагональный штрих, чтобы сетка не выглядела «табличной».
    final diagonal = Paint()
      ..color = color.withValues(alpha: color.a * 0.35)
      ..strokeWidth = 1;
    final length = math.sqrt(
      size.width * size.width + size.height * size.height,
    );
    canvas.drawLine(
      Offset(size.width * 0.55, -20),
      Offset(size.width * 0.55 + length * 0.15, length * 0.15),
      diagonal,
    );
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.color != color;
}
