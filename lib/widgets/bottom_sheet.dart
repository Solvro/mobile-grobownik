import "package:flutter/material.dart";

import "../l10n/app_localizations.dart";
import "../theme/app_theme.dart";
import "detail_views/bottom_sheet_handler.dart";
import "detail_views/profile_icon_widget.dart";
import "details_section.dart";
import "feedback_section.dart";
import "grave_action_buttons.dart";
import "image_carousel.dart";

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({super.key});

  @override
  State<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  Future<void> _animateSheet(double size) async {
    await _controller.animateTo(size, duration: const Duration(milliseconds: 50), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet => _sheet.currentWidget! as DraggableScrollableSheet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minSize = 200 / constraints.maxHeight;

        return DraggableScrollableSheet(
          key: _sheet,
          minChildSize: minSize,
          snap: true,
          snapSizes: [minSize, 0.5],
          controller: _controller,
          builder: (BuildContext context, ScrollController scrollController) {
            return DefaultTabController(
              length: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: context.colorScheme.surface),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: Stack(
                    children: [
                      BottomSheetHandler(),
                      CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          const SliverToBoxAdapter(child: SizedBox(height: 29)),
                          SliverPadding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            sliver: SliverList.list(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(AppLocalizations.of(context)!.name_and_surname, style: context.textTheme.headlineMedium),
                                        const SizedBox(height: 8),

                                        Text(AppLocalizations.of(context)!.birth_death_dates, style: context.textTheme.bodyLarge),
                                      ],
                                    ),

                                    ProfileIconWidget(),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                GraveActionButtons(),

                                const SizedBox(height: 16),

                                ImageCarousel(),
                                const SizedBox(height: 16),

                                DetailsSection(),

                                const SizedBox(height: 8),

                                FeedbackSection(),

                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
