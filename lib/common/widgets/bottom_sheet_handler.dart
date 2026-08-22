import "package:flutter/material.dart";

import "../../app/theme/app_theme.dart";

class BottomSheetHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: 29,
          color: context.colorScheme.surface,
          child: Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: context.colorScheme.primary, borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ),
    );
  }
}
