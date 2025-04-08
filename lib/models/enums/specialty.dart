enum Specialty {
  neutral,
  timeHalved,
  yieldDouble,
}

extension SpecialtyExtension on Specialty {
  String get label {
    switch (this) {
      case Specialty.neutral:
        return "Neutre";
      case Specialty.timeHalved:
        return "Temps / 2";
      case Specialty.yieldDouble:
        return "Rendement x2";
    }
  }

  static Specialty fromString(String value) {
    switch (value) {
      case "Temps / 2":
        return Specialty.timeHalved;
      case "Rendement x2":
        return Specialty.yieldDouble;
      default:
        return Specialty.neutral;
    }
  }

  String toFirestore() => label;
}
