import "package:intl/intl.dart";

import "../../../common/models/location.dart";
import "../../grave/data/models/grave.dart";

enum CorrectionKind { correction, photo }

abstract final class EditableGraveField {
  static const firstName = "firstName";
  static const lastName = "lastName";
  static const birthDate = "birthDate";
  static const deathDate = "deathDate";
  static const education = "education";
  static const biography = "biography";
  static const cemetery = "cemetery";
  static const plot = "plot";
  static const directions = "directions";

  static const all = [firstName, lastName, birthDate, deathDate, education, biography, cemetery, plot, directions];
}

final _dateFormat = DateFormat("yyyy-MM-dd");

Map<String, String?> editableValuesOf(Grave grave) => {
  EditableGraveField.firstName: grave.firstName,
  EditableGraveField.lastName: grave.lastName,
  EditableGraveField.birthDate: grave.birthDate == null ? null : _dateFormat.format(grave.birthDate!),
  EditableGraveField.deathDate: grave.deathDate == null ? null : _dateFormat.format(grave.deathDate!),
  EditableGraveField.education: grave.education,
  EditableGraveField.biography: grave.biography,
  EditableGraveField.cemetery: grave.cemetery?.id,
  EditableGraveField.plot: grave.plot,
  EditableGraveField.directions: grave.directions,
};

String? _normalize(String? value) {
  final trimmed = value?.trim();

  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

({Map<String, String?> changes, Map<String, String?> previous}) diffEditableValues(
  Map<String, String?> original,
  Map<String, String?> edited,
) {
  final changes = <String, String?>{};
  final previous = <String, String?>{};
  for (final field in EditableGraveField.all) {
    if (!edited.containsKey(field)) continue;

    final before = _normalize(original[field]);
    final after = _normalize(edited[field]);
    if (before == after) continue;

    changes[field] = after;
    previous[field] = before;
  }

  return (changes: changes, previous: previous);
}

class GraveCorrectionDraft {
  const GraveCorrectionDraft({
    required this.graveId,
    required this.kind,
    this.changes = const {},
    this.previous = const {},
    this.suggestedLocation,
    this.locationAccuracy,
    this.comment,
    this.photoIds = const [],
  });

  final String graveId;
  final CorrectionKind kind;
  final Map<String, String?> changes;
  final Map<String, String?> previous;

  final Location? suggestedLocation;

  final double? locationAccuracy;
  final String? comment;
  final List<String> photoIds;

  Map<String, Object?> toJson() => {
    "grave": graveId,
    "kind": kind.name,
    if (changes.isNotEmpty) "changes": changes,
    if (previous.isNotEmpty) "previous": previous,
    if (suggestedLocation != null) "suggested_location": suggestedLocation!.toJson(),
    if (locationAccuracy != null) "location_accuracy": locationAccuracy,
    "comment": ?_normalize(comment),
    if (photoIds.isNotEmpty)
      "photos": [
        for (final id in photoIds) {"directus_files_id": id},
      ],
  };
}
