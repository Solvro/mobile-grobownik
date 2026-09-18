import "package:riverpod_annotation/riverpod_annotation.dart";

part "bottom_sheet_extent_provider.g.dart";

@Riverpod(keepAlive: true)
class BottomSheetExtent extends _$BottomSheetExtent {
  @override
  double build() => 0;

  void update(double pixels) => state = pixels;
}
