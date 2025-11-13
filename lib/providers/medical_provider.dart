import 'package:flutter/material.dart';
import '../data/models/medical_info_model.dart';
import '../data/storage/storage_service.dart';

class MedicalProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  MedicalInfoModel? _info;
  MedicalInfoModel? get info => _info;
  MedicalInfoModel? get medicalInfo => _info;

  bool get hasInfo => _info != null;

  Future<void> loadInfo() async {
    _info = await _storage.loadMedicalInfo();
    notifyListeners();
  }

  Future<void> updateInfo(MedicalInfoModel info) async {
    _info = info;
    await _storage.saveMedicalInfo(info);
    notifyListeners();
  }

  Future<void> saveInfo(MedicalInfoModel info) async {
    _info = info;
    await _storage.saveMedicalInfo(info);
    notifyListeners();
  }
}
