import "dart:async";

import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:intl/intl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../common/providers/user_location_provider.dart";
import "../../../../common/utils/distance.dart";
import "../../../../common/widgets/bottom_sheet_handler.dart";
import "../../../../common/widgets/image_carousel.dart";
import "../../../user_stats/presentation/widgets/profile_icon_button.dart";
import "../../data/models/grave.dart";
import "../providers/grave_details_provider.dart";
import "../providers/selected_grave_provider.dart";
import "details_section.dart";
import "feedback_section.dart";
import "grave_action_buttons.dart";
import "grave_list_sheet.dart";

class MyDraggableSheet extends ConsumerStatefulWidget {
  const MyDraggableSheet({super.key});

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
    final selectedGraveId = ref.watch(selectedGraveIdProvider);

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
                              child: selectedGraveId == null
                                  ? const GraveListSheet()
                                  : _GraveDetailsLoader(graveId: selectedGraveId),
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

class _GraveDetailsLoader extends ConsumerWidget {
  const _GraveDetailsLoader({required this.graveId});

  final String graveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graveState = ref.watch(graveDetailsProvider(graveId));

    return graveState.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text(AppLocalizations.of(context)!.loading_error)),
      ),
      data: (grave) {
        final position = ref.watch(userLocationProvider).value;
        final distanceMeters = distanceToLocation(position, grave.location);

        return _GraveDetails(grave: grave, distanceMeters: distanceMeters);
      },
    );
  }
}

class _GraveDetails extends ConsumerWidget {
  const _GraveDetails({required this.grave, required this.distanceMeters});

  final Grave grave;
  final double? distanceMeters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat("dd.MM.yyyy");
    final birthDate = grave.birthDate != null ? dateFormat.format(grave.birthDate!) : "?";
    final deathDate = grave.deathDate != null ? dateFormat.format(grave.deathDate!) : "?";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: AppLocalizations.of(context)!.back_to_list,
            onPressed: () => ref.read(selectedGraveIdProvider.notifier).clear(),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${grave.firstName} ${grave.lastName}", style: context.textTheme.headlineMedium),
                const SizedBox(height: 8),

                Text("$birthDate - $deathDate", style: context.textTheme.bodyLarge),
              ],
            ),

            ProfileIconWidget(),
          ],
        ),

        const SizedBox(height: 8),

        Text(formatDistance(distanceMeters), style: context.textTheme.bodyMedium),

        const SizedBox(height: 16),

        GraveActionButtons(),

        const SizedBox(height: 16),

        ImageCarousel(photoIds: grave.photoIds),
        const SizedBox(height: 16),

        DetailsSection(biography: grave.biography ?? ""),

        const SizedBox(height: 8),

        FeedbackSection(),

        const SizedBox(height: 32),
      ],
    );
  }
}
