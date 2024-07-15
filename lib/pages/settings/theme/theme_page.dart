import 'package:flutter/material.dart';
import 'package:game_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/app_theme.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {
  ThemeData themeData = AppTheme.buildThemeData();

  Future<void> applyLightMode() async {
    if (GameTracker.isLightOrDark() != "Light") {
      final prefs = await SharedPreferences.getInstance();

      GameTracker.of(context)?.setLightStream("Light");
      prefs.setString("theme", "light");

      setState(() {});
    }
  }

  Future<void> applyDarkMode() async {
    if (GameTracker.isLightOrDark() != "Dark") {
      final prefs = await SharedPreferences.getInstance();

      GameTracker.of(context)?.setLightStream("Dark");
      prefs.setString("theme", "dark");

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 1),
        // +1 è lo spazio dedicato al Divider
        child: Column(
          children: [
            AppBar(
                title: const Text(
                  "Tema",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    fontFamily: 'Inter',
                  ),
                ),
                // Impedisce di cambiare colore quando il contenuto viene scrollato
                forceMaterialTransparency: true),
            Divider(
              height: 1,
              thickness: 1,
              color: themeData.dividerColor.withOpacity(0.35),
            ),
          ],
        ),
      ),
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 200,
                    child: Card.outlined(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: GameTracker.isLightOrDark() == "Light"
                        ? Colors.black.withOpacity(0.25)
                        : Colors.white.withOpacity(0.35),
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: applyLightMode,
                        splashColor: Colors.purple.withAlpha(0),
                        hoverColor: Colors.purple.withAlpha(0),
                        focusColor: Colors.purple.withAlpha(0),
                        highlightColor: Colors.purple.withAlpha(0),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.light_mode, size: 100),
                              SizedBox(height: 16),
                              Text("Chiaro", style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter'
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 63),
                  SizedBox(
                    width: 140,
                    height: 200,
                    child: Card.outlined(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: GameTracker.isLightOrDark() == "Light"
                              ? Colors.black.withOpacity(0.25)
                              : Colors.white.withOpacity(0.35),
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: applyDarkMode,
                        splashColor: Colors.purple.withAlpha(0),
                        hoverColor: Colors.purple.withAlpha(0),
                        focusColor: Colors.purple.withAlpha(0),
                        highlightColor: Colors.purple.withAlpha(0),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.dark_mode, size: 100),
                              SizedBox(height: 16),
                              Text("Scuro", style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter'
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    ));
  }
}
