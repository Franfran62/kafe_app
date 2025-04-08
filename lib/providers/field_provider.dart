import 'package:flutter/material.dart';
import 'package:kafe_app/models/field.dart';
import 'package:kafe_app/services/field_service.dart';

class FieldProvider with ChangeNotifier {
  final FieldService _fieldService = FieldService();

  List<Field> _fields = [];
  List<Field> get fields => _fields;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadFields(String playerId) async {
    _isLoading = true;
    notifyListeners();

    _fields = await _fieldService.getFieldsByPlayer(playerId);

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _fields = [];
    notifyListeners();
  }
}
