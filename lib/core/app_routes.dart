import 'package:flutter/material.dart';

class AppRoutes {
  static const initial = '/';

  static Map<String, WidgetBuilder> routes = {
    '/': (_) => const Placeholder(), // 🔹 depois vira tela de onboarding/pin
  };
}
