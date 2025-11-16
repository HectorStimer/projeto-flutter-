import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/pin_provider.dart';
import '../widgets/pin_keypad.dart';
import '../../../core/app_routes.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';

class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  String firstPin = "";
  String confirmPin = "";
  bool isConfirming = false;
  String? errorMessage;

  void _updatePin(String number) {
    setState(() {
      if (!isConfirming) {
        if (firstPin.length < 4) {
          firstPin += number;
          if (firstPin.length == 4) {
            isConfirming = true;
            errorMessage = null;
          }
        }
      } else {
        if (confirmPin.length < 4) {
          confirmPin += number;
          if (confirmPin.length == 4) {
            _validatePin();
          }
        }
      }
    });
  }

  void _removePin() {
    setState(() {
      if (isConfirming && confirmPin.isNotEmpty) {
        confirmPin = confirmPin.substring(0, confirmPin.length - 1);
        errorMessage = null;
      } else if (!isConfirming && firstPin.isNotEmpty) {
        firstPin = firstPin.substring(0, firstPin.length - 1);
        errorMessage = null;
      }
    });
  }

  void _validatePin() async {
    if (firstPin == confirmPin) {
      final pinProvider = Provider.of<PinProvider>(context, listen: false);
      await pinProvider.setPin(firstPin);

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.emergency);
    } else {
      setState(() {
        errorMessage = "Os PINs não coincidem! Tente novamente.";
        firstPin = "";
        confirmPin = "";
        isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPin = isConfirming ? confirmPin : firstPin;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                /// logo
                Icon(Icons.security, size: 80, color: AppColors.primary),
                const SizedBox(height: 24),

                /// titulo
                Text(
                  !isConfirming ? "Crie um PIN" : "Confirme o PIN",
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                /// descrição
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    !isConfirming
                        ? "Digite 4 dígitos para proteger suas informações"
                        : "Digite novamente para confirmar",
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),

                /// pontinhos do PIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final filled = i < currentPin.length;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: filled ? AppColors.primary : AppColors.surface,
                        border: Border.all(
                          color: filled
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    );
                  }),
                ),

                /// mensagem de erro
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.2),
                        border: Border.all(color: AppColors.error),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorMessage!,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                const SizedBox(height: 48),

                /// teclado numerico
                PinKeypad(onNumberSelected: _updatePin, onDelete: _removePin),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
