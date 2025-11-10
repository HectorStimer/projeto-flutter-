


class MedicalInfoModel {
  final String bloodType;
  final List<String> allergies;
  final List<String> medications;
  final String chronicConditions;

  MedicalInfoModel({
    required this.bloodType,
    required this.allergies,
    required this.medications,
    required this.chronicConditions,
  });

  factory MedicalInfoModel.fromJson(Map<String, dynamic> json) {
    return MedicalInfoModel(
      bloodType: json['bloodType'] as String,
      allergies: List<String>.from(json['allergies'] as List<dynamic>),
      medications: List<String>.from(json['medications'] as List<dynamic>),
      chronicConditions: json['chronicConditions'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
      'chronicConditions': chronicConditions,
    };
  }
}