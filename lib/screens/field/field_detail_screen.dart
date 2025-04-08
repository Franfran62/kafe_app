import 'package:flutter/material.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/widgets/slot_item.dart';

class FieldDetailScreen extends StatelessWidget {
  final Field field;

  const FieldDetailScreen({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: Text(field.name),
        actions: const [Icon(Icons.menu)], // TODO later
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text("Spécialité : ${field.specialty.label}", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ...List.generate(field.slots.length, (i) {
              final slot = field.slots[i];
              return SlotItem(
                index: i,
                slot: slot,
                specialty: field.specialty,
                fieldId: field.id,
              );
            }),
          ],
        ),
      ),
    );
  }
}
