import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kafe_app/game/game_controller.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/models/player.dart';
import 'package:kafe_app/models/wrapper/slot.dart';
import 'package:kafe_app/providers/field_provider.dart';
import 'package:kafe_app/providers/player_provider.dart';
import 'package:kafe_app/screens/field/field_detail_screen.dart';
import 'package:kafe_app/services/field_service.dart';
import 'package:kafe_app/game/game_asset.dart';
import 'package:kafe_app/widgets/modals/harvest_modal.dart';
import 'package:kafe_app/widgets/modals/planting_modal.dart';
import 'package:provider/provider.dart';

class SlotItem extends StatefulWidget {
  final Slot slot;
  final int index;
  final Field field;

  const SlotItem({
    super.key,
    required this.slot,
    required this.index,
    required this.field,
  });

  @override
  State<SlotItem> createState() => _SlotItemState();
}

class _SlotItemState extends State<SlotItem> {
  late Timer _timer;
  final GameController _gameController = GameController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
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

    if (!widget.slot.isPlanted) return _buildEmptySlot();
    if (widget.slot.isReady(widget.field.specialty)) return _buildReadySlot();
    return _buildGrowingSlot();
  }

  Widget _buildEmptySlot() {
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        title: Text("Emplacement ${widget.index + 1}"),
        subtitle: const Text("${GameAsset.slotEmptyEmoji} Planter un fruit"),
        trailing: const Icon(Icons.add),
        onTap: () async {
          final type = await showPlantingModal(context);
          if (type != null) {
            _gameController.plantAndRefresh(
              context: context,
              field: widget.field,
              slotIndex: widget.index,
              kafeType: type,
            );
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
        title: Text("Emplacement ${widget.index + 1}"),
        subtitle: Text("${GameAsset.slotReadyEmoji} Récolter !", style: TextStyle(color: Colors.green)),
        trailing: Text(widget.slot.kafeType ?? ""),
        onTap: () async {
          final result = await _gameController.harvestAndRefresh(
            context: context, 
            field: widget.field, 
            slotIndex: widget.index
          );
          if (result != null) {
            await showHarvestResultDialog(context, result);
          }
        },
      ),
    );
  }

  Widget _buildGrowingSlot() {
    final remaining = widget.slot.timeRemaining(widget.field.specialty)!;
    final formatted = _formatDuration(remaining);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        title: Text("Emplacement ${widget.index + 1}"),
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
