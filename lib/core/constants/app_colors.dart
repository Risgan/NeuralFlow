import 'package:flutter/material.dart';

/// Base color tokens for light and dark themes.
class AppColors {
  AppColors._();

  // ════════════════════════════════════════════════════════════════════════
  // LIGHT MODE
  // ════════════════════════════════════════════════════════════════════════

  // Background & Surfaces
  static const Color lightBackground = Color(0xFFF0F9FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPopover = Color(0xFFFFFFFF);

  // Text & Foreground
  static const Color lightForeground = Color(0xFF0F172A);
  static const Color lightCardForeground = Color(0xFF0F172A);
  static const Color lightOnSurface = Color(0xFF0F172A);

  // Primary
  static const Color lightPrimary = Color(0xFF0EA5E9);
  static const Color lightPrimaryForeground = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFE0F2FE);
  static const Color lightOnPrimaryContainer = Color(0xFF0369A1);

  // Secondary
  static const Color lightSecondary = Color(0xFFE0F2FE);
  static const Color lightSecondaryForeground = Color(0xFF0369A1);

  // Muted
  static const Color lightMuted = Color(0xFFE2E8F0);
  static const Color lightMutedForeground = Color(0xFF64748B);

  // Accent
  static const Color lightAccent = Color(0xFFE0F2FE);
  static const Color lightAccentForeground = Color(0xFF0369A1);

  // Typography & UI
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightInput = Color(0xFFFFFFFF);
  static const Color lightRing = Color(0xFF0EA5E9);

  // Semantic
  static const Color lightDestructive = Color(0xFFDC2626);
  static const Color lightDestructiveForeground = Color(0xFFFFFFFF);
  static const Color lightSuccess = Color(0xFF10B981);

  // ════════════════════════════════════════════════════════════════════════
  // DARK MODE
  // ════════════════════════════════════════════════════════════════════════

  // Background & Surfaces
  static const Color darkBackground = Color(0xFF020617);
  static const Color darkSurface = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF0F172A);
  static const Color darkPopover = Color(0xFF0F172A);

  // Text & Foreground
  static const Color darkForeground = Color(0xFFF8FAFC);
  static const Color darkCardForeground = Color(0xFFF8FAFC);
  static const Color darkOnSurface = Color(0xFFF8FAFC);

  // Primary
  static const Color darkPrimary = Color(0xFF38BDF8);
  static const Color darkPrimaryForeground = Color(0xFF020617);
  static const Color darkPrimaryContainer = Color(0xFF0C4A6E);
  static const Color darkOnPrimaryContainer = Color(0xFFBAE6FD);

  // Secondary
  static const Color darkSecondary = Color(0xFF0C4A6E);
  static const Color darkSecondaryForeground = Color(0xFFBAE6FD);

  // Muted
  static const Color darkMuted = Color(0xFF1E293B);
  static const Color darkMutedForeground = Color(0xFF94A3B8);

  // Accent
  static const Color darkAccent = Color(0xFF0C4A6E);
  static const Color darkAccentForeground = Color(0xFFBAE6FD);

  // Typography & UI
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkInput = Color(0xFF0F172A);
  static const Color darkRing = Color(0xFF38BDF8);

  // Semantic
  static const Color darkDestructive = Color(0xFFEF4444);
  static const Color darkDestructiveForeground = Color(0xFF020617);
  static const Color darkSuccess = Color(0xFF34D399);

  // ════════════════════════════════════════════════════════════════════════
  // TASK SPECIFIC (both modes)
  // ════════════════════════════════════════════════════════════════════════
  
  static const Color taskPendingBgLight = Color(0xFFFFFFFF); // oklch(1 0 0)
  static const Color taskDoneBgLight = Color(0xFFF5F5F9); // oklch(0.97 0.005 264)
  static const Color taskDoneTextLight = lightSuccess;
  static const Color counterTextLight = lightPrimary;

  static const Color taskPendingBgDark = darkSurface;
  static const Color taskDoneBgDark = Color(0xFF0B1220);
  static const Color taskDoneTextDark = darkSuccess;
  static const Color counterTextDark = darkPrimary;

  // ════════════════════════════════════════════════════════════════════════
  // LEGACY / UTILITIES (keep for backward compatibility)
  // ════════════════════════════════════════════════════════════════════════

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color success = Color(0xFF10B981);
}
