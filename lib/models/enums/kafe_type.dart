enum KafeType {
  rubisca,
  arbrista,
  roupetta,
  tourista,
  goldoria,
}

extension KafeTypeExtension on KafeType {
  String get label {
    switch (this) {
      case KafeType.rubisca:
        return "Rubisca";
      case KafeType.arbrista:
        return "Arbrista";
      case KafeType.roupetta:
        return "Roupetta";
      case KafeType.tourista:
        return "Tourista";
      case KafeType.goldoria:
        return "Goldoria";
    }
  }

  static KafeType fromString(String value) {
    return KafeType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => KafeType.rubisca,
    );
  }
}
