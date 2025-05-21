import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: ToonaraApp()));
}

class ToonaraApp extends StatelessWidget {
  const ToonaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toonara – AI Comic Generator',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF7E57C2), // Purple
          secondary: const Color(0xFFFF7043), // Coral
          surface: const Color(0xFFFDFDFD),
        ),
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7E57C2),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFB39DDB), // Light purple
          secondary: const Color(0xFFFF8A65), // Light coral
          surface: const Color(0xFF121212),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      themeMode: ThemeMode.system, // Auto switch based on device
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
