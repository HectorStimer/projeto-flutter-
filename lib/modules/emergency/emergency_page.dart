import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_routes.dart';
import '../../providers/medical_provider.dart';
import 'qr_code_widget.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final medicalInfo = context.watch<MedicalProvider>().medicalInfo;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Emergência'),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.form);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () {
                if (medicalInfo != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QrCodeWidget()),
                  );
                }
              },
            ),
          ],
        ),
        body: medicalInfo == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 80,
                      color: AppColors.warning,
                    ),
                    const SizedBox(height: 16),
                    Text('Dados não configurados', style: AppTextStyles.title),
                    const SizedBox(height: 8),
                    Text(
                      'Preencha seus dados médicos para usar a emergência',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.form);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Configurar Dados'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  /// dados médicos resumidos
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Seus Dados Médicos',
                            style: AppTextStyles.title,
                          ),
                          const SizedBox(height: 16),

                          /// card com dados
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildInfoRow('Nome', medicalInfo.name),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Idade',
                                  '${medicalInfo.age} anos',
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Tipo Sanguíneo',
                                  medicalInfo.bloodType,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Alergias',
                                  medicalInfo.allergies,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Medicações',
                                  medicalInfo.medications,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Doenças Crônicas',
                                  medicalInfo.chronicDiseases,
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Contato Emergência',
                                  medicalInfo.emergencyContact,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Botão SOS GRANDE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        _showEmergencyOptions(context, medicalInfo);
                      },
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.emergency,
                              size: 50,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'PRESSIONAR SOS',
                              style: AppTextStyles.buttonText.copyWith(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.subtitle),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showEmergencyOptions(BuildContext context, dynamic medicalInfo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('O que deseja fazer?', style: AppTextStyles.title),
                const SizedBox(height: 20),
                _buildEmergencyOption(
                  icon: Icons.phone,
                  label: 'Chamar Emergência',
                  description: 'Ligar para 192',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildEmergencyOption(
                  icon: Icons.share,
                  label: 'Compartilhar Dados',
                  description: 'Enviar via WhatsApp/SMS',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildEmergencyOption(
                  icon: Icons.content_copy,
                  label: 'Copiar Dados',
                  description: 'Copiar para clipboard',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                _buildEmergencyOption(
                  icon: Icons.close,
                  label: 'Cancelar',
                  description: '',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmergencyOption({
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.subtitle),
                if (description.isNotEmpty)
                  Text(description, style: AppTextStyles.caption),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary.withValues(alpha: 0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
