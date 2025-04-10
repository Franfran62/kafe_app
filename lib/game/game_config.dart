import 'package:kafe_app/models/enums/kafe_type.dart';

class GameConfig {

  // -------------------------
  // Fields
  // -------------------------

  // Cout d'achat d'un champ
  static const int fieldPurchaseCost = 15;
  // Nombre de slots par champ
  static const int slotsPerField = 4;
  // Multiplieur de rendement pour champ spécialisé
  static const double yieldMultiplier = 2.0;
  // Réduction de temps pour champ spécialisé
  static const double timeReductionFactor = 0.5;

  // -------------------------
  // Harvest
  // -------------------------

  // Pénalité de récolte
  static const double harvestHardPenalty = 0.2;
  static const double harvestMediumPenalty = 0.5;
  static const double harvestLowPenalty = 0.8;
  // Temps de récolte
  static Duration growthTimeFor(String type) {
    final kafe = KafeTypeExtension.fromString(type);
    return growthTimes[kafe]!;
  }
  static final Map<KafeType, Duration> growthTimes = {
    KafeType.rubisca: Duration(minutes: 1),
    KafeType.arbrista: Duration(minutes: 4),
    KafeType.roupetta: Duration(minutes: 2),
    KafeType.tourista: Duration(minutes: 1),
    KafeType.goldoria: Duration(minutes: 3),
  };
  // Prix de plantation
  static int costFor(KafeType type) => plantingCosts[type]!;
  static final Map<KafeType, int> plantingCosts = {
    KafeType.rubisca: 2,
    KafeType.arbrista: 6,
    KafeType.roupetta: 3,
    KafeType.tourista: 1,
    KafeType.goldoria: 2,
  };
  // Poids du fruit
  static double fruitWeight(KafeType type) => fruitWeights[type]!;
  static final Map<KafeType, double> fruitWeights = {
    KafeType.rubisca: 0.632,
    KafeType.arbrista: 0.274,
    KafeType.roupetta: 0.461,
    KafeType.tourista: 0.961,
    KafeType.goldoria: 0.473,
  };

  // -------------------------
  // Drying
  // -------------------------

  // ratio de perte
  static const double dryingLossRatio = 0.0458;


  // --------------------------
  // Blend
  // --------------------------


  // Prix de vente
  static int blendSellPrice = 3;
  // Les GATO
  static List<String> gatoList() => [
    'gout',
    'amertume',
    'teneur',
    'odorat',
  ];

  // Les grains
  static Map<String, int> gato(KafeType type) => gatoStats[type]!;
  static final Map<KafeType, Map<String, int>> gatoStats = {
    KafeType.rubisca: {
      'gout': 15,
      'amertume': 54,
      'teneur': 35,
      'odorat': 19,
    },
    KafeType.arbrista: {
      'gout': 87,
      'amertume': 4,
      'teneur': 35,
      'odorat': 59,
    },
    KafeType.roupetta: {
      'gout': 35,
      'amertume': 41,
      'teneur': 75,
      'odorat': 67,
    },
    KafeType.tourista: {
      'gout': 3,
      'amertume': 91,
      'teneur': 74,
      'odorat': 6,
    },
    KafeType.goldoria: {
      'gout': 39,
      'amertume': 9,
      'teneur': 7,
      'odorat': 87,
    },
  };
}

