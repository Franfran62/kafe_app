class GameConfig {

  // Fields

  // Cout d'achat d'un champ
  static const int fieldPurchaseCost = 1;
  // Nombre de slots par champ
  static const int slotsPerField = 4;
  // Multiplieur de rendement pour champ spécialisé
  static const double yieldMultiplier = 2.0;
  // Réduction de temps pour champ spécialisé
  static const double timeReductionFactor = 0.5;

  // Harvest
  // Perte de rendement si récolte tardive
  static const double lateHarvestPenalty = 0.5;
  // Temps de récolte
  static Duration growthTimeFor(String fruit) => fruitGrowthTimes[fruit] ?? const Duration(minutes: 30);
  static const Map<String, Duration> fruitGrowthTimes = {
    "Rubisca": Duration(minutes: 30),
    "Arbrista": Duration(minutes: 45),
    "Roupetta": Duration(minutes: 20),
    "Tourista": Duration(minutes: 35),
    "Goldoria": Duration(minutes: 60),
  };
}

