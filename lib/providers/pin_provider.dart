import 'package:flutter/material.dart';
import '../data/storage/storage_service.dart';

class PinProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  bool _hasPin = false;
  bool get hasPin => _hasPin;

  /// ✅ Verificar se já existe PIN
  Future<void> loadPinStatus() async {
    _hasPin = await _storage.hasPin();
    notifyListeners();
  }

  /// ✅ Salvar PIN
  Future<void> setPin(String pin) async {
    await _storage.savePin(pin);
    _hasPin = true;
    notifyListeners();
  }

  /// ✅ Validar PIN
  Future<bool> validatePin(String pin) async {
    return await _storage.validatePin(pin);
  }
}
