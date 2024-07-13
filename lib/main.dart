import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/navigationBar/navigation_page.dart';
import 'package:game_tracker/pages/registration/login/login_page.dart';
import 'package:game_tracker/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


final playerProvider = StateProvider<Player>((ref) => Player());

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: SystemUiOverlay.values
  );

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final PlayerService _playerService = PlayerService();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Game Tracker';
    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('it', 'IT')
        ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildThemeData(),
      home: Consumer(
          builder: (context, ref,child){
        return FutureBuilder<Widget>(
              future: _loadSavedValue(ref),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Errore: ${snapshot.error}');
                } else {
                  return snapshot.data!;
                }
              },
          );
  }),
       title: appTitle
    );
  }
  Future<Widget> _loadSavedValue(ref) async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString("email") == null){
      return const LoginPage();
    }
    else {
      Player player = await _playerService.getPlayerByEmail(prefs.getString("email")!);
      ref.read(playerProvider.notifier).state = player;
      return const NavigationPage();
    }
  }
}