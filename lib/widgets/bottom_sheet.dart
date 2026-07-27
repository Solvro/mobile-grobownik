import "dart:async";

import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../features/grave/presentation/providers/grave_details_provider.dart";
import "../l10n/app_localizations.dart";
import "../models/grave.dart";
import "../theme/app_theme.dart";
import "detail_views/bottom_sheet_handler.dart";
import "detail_views/feedback_section.dart";
import "detail_views/profile_icon_widget.dart";
import "details_section.dart";
import "grave_action_buttons.dart";
import "image_carousel.dart";

class MyDraggableSheet extends ConsumerStatefulWidget {
  const MyDraggableSheet({required this.graveId, super.key});

  final String graveId;

  @override
  ConsumerState<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends ConsumerState<MyDraggableSheet> {
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

  void _collapse() {
    final snapSizes = (_sheet.currentWidget as DraggableScrollableSheet?)?.snapSizes;
    if (snapSizes != null && snapSizes.isNotEmpty) unawaited(_animateSheet(snapSizes.first));
  }

  Future<void> _animateSheet(double size) async {
    await _controller.animateTo(size, duration: const Duration(milliseconds: 50), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final graveState = ref.watch(graveDetailsProvider(widget.graveId));

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
                          SliverPadding(
                            padding: const EdgeInsets.only(top: 29, left: 16, right: 16, bottom: 16),
                            sliver: SliverToBoxAdapter(
                              child: graveState.when(
                                loading: () => const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                                error: (error, stackTrace) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  child: Center(child: Text(AppLocalizations.of(context)!.loading_error)),
                                ),
                                data: (grave) => _GraveDetails(grave: grave),
                              ),
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

class _GraveDetails extends StatelessWidget {
  const _GraveDetails({required this.grave});

  final Grave grave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${grave.firstName} ${grave.lastName}", style: context.textTheme.headlineMedium),
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

        DetailsSection(biography: grave.biography ?? ""),

        const SizedBox(height: 8),

        FeedbackSection(),

        const SizedBox(height: 32),
      ],
    );
  }
}
