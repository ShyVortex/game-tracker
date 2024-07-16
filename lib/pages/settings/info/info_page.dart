import 'package:flutter/material.dart';
import 'package:game_tracker/widgets/app_logo.dart';

import '../../../main.dart';
import '../../../theme/app_theme.dart';

class InfoPage extends StatelessWidget {
  InfoPage({super.key});

  final ThemeData themeData = AppTheme.buildThemeData();

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
                "Informazioni",
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
            child: SizedBox(
              width: 175,
              height: 200,
              child: Card.outlined(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: GameTracker.isLightOrDark(context) == "Light"
                        ? Colors.black.withOpacity(0.25)
                        : Colors.white.withOpacity(0.35),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppLogo(width: 100, height: 100),
                      SizedBox(height: 16),
                      Text("Versione app:", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter'
                      )),
                      SizedBox(height: 8),
                      Text("1.0-release", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter'
                      )),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
