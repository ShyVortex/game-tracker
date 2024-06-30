import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData buildThemeData() {
    return ThemeData(
        colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true,
        filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.purple),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white)
            )
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.purple),
          ),
        )
    );
  }
}