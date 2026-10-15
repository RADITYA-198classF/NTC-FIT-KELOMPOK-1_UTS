import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';

class NtcFitApp extends StatelessWidget {
  const NtcFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NTC Fit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
