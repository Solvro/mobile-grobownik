import "package:flutter/material.dart";

abstract class ColorsConsts {
  // Background #001626
  static const background = Color(0xFF001626);

  // Bottom Sheet #001F33
  static const surface = Color(0xFF001F33);

  // Cards #002E4D
  static const card = Color(0xFF002E4D);

  // Border #083A5C
  static const border = Color(0xFF083A5C);

  // Accent #FFD358 
  static const accent = Color(0xFFFFD358);

  // Primary Text #FFFFFF
  static const textPrimary = Color(0xFFFFFFFF);

  // Secondary Text #A9C2D8
  static const textSecondary = Color(0xFFA9C2D8);

  // Success
  static const success = Color(0xFF28A745);

  // Error
  static const error = Color(0xFFDC3545);

  // Offline
  static const offline = Color(0xFF5F6673);

  // Main App Gradient
  static const appGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF002E4D),
      Color(0xFF001F33),
      Color(0xFF001626),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Card Gradient
  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF083A5C),
      Color(0xFF002E4D),
    ],
  );
}
