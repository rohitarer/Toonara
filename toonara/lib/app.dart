import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF7E57C2),
  scaffoldBackgroundColor: Color(0xFFFDFDFD),
  colorScheme: ColorScheme.light(
    primary: Color(0xFF7E57C2),
    secondary: Color(0xFFFF7043),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFFB39DDB),
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFFB39DDB),
    secondary: Color(0xFFFF8A65),
  ),
);
