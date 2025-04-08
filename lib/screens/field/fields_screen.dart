import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kafe_app/game/game_controller.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/providers/field_provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/game/game_config.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/widgets/field_name_modal.dart';
import 'package:provider/provider.dart';

class FieldsScreen extends StatefulWidget {
  @override
  _FieldsScreenState createState() => _FieldsScreenState();
}

class _FieldsScreenState extends State<FieldsScreen> {

  final GameController _gameController = GameController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    final player = Provider.of<PlayerProvider>(context, listen: false).player;
    if (player != null) {
      Provider.of<FieldProvider>(context, listen: false).loadFields(player.uid);
    }
  });
  }

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
            Text("Champs possédés :",
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...fields.map((field) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        'field_detail',
                        pathParameters: {'id': field.id}, 
                        extra: field, 
                      );
                    },
                    title: Text("${GameAsset.fieldEmoji}  ${field.name}"),
                    subtitle: Text(
                        "${field.slots.where((s) => s.kafeType != null).length}/${GameConfig.slotsPerField} actifs"),
                    trailing: Text(field.specialty.label),
                  ),
                )),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: player.deevee >= GameConfig.fieldPurchaseCost
                    ? () async {
                        final name = await showFieldNameModal(context);
                        if (name == null) return;
                        final success = await _gameController.purchaseField(context: context, fieldName: name);
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
