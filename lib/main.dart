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
      title: 'Velan Mobile',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: .06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: .1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: .1),
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: .4),
          ),
        ),
      ),
    );
  }
}
