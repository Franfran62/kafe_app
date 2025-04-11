import 'package:flutter/material.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/providers/field_provider.dart';
import 'package:kafe_app/widgets/slot_item.dart';
import 'package:provider/provider.dart';

class FieldDetailScreen extends StatelessWidget {
  final String fieldId;

  const FieldDetailScreen({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FieldProvider>();
    final field = provider.findFieldById(fieldId);
    if (field == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: Text("Gestion du champs"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text("Spécialité : ${field.specialty.label}",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              ...List.generate(field.slots.length, (i) {
                final slot = field.slots[i];
                return SlotItem(
                  index: i,
                  slot: slot,
                  field: field,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
