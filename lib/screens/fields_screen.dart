import 'package:flutter/material.dart';
import 'package:kafe_app/styles/game_asset.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

@override
  Widget build(BuildContext context) {
    final fields = [
      {'id': 1, 'specialty': 'Temps / 2', 'active': 2},
      {'id': 2, 'specialty': 'Rendement x2', 'active': 4},
      {'id': 3, 'specialty': 'Temps / 2', 'active': 1},
    ];

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( "${GameAsset.fieldEmoji} Champs possédés :", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...fields.map((field) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: ListTile(
                onTap: () {
                  // Naviguer vers l’écran de gestion d’un champ
                },
                title: Text("Champs #${field['id']}"),
                subtitle: Text("${field['active']}/4 actifs"),
                trailing: Text(field['specialty'] as String),
              ),
            )),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  //TODO: Acheter un champ 1( DeeVee)
                },
                icon: const Icon(Icons.add),
                label: const Text("Acheter (15 💎 DeeVee)"),
              ),
            ),
          ],
        ),
      );
  }
}
