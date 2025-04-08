import 'package:flutter/material.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/styles/game_asset.dart';
import 'package:provider/provider.dart';

class FieldsScreen extends StatelessWidget {
  final FieldService _fieldService = FieldService();

  FieldsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerId = context.watch<PlayerProvider>().player?.uid;

    if (playerId == null) {
      return const Center(child: Text("Aucun joueur connecté"));
    }

    return FutureBuilder<List<Field>>(
      future: _fieldService.getFieldsByPlayer(playerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erreur : ${snapshot.error}"));
        }

        final fields = snapshot.data ?? [];

        final player = context.watch<PlayerProvider>().player;
        final canBuyField = (player?.deevee ?? 0) >= 15;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${GameAsset.fieldEmoji} Champs possédés :", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              ...fields.map((field) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: ListTile(
                  onTap: () {
                    // TODO: Aller vers la page de gestion de champ
                  },
                  title: Text(field.name),
                  subtitle: Text("${field.slots.where((s) => s.kafeType != null).length}/4 actifs"),
                  trailing: Text(field.specialty.label),
                ),
              )),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: canBuyField ? () {
                    // TODO: Acheter un champ
                  } : null,
                  icon: const Icon(Icons.add),
                  label: Text("Acheter (15 ${GameAsset.deeveeEmoji} DeeVee)"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
