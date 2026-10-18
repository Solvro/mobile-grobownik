import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../common/models/location.dart";
import "../../../../common/network/directus_client.dart";
import "../../../grave/data/models/grave.dart";
import "../../data/grave_correction.dart";
import "../../data/grave_corrections_repository.dart";
import "../providers/cemetery_options_provider.dart";
import "location_picker_screen.dart";

const _maxPhotos = 5;

class GraveCorrectionScreen extends HookConsumerWidget {
  const GraveCorrectionScreen({required this.grave, required this.kind, super.key});

  final Grave grave;
  final CorrectionKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final photosOnly = kind == CorrectionKind.photo;

    final original = useMemoized(() => editableValuesOf(grave), [grave]);
    final textControllers = {
      for (final field in [
        EditableGraveField.firstName,
        EditableGraveField.lastName,
        EditableGraveField.education,
        EditableGraveField.biography,
        EditableGraveField.plot,
        EditableGraveField.directions,
      ])
        field: useTextEditingController(text: original[field] ?? ""),
    };
    final birthDate = useState(original[EditableGraveField.birthDate]);
    final deathDate = useState(original[EditableGraveField.deathDate]);
    final cemeteryId = useState(original[EditableGraveField.cemetery]);
    final pickedLocation = useState<Location?>(null);
    final photos = useState(<XFile>[]);
    final commentController = useTextEditingController();
    final progress = useState<String?>(null);

    [...textControllers.values, commentController].forEach(useListenable);

    Map<String, String?> editedValues() => {
      for (final MapEntry(:key, :value) in textControllers.entries) key: value.text,
      EditableGraveField.birthDate: birthDate.value,
      EditableGraveField.deathDate: deathDate.value,
      EditableGraveField.cemetery: cemeteryId.value,
    };

    final diff = photosOnly ? null : diffEditableValues(original, editedValues());
    final hasInput =
        (diff?.changes.isNotEmpty ?? false) ||
        photos.value.isNotEmpty ||
        pickedLocation.value != null ||
        commentController.text.trim().isNotEmpty;

    final busy = progress.value != null;

