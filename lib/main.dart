import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:neural_flow/core/constants/theme_controller.dart';
import 'package:neural_flow/core/constants/app_theme.dart';
import 'package:neural_flow/features/app_router.dart';

// Manual palette selection:
// 1 = Sky (azul moderno)
// 2 = Indigo OKLCH (tabla original)
const int kManualPalette = 2;

AppThemePalette _paletteFromManualValue(int value) {
  return value == 1 ? AppThemePalette.indigo : AppThemePalette.sky;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES');
  Intl.defaultLocale = 'es_ES';
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(
        initialThemeMode: ThemeMode.light,
        initialPalette: _paletteFromManualValue(kManualPalette),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'NeuralFlow',
      theme: AppTheme.lightThemeFor(themeController.palette),
      darkTheme: AppTheme.darkThemeFor(themeController.palette),
      themeMode: themeController.themeMode,
    );
  }
}
