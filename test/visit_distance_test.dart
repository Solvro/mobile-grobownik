import "package:flutter_test/flutter_test.dart";
import "package:mobile_grobownik/common/models/location.dart";
import "package:mobile_grobownik/features/grave/data/models/grave.dart";
import "package:mobile_grobownik/features/visits/data/visit_distance.dart";

void main() {
  const location = Location(type: "Point", coordinates: [17.03, 51.11]);
  const grave = Grave(id: "1", firstName: "Jan", lastName: "Kowalski", location: location);

  test("exact grave location uses the small limit", () {
    expect(
      maxVisitDistanceFor(grave.copyWith(locationPrecision: LocationPrecision.grave)),
      maxVisitDistanceExactMeters,
    );
  });

  test("middle of the field uses the large limit", () {
    expect(
      maxVisitDistanceFor(grave.copyWith(locationPrecision: LocationPrecision.field)),
      maxVisitDistanceApproximateMeters,
    );
  });

  test("unknown precision uses the large limit", () {
    expect(maxVisitDistanceFor(grave), maxVisitDistanceApproximateMeters);
    expect(
      maxVisitDistanceFor(grave.copyWith(locationPrecision: LocationPrecision.unknown)),
      maxVisitDistanceApproximateMeters,
    );
  });

  test("no location means no check", () {
    expect(maxVisitDistanceFor(grave.copyWith(location: null, locationPrecision: LocationPrecision.grave)), isNull);
  });
}