    return PopScope(
      canPop: !hasInput && !busy,
      onPopInvokedWithResult: (didPop, result) => _onPopBlocked(context, didPop: didPop, busy: busy),
      child: Scaffold(
        appBar: AppBar(title: Text(photosOnly ? l10n.add_photos : l10n.suggest_fix)),
        body: AbsorbPointer(
          absorbing: busy,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text("${grave.firstName} ${grave.lastName}", style: context.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                photosOnly ? l10n.photo_intro : l10n.correction_intro,
                style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
              if (!photosOnly) ...[
                _SectionHeader(l10n.correction_section_person),
                _TextField(controller: textControllers[EditableGraveField.firstName]!, label: l10n.field_first_name),
                _TextField(controller: textControllers[EditableGraveField.lastName]!, label: l10n.field_last_name),
                _DateField(label: l10n.field_birth_date, value: birthDate),
                _DateField(label: l10n.field_death_date, value: deathDate),
                _TextField(controller: textControllers[EditableGraveField.education]!, label: l10n.grave_education),
                _TextField(
                  controller: textControllers[EditableGraveField.biography]!,
                  label: l10n.grave_biography_title,
                  multiline: true,
                ),
                _SectionHeader(l10n.correction_section_place),
                _CemeteryField(value: cemeteryId),
                _TextField(controller: textControllers[EditableGraveField.plot]!, label: l10n.grave_plot),
                _TextField(
                  controller: textControllers[EditableGraveField.directions]!,
                  label: l10n.grave_directions,
                  multiline: true,
                ),
                _LocationField(current: grave.location, picked: pickedLocation),
              ],
              _SectionHeader(l10n.correction_section_photos),
              _PhotoPicker(photos: photos, onPick: (source) => _pickPhotos(context, photos, source)),
              const SizedBox(height: 16),
              _TextField(controller: commentController, label: l10n.correction_comment, multiline: true),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: busy
                    ? null
                    : () async {
                        await HapticFeedback.selectionClick();
                        if (!context.mounted) return;
                        await _validateAndSubmit(
                          context,
                          ref,
                          problem: _validationProblem(
                            l10n,
                            photosOnly: photosOnly,
                            hasPhotos: photos.value.isNotEmpty,
                            hasInput: hasInput,
                          ),
                          photos: photos.value,
                          progress: progress,
                          draft: (photoIds) => GraveCorrectionDraft(
                            graveId: grave.id,
                            kind: kind,
                            changes: diff?.changes ?? const {},
                            previous: diff?.previous ?? const {},
                            suggestedLocation: pickedLocation.value,
                            comment: commentController.text,
                            photoIds: photoIds,
                          ),
                        );
                      },
                icon: busy
                    ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(Icons.send_outlined, semanticLabel: l10n.correction_submit),
                label: Text(progress.value ?? l10n.correction_submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _validationProblem(
  AppLocalizations l10n, {
  required bool photosOnly,
  required bool hasPhotos,
  required bool hasInput,
}) {
  if (photosOnly && !hasPhotos) return l10n.correction_no_photos;
  if (!hasInput) return l10n.correction_nothing_changed;

  return null;
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> _pickPhotos(BuildContext context, ValueNotifier<List<XFile>> photos, ImageSource source) async {
  final l10n = AppLocalizations.of(context)!;
  final free = _maxPhotos - photos.value.length;
  if (free <= 0) {
    _showMessage(context, l10n.correction_photos_limit(_maxPhotos.toString()));
    return;
  }

  final picker = ImagePicker();
  final picked = source == ImageSource.camera
      ? [?await picker.pickImage(source: source, maxWidth: 2048, imageQuality: 85)]
      : await picker.pickMultiImage(maxWidth: 2048, imageQuality: 85, limit: free > 1 ? free : null);
  if (!context.mounted) return;

  if (picked.length > free) _showMessage(context, l10n.correction_photos_limit(_maxPhotos.toString()));
  photos.value = [...photos.value, ...picked.take(free)];
}

Future<void> _onPopBlocked(BuildContext context, {required bool didPop, required bool busy}) async {
  if (didPop || busy) return;

  final navigator = Navigator.of(context);
  if (await _confirmDiscard(context)) navigator.pop();
}

Future<void> _validateAndSubmit(
  BuildContext context,
  WidgetRef ref, {
  required String? problem,
  required List<XFile> photos,
  required ValueNotifier<String?> progress,
  required GraveCorrectionDraft Function(List<String> photoIds) draft,
}) async {
  if (problem != null) {
    _showMessage(context, problem);
    return;
  }

  await _submitCorrection(context, ref, photos: photos, progress: progress, draft: draft);
}

Future<void> _submitCorrection(
  BuildContext context,
  WidgetRef ref, {
  required List<XFile> photos,
  required ValueNotifier<String?> progress,
  required GraveCorrectionDraft Function(List<String> photoIds) draft,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final dio = ref.read(directusClientProvider);
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  try {
    final photoIds = <String>[];
    for (final (index, photo) in photos.indexed) {
      progress.value = l10n.correction_uploading("${index + 1}", "${photos.length}");
      photoIds.add(await dio.uploadCorrectionPhoto(photo));
    }
    progress.value = l10n.correction_submit;

    await dio.submitGraveCorrection(draft(photoIds));

    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.correction_sent)));
  } on Object {
    if (context.mounted) _showMessage(context, l10n.correction_failed);
  } finally {
    if (context.mounted) progress.value = null;
  }
}

Future<bool> _confirmDiscard(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final discard = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.correction_discard_title),
      content: Text(l10n.correction_discard_body),
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
          child: Text(l10n.correction_discard_confirm),
        ),
      ],
    ),
  );

