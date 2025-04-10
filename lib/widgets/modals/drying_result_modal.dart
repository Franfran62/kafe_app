import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';

class DryingResultModal extends StatelessWidget {
  final KafeType type;
  final double resultAmount;

  const DryingResultModal({
    super.key,
    required this.type,
    required this.resultAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/drying.json',
              height: 140,
              repeat: true,
            ),
            const SizedBox(height: 16),
            Text(
              "Séchage terminé !",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              "Tu as produit ${resultAmount.toStringAsFixed(2)} g de grains de ${type.label}.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}
