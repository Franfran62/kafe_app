import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/providers/stock_provider.dart';
import 'package:provider/provider.dart';

class CurrencyBar extends StatelessWidget {
  const CurrencyBar({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>().stock;
    if (stock == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.brown.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CurrencyItem(icon: GameAsset.deeveeEmoji, label: "DeeVee", amount: stock.deevee),
          const SizedBox(width: 24),
          _CurrencyItem(icon: GameAsset.goldGrainEmoji, label: "Or", amount: stock.goldGrains),
        ],
      ),
    );
  }
}

class _CurrencyItem extends StatelessWidget {
  final String icon;
  final String label;
  final int amount;

  const _CurrencyItem({
    required this.icon,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 6),
        Text("$amount $label", style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
