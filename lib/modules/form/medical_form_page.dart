import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_routes.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../providers/medical_provider.dart';
import '../../data/models/medical_info_model.dart';

class MedicalFormPage extends StatefulWidget {
  const MedicalFormPage({super.key});

  @override
  State<MedicalFormPage> createState() => _MedicalFormPageState();
}

class _MedicalFormPageState extends State<MedicalFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bloodController;
  late TextEditingController _allergiesController;
  late TextEditingController _medicationsController;
  late TextEditingController _chronicController;
  late TextEditingController _emergencyContactController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MedicalProvider>(context, listen: false);
    final info = provider.info;

    _nameController = TextEditingController(text: info?.name ?? "");
    _ageController = TextEditingController(text: info?.age ?? "");
    _bloodController = TextEditingController(text: info?.bloodType ?? "");
    _allergiesController = TextEditingController(text: info?.allergies ?? "");
    _medicationsController = TextEditingController(
      text: info?.medications ?? "",
    );
    _chronicController = TextEditingController(
      text: info?.chronicDiseases ?? "",
    );
    _emergencyContactController = TextEditingController(
      text: info?.emergencyContact ?? "",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bloodController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _chronicController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicalProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Dados Médicos"),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  /// Informações sobre o formulário
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Seus dados são essenciais para emergências.',
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Nome
                  _buildFieldLabel('Nome Completo *'),
                  _buildTextField(
                    controller: _nameController,
                    icon: Icons.person,
                    hint: 'Ex: João Silva',
                  ),
                  const SizedBox(height: 16),

                  /// idade e tipo Sanguíneo (lado a lado)
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Idade *'),
                            _buildTextField(
                              controller: _ageController,
                              icon: Icons.cake,
                              hint: 'Ex: 30',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Tipo Sanguíneo *'),
                            _buildTextField(
                              controller: _bloodController,
                              icon: Icons.bloodtype,
                              hint: 'Ex: O+',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// Alergias
                  _buildFieldLabel('Alergias'),
                  _buildTextField(
                    controller: _allergiesController,
                    icon: Icons.warning,
                    hint: 'Ex: Penicilina, Amendoim',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  /// Medicações
                  _buildFieldLabel('Medicações em Uso'),
                  _buildTextField(
                    controller: _medicationsController,
                    icon: Icons.local_pharmacy,
                    hint: 'Ex: Dipirona, Metformina',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  /// Doenças Crônicas
                  _buildFieldLabel('Doenças Crônicas'),
                  _buildTextField(
                    controller: _chronicController,
                    icon: Icons.health_and_safety,
                    hint: 'Ex: Diabetes, Hipertensão',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  /// Contato de Emergência
                  _buildFieldLabel('Contato de Emergência *'),
                  _buildTextField(
                    controller: _emergencyContactController,
                    icon: Icons.phone,
                    hint: 'Ex: (11) 99999-9999',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),

                  /// Botão Salvar
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleSave,
                    icon: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(
                      _isLoading ? 'Salvando...' : 'Salvar Dados',
                      style: AppTextStyles.buttonText,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Botão Cancelar (se em edit)
                  if (provider.hasInfo)
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.emergency,
                        );
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: AppTextStyles.subtitle),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo é obrigatório';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(color: Colors.white30),
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
      ),
      style: AppTextStyles.body,
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newInfo = MedicalInfoModel(
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        bloodType: _bloodController.text.trim(),
        allergies: _allergiesController.text.trim(),
        medications: _medicationsController.text.trim(),
        chronicDiseases: _chronicController.text.trim(),
        emergencyContact: _emergencyContactController.text.trim(),
      );

      final provider = Provider.of<MedicalProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      await provider.saveInfo(newInfo);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Dados salvos com sucesso!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      // Pequeno delay para mostrar a mensagem
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      navigator.pushReplacementNamed(AppRoutes.emergency);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
