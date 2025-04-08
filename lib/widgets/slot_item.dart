import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/models/slot.dart';
import 'package:kafe_app/providers/field_provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/screens/field/field_detail_screen.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/widgets/planting_modal.dart';
import 'package:provider/provider.dart';

class SlotItem extends StatefulWidget {
  final Slot slot;
  final int index;
  final FieldSpecialty specialty;
  final String fieldId;

  const SlotItem({
    super.key,
    required this.slot,
    required this.index,
    required this.specialty,
    required this.fieldId,
  });

  @override
  State<SlotItem> createState() => _SlotItemState();
}

class _SlotItemState extends State<SlotItem> {
  late Timer _timer;
  final FieldService _fieldService = FieldService();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.slot;
    final specialty = widget.specialty;

    if (!slot.isPlanted) return _buildEmptySlot();
    if (slot.isReady(specialty)) return _buildReadySlot();
    return _buildGrowingSlot();
  }

  Widget _buildEmptySlot() {
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        title: Text("Slot ${widget.index + 1}"),
        subtitle: const Text("${GameAsset.slotEmptyEmoji} Planter un fruit"),
        trailing: const Icon(Icons.add),
        onTap: () async {
          final type = await showPlantingModal(context);
          if (type != null) {
            final field = context.findAncestorWidgetOfExactType<FieldDetailScreen>()!.field;
            final player = context.read<PlayerProvider>().player!;
            
            await _fieldService.plantKafe(
              player: player,
              fieldId: field.id,
              slotIndex: widget.index,
              kafeType: type,
            );
            await context.read<FieldProvider>().reloadFields(player.uid);
            await context.read<PlayerProvider>().loadPlayer(player.uid);
          }   
        }
      ),
    );
  }

  Widget _buildReadySlot() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        title: Text("Slot ${widget.index + 1}"),
        subtitle: Text("${GameAsset.slotReadyEmoji} Récolter !"),
        trailing: Text(widget.slot.kafeType ?? ""),
        onTap: () {
          // TODO: FieldService.harvest(widget.slot)
        },
      ),
    );
  }

  Widget _buildGrowingSlot() {
    final remaining = widget.slot.timeRemaining(widget.specialty)!;
    final formatted = _formatDuration(remaining);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        title: Text("Slot ${widget.index + 1}"),
        subtitle: Text("${GameAsset.slotPlantEmoji} Temps restant : $formatted"),
        trailing: Text(widget.slot.kafeType ?? ""),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return minutes == 0 ? "$seconds sec" : "$minutes min${seconds > 0 ? " $seconds sec" : ""}";
  }
}
