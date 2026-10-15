import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const _display = 'BricolageGrotesque';
  static const _body = 'Figtree';

  static ThemeData light() {
    final scheme = ColorScheme.light(
      primary: AppColors.teal,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFCDEAE5),
      onPrimaryContainer: AppColors.tealDeep,
      secondary: AppColors.copper,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFF6DFCB),
      onSecondaryContainer: const Color(0xFF5C2E0C),
      surface: AppColors.paper,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkMuted,
      outline: AppColors.line,
      error: AppColors.error,
      onError: Colors.white,
    );
    return _build(scheme, Brightness.light);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.dark(
      primary: AppColors.tealSoft,
      onPrimary: AppColors.night,
      primaryContainer: AppColors.tealDeep,
      onPrimaryContainer: AppColors.nightInk,
      secondary: AppColors.copperSoft,
      onSecondary: AppColors.night,
      secondaryContainer: const Color(0xFF5A3215),
      onSecondaryContainer: const Color(0xFFF6DFCB),
      surface: AppColors.night,
      onSurface: AppColors.nightInk,
      onSurfaceVariant: AppColors.nightMuted,
      outline: AppColors.nightLine,
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
    );
    return _build(scheme, Brightness.dark);
  }

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = Typography.material2021(platform: TargetPlatform.windows)
        .black
        .apply(fontFamily: _body);

    TextStyle display(
      double size, {
      FontWeight weight = FontWeight.w700,
      double letterSpacing = -0.5,
      double height = 1.15,
      Color? color,
    }) {
      return TextStyle(
        fontFamily: _display,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        height: height,
        color: color ?? scheme.onSurface,
      );
    }

    TextStyle body(
      double size, {
      FontWeight weight = FontWeight.w400,
      Color? color,
      double height = 1.45,
    }) {
      return TextStyle(
        fontFamily: _body,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color ?? scheme.onSurface,
      );
    }

    final textTheme = base.copyWith(
      displayLarge: display(48, letterSpacing: -1.2),
      displayMedium: display(40, letterSpacing: -1),
      displaySmall: display(34, letterSpacing: -0.6),
      headlineLarge: display(30, letterSpacing: -0.8),
      headlineMedium: display(26, letterSpacing: -0.5),
      headlineSmall: display(22, weight: FontWeight.w600, letterSpacing: -0.3),
      titleLarge: display(20, weight: FontWeight.w600, letterSpacing: -0.2),
      titleMedium: body(16, weight: FontWeight.w600),
      titleSmall: body(14, weight: FontWeight.w600),
      bodyLarge: body(16, color: scheme.onSurface),
      bodyMedium: body(14, color: scheme.onSurfaceVariant),
      bodySmall: body(12, color: scheme.onSurfaceVariant, height: 1.4),
      labelLarge: body(15, weight: FontWeight.w600),
      labelMedium: body(12, weight: FontWeight.w600),
      labelSmall: body(11, weight: FontWeight.w600),
    );

    final fill = isDark ? AppColors.nightPanel : Colors.white;
    final radius = BorderRadius.circular(16);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: _body,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.error, width: 1.6),
        ),
        labelStyle: TextStyle(
          fontFamily: _body,
          color: scheme.onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(borderRadius: radius),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 16),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: scheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
    );
  }
}
