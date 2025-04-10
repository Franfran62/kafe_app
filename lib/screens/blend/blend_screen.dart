import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/game/game_controller.dart';
import 'package:kafe_app/models/blend.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/providers/stock_provider.dart';
import 'package:kafe_app/widgets/modals/blend_result_modal.dart';
import 'package:provider/provider.dart';

class BlendScreen extends StatefulWidget {
  const BlendScreen({super.key});

  @override
  State<BlendScreen> createState() => _BlendScreenState();
}

class _BlendScreenState extends State<BlendScreen> {
  final Map<KafeType, double> _selection = {};
  final GameController _gameController = GameController();

  double get totalSelectedWeight =>
      _selection.values.fold(0.0, (sum, v) => sum + v);

    @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>().stock;
    if (stock == null) return const Center(child: CircularProgressIndicator());

    final grains = stock.grains;
    final totalStock = grains.values.fold(0.0, (sum, v) => sum + v);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Stock de Grains ${GameAsset.GrainEmoji}",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ...grains.entries.map((entry) {
            final type = entry.key;
            final available = entry.value;
            final selected = _selection[type] ?? 0;
            final remaining = (available - selected).clamp(0, double.infinity);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type.label),
                Text(
                  "${remaining.toStringAsFixed(2)} kg",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            );
          }).toList(),

          const SizedBox(height: 24),
          Text("Assembler un Kafé ${GameAsset.kafeEmoji} :",
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),

          if (totalStock < 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  "Tu n'as pas encore assez de grains. Reviens avec plus de stock pour faire un assemblage !",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else ...grains.entries.where((e) => e.value > 0).map((entry) {
            final type = entry.key;
            final available = entry.value;
            final selected = _selection[type] ?? 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type.label, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Slider(
                  value: selected.clamp(0, available),
                  min: 0,
                  max: available,
                  divisions: 100,
                  label: "${selected.toStringAsFixed(2)} kg",
                  onChanged: (value) {
                    setState(() => _selection[type] = value);
                  },
                ),
              ],
            );
          }),
          if (totalStock > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                "Poids total (kg) : ${totalSelectedWeight.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          if (totalStock > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.coffee),
                label: const Text("Assembler"),
                onPressed: totalSelectedWeight >= 1
                    ? () async {
                        Blend? blend = await _gameController.createBlend(
                          context: context,
                          selectedGrains: _selection,
                        );
            
                        if (mounted && blend != null) {
                          setState(() => _selection.clear());
                          await showBlendResultModal(context, blend);
                        }
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}