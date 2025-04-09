// 📁 blend_screen.dart
import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/game/game_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>().stock;
    if (stock == null) return const Center(child: CircularProgressIndicator());

    final grains = stock.grains;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Stock de Grains ${GameAsset.GrainEmoji}",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        // Ajoute une row par grain, avec nom : quantité dnas les stocks
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text("Assembler un Kafé ${GameAsset.kafeEmoji} :",
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 8),
              ...grains.entries.where((e) => e.value > 0).map((entry) {
                final type = entry.key;
                final available = entry.value;
                final selected = _selection[type] ?? 0;
          
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(type.label, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 4),
                        Slider(
                          value: selected.clamp(0, available),
                          min: 0,
                          max: available,
                          divisions: 100,
                          label: "${selected.toStringAsFixed(2)} g",
                          onChanged: (value) {
                            setState(() => _selection[type] = value);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.coffee),
                label: const Text("Assembler ce blend"),
                onPressed: _selection.values.any((v) => v > 0)
                    ? () async {
                        await GameController().createBlend(
                          context: context,
                          selectedGrains: _selection,
                        );
          
                        if (mounted) {
                          await showBlendResultModal(context);
                          setState(() => _selection.clear());
                        }
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
