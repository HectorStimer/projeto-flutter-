import 'dart:convert';

class MedicalInfoModel {
  final String name;
  final String age;
  final String bloodType;
  final String allergies;
  final String medications;
  final String chronicDiseases;
  final String emergencyContact;

  MedicalInfoModel({
    required this.name,
    required this.age,
    required this.bloodType,
    required this.allergies,
    required this.medications,
    required this.chronicDiseases,
    required this.emergencyContact,
  });

  /// Converter para JSON (String)
  String toJson() {
    final map = {
      'name': name,
      'age': age,
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
      'chronicDiseases': chronicDiseases,
      'emergencyContact': emergencyContact,
    };
    return jsonEncode(map);
  }

  /// Construir a partir de JSON (String ou Map)
  factory MedicalInfoModel.fromJson(dynamic json) {
    late Map<String, dynamic> map;

    if (json is String) {
      map = jsonDecode(json) as Map<String, dynamic>;
    } else if (json is Map<String, dynamic>) {
      map = json;
    } else {
      throw ArgumentError('json must be String or Map<String, dynamic>');
    }

    return MedicalInfoModel(
      name: map['name'] as String? ?? '',
      age: map['age'] as String? ?? '',
      bloodType: map['bloodType'] as String? ?? '',
      allergies: map['allergies'] as String? ?? '',
      medications: map['medications'] as String? ?? '',
      chronicDiseases: map['chronicDiseases'] as String? ?? '',
      emergencyContact: map['emergencyContact'] as String? ?? '',
    );
  }

  /// converter para Map (para facilitar acesso)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
      'chronicDiseases': chronicDiseases,
      'emergencyContact': emergencyContact,
    };
  }
}
