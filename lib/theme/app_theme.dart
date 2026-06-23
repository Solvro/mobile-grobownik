import "package:flutter/material.dart";
import "colors.dart";
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
  ThemeData get dark => ThemeData.dark();
}

class AppTheme implements AppThemeData {
  const AppTheme();

  @override
  ThemeData get dark => ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: ColorsConsts.goldenYellow,
      onPrimary: ColorsConsts.midnightNavy,
      surface: ColorsConsts.darkNavyBlue,
      onSurfaceVariant: ColorsConsts.lightSteelBlue,
      outline: ColorsConsts.steelBlue,
      error: ColorsConsts.crimsonRed,
      onError: ColorsConsts.white,
      secondary: ColorsConsts.deepOceanBlue,
      onSecondary: ColorsConsts.lightSteelBlue,
      onTertiary: ColorsConsts.white,
    ),
    textTheme: _AppTextTheme(),
  );
}

extension AppThemeX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
