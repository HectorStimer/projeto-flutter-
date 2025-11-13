import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/medical_provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final medicalInfo = context.watch<MedicalProvider>().medicalInfo;

    if (medicalInfo == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("QR Code"),
          backgroundColor: AppColors.primary,
          centerTitle: true,
        ),
        backgroundColor: AppColors.background,
        body: const Center(
          child: Text("Nenhuma informação médica salva para gerar o QR Code."),
        ),
      );
    }

    final qrData = jsonEncode({
      "name": medicalInfo.name,
      "age": medicalInfo.age,
      "bloodType": medicalInfo.bloodType,
      "allergies": medicalInfo.allergies,
      "medications": medicalInfo.medications,
      "chronicDiseases": medicalInfo.chronicDiseases,
      "emergencyContact": medicalInfo.emergencyContact,
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("QR Code de Emergência"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// Informação
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Código QR de Emergência',
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Compartilhe este QR Code com socorristas',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    /// QR Code
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: qrData,
                        size: 300,
                        backgroundColor: Colors.white,
                        dataModuleStyle: const QrDataModuleStyle(
                          color: Color(0xFFD32F2F),
                          dataModuleShape: QrDataModuleShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    /// Dados do QR
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dados no QR Code:',
                            style: AppTextStyles.subtitle,
                          ),
                          const SizedBox(height: 12),
                          _buildDataRow('Nome', medicalInfo.name),
                          _buildDataRow('Idade', '${medicalInfo.age} anos'),
                          _buildDataRow(
                            'Tipo Sanguíneo',
                            medicalInfo.bloodType,
                          ),
                          _buildDataRow('Alergias', medicalInfo.allergies),
                          _buildDataRow(
                            'Contato',
                            medicalInfo.emergencyContact,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Botões de ação
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Voltar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar compartilhamento
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(
            value,
            style: AppTextStyles.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
