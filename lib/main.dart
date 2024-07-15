import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/navigationBar/navigation_page.dart';
import 'package:game_tracker/pages/registration/login/login_page.dart';
import 'package:game_tracker/widgets/waiting_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


final playerProvider = StateProvider<Player>((ref) => Player());
StreamController<bool> isLightTheme = StreamController.broadcast(sync: true);
String currentStreamValue = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: SystemUiOverlay.values
  );

  runApp(const ProviderScope(child: GameTracker()));
}

class GameTracker extends StatefulWidget {
  static GameTrackerState? of(BuildContext context) =>
      context.findAncestorStateOfType<GameTrackerState>();

  const GameTracker({super.key});

  static String isLightOrDark() {
    return currentStreamValue;
  }

  @override
  State<GameTracker> createState() => GameTrackerState();
}

class GameTrackerState extends State<GameTracker> {
  final PlayerService _playerService = PlayerService();

  Brightness getSystemTheme() {
    Brightness brightness = SchedulerBinding.instance
        .platformDispatcher.platformBrightness;

    return brightness;
  }

  Future<void> fetchTheme() async {
    final prefs = await SharedPreferences.getInstance();

    String? value = prefs.getString("theme");

    if (value != null) {
      if (value == "light") {
        isLightTheme.add(true);
        currentStreamValue = "Light";
      } else {
        isLightTheme.add(false);
        currentStreamValue = "Dark";
      }

    } else {
      if (getSystemTheme() == Brightness.light) {
        currentStreamValue = "Light";
      } else {
        currentStreamValue = "Dark";
      }
    }
  }

  @override
  void initState() {
    fetchTheme();
    super.initState();
  }

  Future<bool> getLightStream() async {
    return isLightTheme.stream.first;
  }

  void setLightStream(String theme) {
    if (theme == "Light") {
      isLightTheme.add(true);
      currentStreamValue = "Light";
    } else {
      isLightTheme.add(false);
      currentStreamValue = "Dark";
    }
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Game Tracker';
    return StreamBuilder<bool>(
        initialData: true,
        stream: isLightTheme.stream,
      builder: (context, snapshot) {
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
            theme: snapshot.data! ? ThemeData.light() : ThemeData.dark(),
            home: Consumer(
                builder: (context, ref,child){
                  return FutureBuilder<Widget>(
                    future: _loadSavedValue(ref),
                    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const WaitingWidget();
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