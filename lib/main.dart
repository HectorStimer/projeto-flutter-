import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_colors.dart';
import 'core/app_routes.dart';
import 'providers/medical_provider.dart';
import 'providers/pin_provider.dart';
import 'modules/onboarding/onboarding_page.dart';
import 'modules/pin/pages/set_pin_page.dart';
import 'modules/pin/pages/check_pin_page.dart';
import 'modules/emergency/emergency_page.dart';
import 'modules/form/medical_form_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicalProvider()..loadInfo()),
        ChangeNotifierProvider(create: (_) => PinProvider()..loadPinStatus()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SOS Alergias',
        theme: AppTheme.theme,
        home: const _AppEntry(),
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  static Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case AppRoutes.setPin:
        return MaterialPageRoute(builder: (_) => const SetPinPage());
      case AppRoutes.checkPin:
        return MaterialPageRoute(builder: (_) => const CheckPinPage());
      case AppRoutes.emergency:
        return MaterialPageRoute(builder: (_) => const EmergencyPage());
      case AppRoutes.form:
        return MaterialPageRoute(builder: (_) => const MedicalFormPage());
      default:
        return null;
    }
  }
}

/// widget que decide qual tela mostrar (lógica de inicialização)
class _AppEntry extends StatelessWidget {
  const _AppEntry();

  @override
  Widget build(BuildContext context) {
    final hasPin = context.watch<PinProvider>().hasPin;
    final hasMedicalInfo = context.watch<MedicalProvider>().hasInfo;

    // primeira vez: onboarding
    if (!hasMedicalInfo) {
      return const OnboardingPage();
    }

    // se tem info mas sem PIN: criar PIN
    if (!hasPin) {
      return const SetPinPage();
    }

    // tem PIN: verificar antes de entrar
    return const CheckPinPage();
  }
}
