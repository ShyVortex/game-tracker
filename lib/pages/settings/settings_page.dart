import 'package:flutter/material.dart';
import 'package:game_tracker/main.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/registration/login/login_page.dart';
import 'package:game_tracker/pages/settings/theme/theme_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  final Player player;

  const SettingsPage({super.key, required this.player});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  ThemeData themeData = AppTheme.buildThemeData();

  void routeToTheme() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ThemePage())
    );
  }

  void routeToInfo() {

  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("email");
    prefs.remove("password");

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LoginPage())
    );
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
                  "Impostazioni",
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
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: 50,
                  child: Card.outlined(
                    shape: const RoundedRectangleBorder(),
                    child: InkWell(
                      onTap: routeToTheme,
                      splashColor: Colors.purple.withAlpha(0),
                      hoverColor: Colors.purple.withAlpha(0),
                      focusColor: Colors.purple.withAlpha(0),
                      highlightColor: Colors.purple.withAlpha(0),
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.color_lens,
                                    color:
                                        GameTracker.isLightOrDark(context) == "Light"
                                            ? Colors.black
                                            : Colors.white,
                                    size: 25
                              ),
                                const SizedBox(width: 16),
                              const Text("Tema", style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter'
                              )),
                            ],
                          )
                        )
                      ),
                    ),
                  )
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: themeData.dividerColor.withOpacity(0.5),
                ),
                SizedBox(
                    height: 50,
                    child: Card.outlined(
                      shape: const RoundedRectangleBorder(),
                      child: InkWell(
                        onTap: routeToInfo,
                        splashColor: Colors.purple.withAlpha(0),
                        hoverColor: Colors.purple.withAlpha(0),
                        focusColor: Colors.purple.withAlpha(0),
                        highlightColor: Colors.purple.withAlpha(0),
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info,
                                        color:
                                        GameTracker.isLightOrDark(context) == "Light"
                                            ? Colors.black
                                            : Colors.white,
                                        size: 25
                                    ),
                                    const SizedBox(width: 16),
                                    const Text("Informazioni", style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter'
                                    )),
                                  ],
                                )
                            )
                        ),
                      ),
                    )
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: themeData.dividerColor.withOpacity(0.5),
                ),
                SizedBox(
                    height: 50,
                    child: Card.outlined(
                      shape: const RoundedRectangleBorder(),
                      child: InkWell(
                        onTap: logout,
                        splashColor: Colors.purple.withAlpha(0),
                        hoverColor: Colors.purple.withAlpha(0),
                        focusColor: Colors.purple.withAlpha(0),
                        highlightColor: Colors.purple.withAlpha(0),
                        child: Center(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.logout,
                                        color:
                                        GameTracker.isLightOrDark(context) == "Light"
                                            ? Colors.black
                                            : Colors.white,
                                        size: 25
                                    ),
                                    const SizedBox(width: 16),
                                    const Text("Logout", style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter'
                                    )),
                                  ],
                                )
                            )
                        ),
                      ),
                    )
                ),
            Divider(
              height: 1,
              thickness: 1,
              color: themeData.dividerColor.withOpacity(0.5),
            ),
              ],
            ),
          ),
    );
  }
}
