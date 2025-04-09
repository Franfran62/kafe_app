import 'package:flutter/material.dart';
import 'package:kafe_app/models/wrapper/harvest_result.dart';

Future<void> showHarvestResultDialog(BuildContext context, HarvestResult result) async {
  final title = result.isPerfectTiming
      ? "Félicitation, timing super ! Vous avez obtenu :"
      : "C’est une récolte tardive ! Vous avez  obtenu :";

  final ratioLabel = result.isPerfectTiming
      ? ""
      : "(${(result.penalty * 100).toInt()}% de rendement)";

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(child: Text(title)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: Text("${result.weight.toStringAsFixed(2)} kg de ${result.type.name} 🌱 $ratioLabel")),
          const SizedBox(height: 4),
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            child: const Text("Continuer"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        )
      ],
    ),
  );
}
