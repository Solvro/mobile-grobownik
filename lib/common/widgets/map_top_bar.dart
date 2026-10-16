import "package:flutter/material.dart";

import "../../app/theme/app_theme.dart";
import "../../features/settings/presentation/widgets/settings_icon_button.dart";
import "../../features/user_stats/presentation/widgets/profile_icon_button.dart";
import "grave_search_bar.dart";

const mapTopBarHeight = 56.0;

class MapTopBar extends StatelessWidget {
  const MapTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(child: GraveSearchBar()),
          SizedBox(width: 8),
          _RoundBarButton(child: ProfileIconButton()),
          SizedBox(width: 8),
          _RoundBarButton(child: SettingsIconButton()),
        ],
      ),
    );
  }
}

class _RoundBarButton extends StatelessWidget {
  const _RoundBarButton({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: mapTopBarHeight,
      child: Material(
        elevation: 4,
        shape: const CircleBorder(),
        color: context.colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        child: Center(child: child),
      ),
    );
  }
}
