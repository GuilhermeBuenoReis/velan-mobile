import 'package:flutter/material.dart';
import 'package:velan_mobile/app_routes.dart';

void main() {
  runApp(const VelanApp());
}

class VelanApp extends StatelessWidget {
  const VelanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velan',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B10),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B5FD1),
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    );
  }
}
