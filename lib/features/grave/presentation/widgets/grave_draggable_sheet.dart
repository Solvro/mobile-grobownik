import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:intl/intl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../common/providers/bottom_sheet_extent_provider.dart";
import "../../../../common/providers/user_location_provider.dart";
import "../../../../common/utils/distance.dart";
import "../../../../common/widgets/bottom_sheet_handler.dart";
import "../../../../common/widgets/image_carousel.dart";
import "../../data/models/grave.dart";
import "../../data/repositories/graves_repository.dart";
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
    final selectedGraveId = ref.watch(selectedGraveIdProvider);

    return PopScope(
      canPop: selectedGraveId == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.read(selectedGraveIdProvider.notifier).clear();
      },
      child: LayoutBuilder(
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
      ),
    );
  }
}

class _GraveDetailsLoader extends ConsumerWidget {
  const _GraveDetailsLoader({required this.graveId});

  final String graveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graveState = ref.watch(graveRepositoryProvider(graveId));

    // The grave can disappear from the local database (a sync removed it).
    // There would be no way back from an empty details view, so go back to
    // the list.
    ref.listen(graveRepositoryProvider(graveId), (previous, next) {
      if (next.hasValue && next.value == null) {
        ref.read(selectedGraveIdProvider.notifier).clear();
      }
    });

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
        if (grave == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text(AppLocalizations.of(context)!.no_graves_found)),
          );
        }

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
            icon: Icon(Icons.arrow_back, semanticLabel: AppLocalizations.of(context)!.back_to_list),
            tooltip: AppLocalizations.of(context)!.back_to_list,
            onPressed: () async {
              await HapticFeedback.lightImpact();
              ref.read(selectedGraveIdProvider.notifier).clear();
            },
          ),
        ),
        Text("${grave.firstName} ${grave.lastName}", style: context.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text("$birthDate - $deathDate", style: context.textTheme.bodyLarge),
        const SizedBox(height: 8),
        if (distanceMeters != null)
          Text(
            AppLocalizations.of(context)!.grave_distance_from_you(formatDistance(distanceMeters)),
            style: context.textTheme.bodyMedium,
          ),
        const SizedBox(height: 16),
        GraveActionButtons(),
        const SizedBox(height: 16),
        ImageCarousel(photoIds: grave.photoIds),
        const SizedBox(height: 16),
        DetailsSection(grave: grave),
        const SizedBox(height: 8),
        FeedbackSection(),
        const SizedBox(height: 32),
      ],
    );
  }
}
