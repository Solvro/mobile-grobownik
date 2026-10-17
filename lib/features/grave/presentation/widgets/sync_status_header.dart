import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:intl/intl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../common/sync/sync_controller.dart";
import "../../../../common/sync/sync_status.dart";

/// Shows the state of the last synchronization above the list of graves and
/// lets the user start a new one by hand.
class SyncStatusHeader extends ConsumerWidget {
  const SyncStatusHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final status = ref.watch(syncControllerProvider);
    final message = _message(l10n, status);
    final color = status is SyncFailure ? context.colorScheme.error : context.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          _StatusIcon(status: status, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: message == null
                ? const SizedBox.shrink()
                : Semantics(
                    liveRegion: true,
                    child: Text(message, style: context.textTheme.bodySmall?.copyWith(color: color)),
                  ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, semanticLabel: l10n.sync_refresh_semantic_label),
            tooltip: l10n.sync_refresh,
            onPressed: status is SyncInProgress
                ? null
                : () {
                    unawaited(HapticFeedback.lightImpact());
                    unawaited(ref.read(syncControllerProvider.notifier).sync());
                  },
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status, required this.color});

  final SyncStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      SyncInProgress() => const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
      SyncSuccess() => Icon(Icons.cloud_done_outlined, size: 18, color: color),
      SyncFailure(isOffline: true) => Icon(Icons.cloud_off_outlined, size: 18, color: color),
      SyncFailure() => Icon(Icons.error_outline, size: 18, color: color),
      SyncIdle() => Icon(Icons.cloud_outlined, size: 18, color: color),
    };
  }
}

String? _message(AppLocalizations l10n, SyncStatus status) {
  return switch (status) {
    SyncIdle(:final lastSyncedAt) => lastSyncedAt == null ? null : l10n.sync_data_from(_formatTime(lastSyncedAt)),
    SyncInProgress() => l10n.sync_in_progress,
    SyncSuccess(:final lastSyncedAt) => l10n.sync_synced_at(_formatTime(lastSyncedAt)),
    SyncFailure(:final lastSyncedAt, isOffline: true) =>
      lastSyncedAt == null ? l10n.sync_offline_no_data : l10n.sync_offline_with_data(_formatTime(lastSyncedAt)),
    SyncFailure(:final lastSyncedAt) =>
      lastSyncedAt == null ? l10n.sync_failed_no_data : l10n.sync_failed_with_data(_formatTime(lastSyncedAt)),
  };
}

String _formatTime(DateTime value) => DateFormat("dd.MM.yyyy HH:mm").format(value.toLocal());
