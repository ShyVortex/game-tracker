import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/registration/login/login_page.dart';
import 'package:game_tracker/theme/app_theme.dart';


final playerProvider = StateProvider<Player>((ref) => Player());
void main() {
  runApp(
    const ProviderScope(child: MyApp()) );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Game Tracker';
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildThemeData(),
      home: const LoginPage(),
      title: appTitle
    );
  }
}