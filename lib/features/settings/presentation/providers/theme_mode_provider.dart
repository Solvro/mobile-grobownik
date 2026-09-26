import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "theme_mode_provider.g.dart";

@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  static const _prefsKey = "theme_mode";

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _fromStorage(prefs.getString(_prefsKey));
  }

  Future<void> setDarkMode({required bool enabled}) async {
    final mode = enabled ? ThemeMode.dark : ThemeMode.light;
    state = AsyncData(mode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, enabled ? "dark" : "light");
  }

  static ThemeMode _fromStorage(String? value) => switch (value) {
    "light" => ThemeMode.light,
    "dark" => ThemeMode.dark,
    _ => ThemeMode.dark,
  };
}
