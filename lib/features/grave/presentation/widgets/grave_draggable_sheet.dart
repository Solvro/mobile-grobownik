import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../common/providers/bottom_sheet_extent_provider.dart";
import "../../../../common/widgets/bottom_sheet_handler.dart";
import "../../../../common/widgets/image_carousel.dart";
import "../../../user_stats/presentation/widgets/profile_icon_button.dart";
import "../../data/models/grave.dart";
import "../providers/grave_details_provider.dart";
import "details_section.dart";
import "feedback_section.dart";
import "grave_action_buttons.dart";

class MyDraggableSheet extends ConsumerStatefulWidget {
  const MyDraggableSheet({required this.graveId, super.key});

  final String graveId;

  @override
  ConsumerState<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends ConsumerState<MyDraggableSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  late final BottomSheetExtent _extent = ref.read(bottomSheetExtentProvider.notifier);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _publishExtent());
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
    _publishExtent();
  }

  void _publishExtent() {
    if (!mounted || !_controller.isAttached) return;

    final pixels = _controller.pixels;

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _publishExtent());

      return;
    }

    _extent.update(pixels);
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
    _controller.removeListener(_onChanged);
    _controller.dispose();
    final extent = _extent;
    WidgetsBinding.instance.addPostFrameCallback((_) => extent.update(0));
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
