import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(brightness: Brightness.light);
  static ThemeData get dark => _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: AppColors.primary,
      secondary: AppColors.secondary,
    );

    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700),
      headlineLarge: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
      labelSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
    );

    return base.copyWith(
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: brightness == Brightness.light
          ? const Color(0xFFF3F8FF)
          : const Color(0xFF0F172A),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface.withOpacity(0.75),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        labelTextStyle: MaterialStatePropertyAll<TextStyle?>(textTheme.labelSmall),
      ),
      navigationRailTheme: NavigationRailThemeData(
        indicatorColor: colorScheme.primary.withOpacity(0.12),
        selectedLabelTextStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
        unselectedLabelTextStyle: textTheme.bodyMedium,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface.withOpacity(0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface.withOpacity(0.85),
        modalBackgroundColor: colorScheme.surface.withOpacity(0.85),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.labelSmall,
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: colorScheme.primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  static const glassDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(28)),
    gradient: LinearGradient(
      colors: [Color(0xCCFFFFFF), Color(0xA0FFFFFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 24,
        offset: Offset(0, 8),
      ),
    ],
    backgroundBlendMode: BlendMode.srcOver,
  );

  static BoxDecoration heroBackground() => const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.heroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
}
