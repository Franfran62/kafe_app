import 'package:kafe_app/models/enums/kafe_type.dart';

class HarvestResult {
  final KafeType type;
  final double weight;
  final double penalty;
  final double timeRatio;

  HarvestResult({
    required this.type,
    required this.weight,
    required this.penalty,
    required this.timeRatio,
  });

  bool get isPerfectTiming => timeRatio <= 1.0;
}
