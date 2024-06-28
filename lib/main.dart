import 'package:flutter/material.dart';
import 'package:game_tracker/pages/Registration_page/RegistrationPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      home:  RegistrationPage()
    );
  }
}
