import 'package:flutter/material.dart';
import '../data/models/medical_info_model.dart';
import '../data/storage/storage_service.dart';

class MedicalProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  MedicalInfoModel? _info;
  MedicalInfoModel? get info => _info;

  bool get hasInfo => _info != null;

  /// ✅ Carregar dados do storage
  Future<void> loadInfo() async {
    _info = await _storage.loadMedicalInfo();
    notifyListeners();
  }

  /// ✅ Atualizar dados na memória + salvar
  Future<void> updateInfo(MedicalInfoModel info) async {
    _info = info;
    await _storage.saveMedicalInfo(info);
    notifyListeners();
  }
}
