import 'package:shared_preferences/shared_preferences.dart';
import '../models/medical_info_model.dart';

class StorageService {
  static const String _infoKey = 'medical_info';
  static const String _pinKey = 'user_pin';

  /// ✅ Salvar informações médicas
  Future<void> saveMedicalInfo(MedicalInfoModel info) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_infoKey, info.toJson());
  }

  /// ✅ Carregar informações médicas
  Future<MedicalInfoModel?> loadMedicalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_infoKey);

    if (jsonString == null) return null;

    return MedicalInfoModel.fromJson(jsonString);
  }

  /// ✅ Salvar PIN
  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  /// ✅ Verificar PIN
  Future<bool> validatePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(_pinKey);
    return savedPin == pin;
  }

  /// ✅ Verificar se já existe PIN salvo
  Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_pinKey);
  }
}
