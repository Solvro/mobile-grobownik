import "package:flutter/material.dart";

import "colors.dart";
import "hex_color.dart";
import "typography.dart";

class _AppTextTheme extends TextTheme {
  _AppTextTheme()
    : super(
        headlineMedium: HeadlineMediumTextStyle(),
        headlineSmall: HeadlineSmallTextStyle(),
        bodyLarge: BodyLargeTextStyle(),
        bodyMedium: BodyMediumTextStyle(),
      );
}

abstract interface class AppThemeData {
  ThemeData get light;
  ThemeData get dark;
}

class AppTheme implements AppThemeData {
  const AppTheme();

  @override
  ThemeData get light => ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: ColorsConsts.deepOceanBlue,
      onPrimary: ColorsConsts.white,
      surface: ColorsConsts.white,
      onSurface: ColorsConsts.midnightNavy,
      onSurfaceVariant: ColorsConsts.steelBlue,
      outline: ColorsConsts.lightSteelBlue,
      error: ColorsConsts.crimsonRed,
      onError: ColorsConsts.white,
      secondary: ColorsConsts.goldenYellow,
      onSecondary: ColorsConsts.midnightNavy,
      onTertiary: ColorsConsts.midnightNavy,
      primaryContainer: ColorsConsts.lightSteelBlue,
      onPrimaryContainer: ColorsConsts.midnightNavy,
      secondaryContainer: HexColor.consts(0xFFFFF3D1),
      onSecondaryContainer: ColorsConsts.midnightNavy,
      surfaceContainerHighest: HexColor.consts(0xFFE8EEF3),
    ),
    textTheme: _AppTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsConsts.white,
      foregroundColor: ColorsConsts.midnightNavy,
      elevation: 0,
    ),
    listTileTheme: const ListTileThemeData(iconColor: ColorsConsts.deepOceanBlue),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ColorsConsts.deepOceanBlue;
        return ColorsConsts.lightSteelBlue;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorsConsts.deepOceanBlue.withValues(alpha: 0.4);
        }
        return ColorsConsts.lightSteelBlue.withValues(alpha: 0.4);
      }),
    ),
  );

  @override
  ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: ColorsConsts.goldenYellow,
      onPrimary: ColorsConsts.midnightNavy,
      surface: ColorsConsts.darkNavyBlue,
      onSurface: ColorsConsts.white,
      onSurfaceVariant: ColorsConsts.lightSteelBlue,
      outline: ColorsConsts.steelBlue,
      error: ColorsConsts.crimsonRed,
      onError: ColorsConsts.white,
      secondary: ColorsConsts.deepOceanBlue,
      onSecondary: ColorsConsts.lightSteelBlue,
      onTertiary: ColorsConsts.white,
      primaryContainer: ColorsConsts.deepOceanBlue,
      onPrimaryContainer: ColorsConsts.goldenYellow,
      secondaryContainer: ColorsConsts.steelBlue,
      onSecondaryContainer: ColorsConsts.lightSteelBlue,
      surfaceContainerHighest: ColorsConsts.deepOceanBlue,
    ),
    textTheme: _AppTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsConsts.darkNavyBlue,
      foregroundColor: ColorsConsts.white,
      elevation: 0,
    ),
    listTileTheme: const ListTileThemeData(iconColor: ColorsConsts.goldenYellow),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return ColorsConsts.goldenYellow;
        return ColorsConsts.lightSteelBlue;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorsConsts.goldenYellow.withValues(alpha: 0.4);
        }
        return ColorsConsts.steelBlue;
      }),
    ),
  );
}

extension AppThemeX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