  return discard ?? false;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.controller, required this.label, this.multiline = false});

  final TextEditingController controller;
  final String label;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        minLines: multiline ? 2 : 1,
        maxLines: multiline ? 6 : 1,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.value});

  final String label;
  final ValueNotifier<String?> value;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = value.value == null ? null : DateTime.tryParse(value.value!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          await HapticFeedback.selectionClick();
          if (!context.mounted) return;
          final picked = await showDatePicker(
            context: context,
            initialDate: current ?? DateTime(1950),
            firstDate: DateTime(1800),
            lastDate: DateTime.now(),
          );
          if (picked != null) value.value = DateFormat("yyyy-MM-dd").format(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: current == null
                ? Icon(Icons.calendar_today_outlined, semanticLabel: label)
                : IconButton(
                    tooltip: l10n.correction_clear,
                    icon: Icon(Icons.clear, semanticLabel: l10n.correction_clear),
                    onPressed: () async {
                      await HapticFeedback.selectionClick();
                      value.value = null;
                    },
                  ),
          ),
          child: Text(current == null ? "" : DateFormat("dd.MM.yyyy").format(current)),
        ),
      ),
    );
  }
}

class _CemeteryField extends ConsumerWidget {
  const _CemeteryField({required this.value});

  final ValueNotifier<String?> value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final options = ref.watch(cemeteryOptionsProvider).value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) => DropdownMenu<String?>(
          key: ValueKey(options == null),
          width: constraints.maxWidth,
          label: Text(l10n.grave_cemetery),
          initialSelection: value.value,
          enabled: options != null,
          enableFilter: true,
          requestFocusOnTap: true,
          menuHeight: 320,
          onSelected: (selected) => value.value = selected,
          dropdownMenuEntries: [
            DropdownMenuEntry(value: null, label: l10n.correction_cemetery_none),
            for (final cemetery in options ?? const <CemeteryOption>[])
              DropdownMenuEntry(
                value: cemetery.id,
                label: cemetery.address == null ? cemetery.name : "${cemetery.name} (${cemetery.address})",
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({required this.current, required this.picked});

  final Location? current;
  final ValueNotifier<Location?> picked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final location = picked.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.correction_location_title,
          border: const OutlineInputBorder(),
          suffixIcon: location == null
              ? null
              : IconButton(
                  tooltip: l10n.correction_clear,
                  icon: Icon(Icons.clear, semanticLabel: l10n.correction_clear),
                  onPressed: () async {
                    await HapticFeedback.selectionClick();
                    picked.value = null;
                  },
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location == null
                  ? l10n.correction_location_unchanged
                  : l10n.correction_location_picked(
                      "${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}",
                    ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              icon: Icon(Icons.pin_drop_outlined, semanticLabel: l10n.correction_location_pick),
              label: Text(l10n.correction_location_pick),
              onPressed: () async {
                await HapticFeedback.selectionClick();
                if (!context.mounted) return;
                final result = await Navigator.push<Location>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationPickerScreen(current: current, initial: location),
                  ),
                );
                if (result != null) picked.value = result;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.photos, required this.onPick});

  final ValueNotifier<List<XFile>> photos;
  final Future<void> Function(ImageSource source) onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final photo in photos.value)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(photo.path),
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  semanticLabel: l10n.correction_photo_preview,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton.filledTonal(
                  visualDensity: VisualDensity.compact,
                  tooltip: l10n.correction_photo_remove,
                  icon: Icon(Icons.close, size: 18, semanticLabel: l10n.correction_photo_remove),
                  onPressed: () async {
                    await HapticFeedback.selectionClick();
                    photos.value = [...photos.value]..remove(photo);
                  },
                ),
              ),
            ],
          ),
        if (photos.value.length < _maxPhotos)
          SizedBox.square(
            dimension: 96,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await HapticFeedback.selectionClick();
                if (!context.mounted) return;
                final source = await showModalBottomSheet<ImageSource>(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.photo_camera_outlined, semanticLabel: l10n.correction_photo_camera),
                          title: Text(l10n.correction_photo_camera),
                          onTap: () async {
                            await HapticFeedback.selectionClick();
                            if (context.mounted) Navigator.pop(context, ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library_outlined, semanticLabel: l10n.correction_photo_gallery),
                          title: Text(l10n.correction_photo_gallery),
                          onTap: () async {
                            await HapticFeedback.selectionClick();
                            if (context.mounted) Navigator.pop(context, ImageSource.gallery);
                          },
                        ),
                      ],
                    ),
                  ),
                );
                if (source != null) await onPick(source);
              },
              child: Icon(Icons.add_a_photo_outlined, semanticLabel: l10n.add_photos),
            ),
          ),
      ],
    );
  }
}
