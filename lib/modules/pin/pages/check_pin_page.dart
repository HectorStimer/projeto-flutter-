import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/pin_provider.dart';
import '../widgets/pin_keypad.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../core/app_routes.dart';

class CheckPinPage extends StatefulWidget {
  const CheckPinPage({super.key});

  @override
  State<CheckPinPage> createState() => _CheckPinPageState();
}

class _CheckPinPageState extends State<CheckPinPage> {
  String enteredPin = "";
  String? errorMessage;
  int _attemptCount = 0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PinProvider>(context, listen: false);

    provider.loadPinStatus().then((_) {
      if (!mounted) return;
      if (!provider.hasPin) {
        Navigator.pushReplacementNamed(context, AppRoutes.setPin);
      }
    });
  }

  void _updatePin(String number) {
    setState(() {
      if (enteredPin.length < 4) {
        enteredPin += number;
        if (enteredPin.length == 4) {
          _validatePin();
        }
      }
    });
  }

  void _removePin() {
    setState(() {
      if (enteredPin.isNotEmpty) {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        errorMessage = null;
      }
    });
  }

  Future<void> _validatePin() async {
    final pinProvider = Provider.of<PinProvider>(context, listen: false);
    final isValid = await pinProvider.validatePin(enteredPin);

    if (!mounted) return;

    if (isValid) {
      Navigator.pushReplacementNamed(context, AppRoutes.emergency);
    } else {
      _attemptCount++;
      setState(() {
        errorMessage = _attemptCount >= 3
            ? "Muitas tentativas. Tente novamente mais tarde."
            : "PIN incorreto! Tente novamente. (${3 - _attemptCount} tentativas restantes)";
        enteredPin = "";
      });

      if (_attemptCount >= 3) {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() {
            _attemptCount = 0;
            errorMessage = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.lock, size: 80, color: AppColors.primary),
                const SizedBox(height: 24),

                /// título
                Text(
                  "Digite seu PIN",
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                /// descrição
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Digite seu PIN de 4 dígitos para acessar o app",
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),

                /// pontinhos do PIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final filled = i < enteredPin.length;
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
