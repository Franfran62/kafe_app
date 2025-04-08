import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kafe_app/models/enums/field_specialty.dart';
import 'package:kafe_app/models/slot.dart';

class SlotItem extends StatefulWidget {
  final Slot slot;
  final int index;
  final FieldSpecialty specialty;

  const SlotItem({
    super.key,
    required this.slot,
    required this.index,
    required this.specialty,
  });

  @override
  State<SlotItem> createState() => _SlotItemState();
}

class _SlotItemState extends State<SlotItem> {
  late Timer _timer;

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

    String title = "Slot ${widget.index + 1}";
    String subtitle;

    if (!slot.isPlanted) {
      subtitle = "Planter un fruit";
    } else if (slot.isReady(specialty)) {
      subtitle = "Récolter !";
    } else {
      final remaining = slot.timeRemaining(specialty);
      subtitle = "Temps restant : ${_formatDuration(remaining!)}";
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: slot.kafeType != null ? Text(slot.kafeType!) : null,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes == 0) return "$seconds sec";
    return "$minutes min${seconds > 0 ? " $seconds sec" : ""}";
  }
}
