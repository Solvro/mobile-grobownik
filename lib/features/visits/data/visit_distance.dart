import "../../grave/data/models/grave.dart";

const maxVisitDistanceExactMeters = 75.0;

const maxVisitDistanceApproximateMeters = 200.0;

double? maxVisitDistanceFor(Grave grave) {
  if (grave.location == null) return null;

  return grave.locationPrecision == LocationPrecision.grave
      ? maxVisitDistanceExactMeters
      : maxVisitDistanceApproximateMeters;
}
