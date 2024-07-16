import 'dart:async';

import 'package:flutter/material.dart';
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

final themeControllerProvider = Provider<StreamController<bool>>((ref) {
  final controller = StreamController<bool>.broadcast(sync: true);
  ref.onDispose(() => controller.close());
  return controller;
});

final themeStreamProvider = StreamProvider<bool>((ref) {
  final controller = ref.watch(themeControllerProvider);
  return controller.stream;
});

String currentStreamValue = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );

  runApp(const ProviderScope(child: GameTracker()));
}

class GameTracker extends ConsumerStatefulWidget {
  const GameTracker({super.key});

  static String isLightOrDark(BuildContext context) {
    final state = GameTracker.of(context);
    return state != null ? currentStreamValue : "Light";
  }

  static GameTrackerState? of(BuildContext context) =>
      context.findAncestorStateOfType<GameTrackerState>();

  @override
  ConsumerState<GameTracker> createState() => GameTrackerState();
}

class GameTrackerState extends ConsumerState<GameTracker> {
  final PlayerService _playerService = PlayerService();

  ThemeMode getSystemTheme() {
    return ThemeMode.system;
  }

  Future<void> fetchTheme() async {
    final prefs = await SharedPreferences.getInstance();

    String? value = prefs.getString("theme");
    if (value != null) {
      setLightStream(value == "light" ? "Light" : "Dark");
    } else {
      const themeMode = ThemeMode.system;
      setLightStream(themeMode == ThemeMode.light ? "Light" : "Dark");
    }
  }

  @override
  void initState() {
    fetchTheme();
    super.initState();
  }

  Future<bool> getLightStream() async {
    return currentStreamValue == "Light" ? true : false;
  }

  void setLightStream(String theme) {
    final controller = ref.read(themeControllerProvider);
    if (theme == "Light") {
      controller.add(true);
      currentStreamValue = "Light";
    } else {
      controller.add(false);
      currentStreamValue = "Dark";
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeStream = ref.watch(themeStreamProvider);

    return themeStream.when(
      data: (isLightTheme) {
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('it', 'IT'),
          ],
          debugShowCheckedModeBanner: false,
          theme: isLightTheme ? ThemeData.light() : ThemeData.dark(),
          home: _buildHome(),
          title: 'Game Tracker',
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Errore: $error'),
    );
  }

  Widget _buildHome() {
    return Consumer(
      builder: (context, ref, child) {
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
      },
    );
  }

  Future<Widget> _loadSavedValue(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");

    if (email == null) {
      return const LoginPage();
    } else {
      final player = await _playerService.getPlayerByEmail(email);
      ref.read(playerProvider.notifier).state = player;
      return const NavigationPage();
    }
  }
}
