import 'dart:convert';

class MedicalInfoModel {
  String nome;
  String alergias;
  String contatoEmergencia;
  String convenio;
  String observacoes;

  MedicalInfoModel({
    required this.nome,
    required this.alergias,
    required this.contatoEmergencia,
    required this.convenio,
    required this.observacoes,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'alergias': alergias,
      'contatoEmergencia': contatoEmergencia,
      'convenio': convenio,
      'observacoes': observacoes,
    };
  }

  factory MedicalInfoModel.fromMap(Map<String, dynamic> map) {
    return MedicalInfoModel(
      nome: map['nome'] ?? '',
      alergias: map['alergias'] ?? '',
      contatoEmergencia: map['contatoEmergencia'] ?? '',
      convenio: map['convenio'] ?? '',
      observacoes: map['observacoes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalInfoModel.fromJson(String source) =>
      MedicalInfoModel.fromMap(json.decode(source));
}
