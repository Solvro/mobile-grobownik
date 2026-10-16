import "package:flutter_test/flutter_test.dart";
import "package:mobile_grobownik/common/models/location.dart";
import "package:mobile_grobownik/features/corrections/data/grave_correction.dart";
import "package:mobile_grobownik/features/grave/data/models/grave.dart";
import "package:mobile_grobownik/features/grave/data/models/grave_cemetery.dart";

void main() {
  final grave = Grave(
    id: "g1",
    firstName: "Jan",
    lastName: "Kowalski",
    birthDate: DateTime(1925, 7, 29),
    plot: "pole 1",
    cemetery: const GraveCemetery(id: "c1", name: "Osobowicki"),
  );

  test("editable values use Directus formats", () {
    final values = editableValuesOf(grave);

    expect(values[EditableGraveField.birthDate], "1925-07-29");
    expect(values[EditableGraveField.cemetery], "c1");
    expect(values[EditableGraveField.deathDate], isNull);
  });

  test("only changed fields end up in the diff", () {
    final original = editableValuesOf(grave);
    final edited = {...original, EditableGraveField.plot: "pole 2", EditableGraveField.deathDate: "2012-01-05"};

    final diff = diffEditableValues(original, edited);

    expect(diff.changes, {EditableGraveField.plot: "pole 2", EditableGraveField.deathDate: "2012-01-05"});
    expect(diff.previous, {EditableGraveField.plot: "pole 1", EditableGraveField.deathDate: null});
  });

  test("whitespace and blank values are not changes", () {
    final original = editableValuesOf(grave);
    final edited = {...original, EditableGraveField.firstName: "  Jan ", EditableGraveField.education: "   "};

    expect(diffEditableValues(original, edited).changes, isEmpty);
  });

  test("clearing a field proposes null", () {
    final original = editableValuesOf(grave);
    final diff = diffEditableValues(original, {...original, EditableGraveField.plot: ""});

    expect(diff.changes, {EditableGraveField.plot: null});
  });

  test("draft JSON links photos through the junction and skips empty parts", () {
    const draft = GraveCorrectionDraft(
      graveId: "g1",
      kind: CorrectionKind.photo,
      comment: "  ",
      photoIds: ["f1", "f2"],
      suggestedLocation: Location(type: "Point", coordinates: [17.0, 51.1]),
      locationAccuracy: 8,
    );

    expect(draft.toJson(), {
      "grave": "g1",
      "kind": "photo",
      "suggested_location": {
        "type": "Point",
        "coordinates": [17.0, 51.1],
      },
      "location_accuracy": 8.0,
      "photos": [
        {"directus_files_id": "f1"},
        {"directus_files_id": "f2"},
      ],
    });
  });
}
