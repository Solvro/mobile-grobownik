import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:geolocator/geolocator.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:intl/intl.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../common/models/location.dart";
import "../../../../common/providers/user_location_provider.dart";
import "../../../../common/utils/distance.dart";
import "../../../auth/presentation/require_login.dart";
import "../../../user_stats/presentation/providers/user_stats_provider.dart";
import "../../../visits/data/models/visit_record.dart";
import "../../../visits/data/repositories/visits_repository.dart";
import "../../../visits/data/visit_distance.dart";
import "../../../visits/presentation/providers/grave_visits_provider.dart";
import "../../data/models/grave.dart";

enum _VisitState { idle, saving, saved }

Future<void> _openInGoogleMaps(Location location) async {
  final uri = Uri.https("www.google.com", "/maps/dir/", {
    "api": "1",
    "destination": "${location.latitude},${location.longitude}",
    "travelmode": "walking",
  });
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

DateTime? _visitToday(Iterable<VisitRecord>? visits) {
  final now = DateTime.now();
  for (final visit in visits ?? const <VisitRecord>[]) {
    final visitedAt = visit.visitedAt?.toLocal();
    if (visitedAt != null && visitedAt.year == now.year && visitedAt.month == now.month && visitedAt.day == now.day) {
      return visitedAt;
    }
  }

  return null;
}

Future<bool> _confirmAnotherVisitToday(BuildContext context, DateTime visitToday) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        Icons.warning_amber_rounded,
        color: context.colorScheme.primary,
        semanticLabel: l10n.visit_again_today_title,
      ),
      title: Text(l10n.visit_again_today_title),
      content: Text(l10n.visit_again_today_body(DateFormat("HH:mm").format(visitToday))),
      actions: [
        TextButton(
          onPressed: () async {
            await HapticFeedback.selectionClick();
            if (context.mounted) Navigator.pop(context, false);
          },
          child: Text(l10n.action_cancel),
        ),
        FilledButton(
          onPressed: () async {
            await HapticFeedback.selectionClick();
            if (context.mounted) Navigator.pop(context, true);
          },
          child: Text(l10n.visit_again_today_confirm),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}

bool _isOfflineError(DioException error) => switch (error.type) {
  DioExceptionType.connectionError ||
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout => true,
  _ => false,
};

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<Position?> _positionForVisit(BuildContext context, WidgetRef ref, Grave grave) async {
  final l10n = AppLocalizations.of(context)!;
  if (!await requireLogin(context, ref) || !context.mounted) return null;

  final position = ref.read(userLocationProvider).value;
  if (position == null) {
    _showMessage(context, l10n.visit_no_location);
    return null;
  }

  final maxDistance = maxVisitDistanceFor(grave);
  final distance = distanceToLocation(position, grave.location);
  if (maxDistance != null && distance != null && distance > maxDistance) {
    _showMessage(context, l10n.visit_too_far(formatDistance(distance), formatDistance(maxDistance)));
    return null;
  }

  final visitToday = _visitToday(ref.read(graveVisitsProvider(grave.id)).value);
  if (visitToday != null && !await _confirmAnotherVisitToday(context, visitToday)) return null;

  return position;
}

Future<void> _markAsVisited(
  BuildContext context,
  WidgetRef ref,
  Grave grave,
  ValueNotifier<_VisitState> visitState,
) async {
  final l10n = AppLocalizations.of(context)!;
  final position = await _positionForVisit(context, ref, grave);
  if (position == null || !context.mounted) return;

  visitState.value = _VisitState.saving;
  try {
    await ref
        .read(visitsRepositoryProvider.notifier)
        .markGraveAsVisited(
          graveId: grave.id,
          currentSubmissionLocation: Location(type: "Point", coordinates: [position.longitude, position.latitude]),
        );
    if (!context.mounted) return;

    visitState.value = _VisitState.saved;
    ref
      ..invalidate(graveVisitsProvider(grave.id))
      ..invalidate(userStatsControllerProvider);
    _showMessage(context, l10n.visit_saved);
  } on Object catch (error) {
    if (!context.mounted) return;

    visitState.value = _VisitState.idle;
    final offline = error is VisitSubmissionException && _isOfflineError(error.cause);
    _showMessage(context, offline ? l10n.visit_offline : l10n.visit_save_failed);
  }
}

class GraveActionButtons extends HookConsumerWidget {
  const GraveActionButtons({required this.grave, super.key});

  final Grave grave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visitState = useState(_VisitState.idle);

    ref.watch(visitsRepositoryProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: visitState.value == _VisitState.idle
              ? () async {
                  await HapticFeedback.selectionClick();
                  if (context.mounted) await _markAsVisited(context, ref, grave, visitState);
                }
              : null,
          icon: switch (visitState.value) {
            _VisitState.saving => const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            _ => Icon(Icons.done, semanticLabel: l10n.mark_as_visited_semantic_label),
          },
          label: Text(visitState.value == _VisitState.saved ? l10n.visit_marked : l10n.mark_as_visited),
        ),
        const SizedBox(width: 12),
        FilledButton.tonalIcon(
          onPressed: grave.location == null
              ? null
              : () async {
                  await HapticFeedback.selectionClick();
                  await _openInGoogleMaps(grave.location!);
                },
          icon: Icon(Icons.navigation, semanticLabel: l10n.navigate_semantic_label),
          label: Text(l10n.navigate),
        ),
      ],
    );
  }
}
