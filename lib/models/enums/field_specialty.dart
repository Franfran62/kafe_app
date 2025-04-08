enum FieldSpecialty {
  neutral,
  timeHalved,
  yieldDouble,
}

extension FieldSpecialtyExtension on FieldSpecialty {
  String get label {
    switch (this) {
      case FieldSpecialty.neutral:
        return "Neutre";
      case FieldSpecialty.timeHalved:
        return "Temps / 2";
      case FieldSpecialty.yieldDouble:
        return "Rendement x2";
    }
  }

  static FieldSpecialty fromString(String value) {
    switch (value) {
      case "Temps / 2":
        return FieldSpecialty.timeHalved;
      case "Rendement x2":
        return FieldSpecialty.yieldDouble;
      default:
        return FieldSpecialty.neutral;
    }
  }

  double get growthFactor {
    switch (this) {
      case FieldSpecialty.timeHalved:
        return 0.5;
      default:
        return 1.0;
    }
  }

  String toFirestore() => label;
}
