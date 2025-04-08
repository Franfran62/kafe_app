import 'package:flutter/material.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/providers/field_provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/rules/game_config.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/styles/game_asset.dart';
import 'package:kafe_app/widgets/field_name_modal.dart';
import 'package:provider/provider.dart';

class FieldsScreen extends StatelessWidget {
  final FieldService _fieldService = FieldService();
  FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fieldProvider = context.watch<FieldProvider>();
    final player = context.watch<PlayerProvider>().player;

    if (fieldProvider.isLoading || player == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final fields = fieldProvider.fields;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${GameAsset.fieldEmoji} Champs possédés :",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...fields.map((field) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    title: Text(field.name),
                    subtitle: Text(
                        "${field.slots.where((s) => s.kafeType != null).length}/4 actifs"),
                    trailing: Text(field.specialty.label),
                  ),
                )),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: player.deevee >= GameConfig.fieldPurchaseCost
                    ? () async {
                        final name = await showFieldNameModal(context) ??
                            "Champ #${fields.length + 1}";
                        final success =
                            await FieldService().purchaseField(player, name);
                        if (success) {
                          await context
                              .read<FieldProvider>()
                              .reloadFields(player.uid);
                          await context
                              .read<PlayerProvider>()
                              .loadPlayer(player.uid);
                        }
                      }
                    : null,
                icon: const Icon(Icons.add),
                label: Text(
                    "Acheter (${GameConfig.fieldPurchaseCost} ${GameAsset.deeveeEmoji} DeeVee)"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
