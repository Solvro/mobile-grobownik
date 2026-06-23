import "package:flutter/material.dart";

import "hex_color.dart";

abstract class ColorsConsts {
  // Background #001626
  static const midnightNavy = HexColor.consts(0xFF001626);

  // Bottom Sheet #001F33
  static const darkNavyBlue = HexColor.consts(0xFF001F33);

  // Cards #002E4D
  static const deepOceanBlue = HexColor.consts(0xFF002E4D);

  // Border #083A5C
  static const steelBlue = HexColor.consts(0xFF083A5C);

  // Accent #FFD358
  static const goldenYellow = HexColor.consts(0xFFFFD358);

  // Primary Text #FFFFFF
  static const white = HexColor.consts(0xFFFFFFFF);

  // Secondary Text #A9C2D8
  static const lightSteelBlue = HexColor.consts(0xFFA9C2D8);

  // Success
  static const emeraldGreen = HexColor.consts(0xFF28A745);

  // Error
  static const crimsonRed = HexColor.consts(0xFFDC3545);

  // Offline
  static const slateGray = HexColor.consts(0xFF5F6673);

  // Main App Gradient
  static const appGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [HexColor.consts(0xFF002E4D), HexColor.consts(0xFF001F33), HexColor.consts(0xFF001626)],
    stops: [0.0, 0.5, 1.0],
  );

  // Card Gradient
  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [HexColor.consts(0xFF083A5C), HexColor.consts(0xFF002E4D)],
  );
}
