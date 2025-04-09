import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/game/game_config.dart';
import 'package:kafe_app/game/game_controller.dart';
import 'package:kafe_app/models/enums/kafe_type.dart';
import 'package:kafe_app/providers/stock_provider.dart';
import 'package:kafe_app/widgets/modals/drying_modal.dart';
import 'package:provider/provider.dart';

class DryingScreen extends StatelessWidget {
  const DryingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>().stock;
    if (stock == null) return const Center(child: CircularProgressIndicator());

    final fruits = stock.fruits.entries.where((e) => e.value > 0);

    if (fruits.isEmpty) {
      return const Center(child: Text("Aucun fruit à sécher."));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: fruits.map((entry) {
        final type = entry.key;
        final amount = entry.value;
        final isEnough = amount > 0.01;

        return Card(
          child: ListTile(
            title: Text("${GameAsset.FruitEmoji} ${type.label}"),
            subtitle: Text( !isEnough ? "Pas de stock" : "${amount.toStringAsFixed(2)} kg disponible"),
            onTap: () async {
              if (isEnough) {
                final toDry = await showDryingModal(context: context, type: type, availableAmount: amount);
                if (toDry != null) {
                  await GameController().dryFruit(context: context, type: type, amount: toDry);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Séchage effectué")),
                  );
                }
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
