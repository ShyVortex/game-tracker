import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/main.dart';
import 'package:game_tracker/pages/favorite/favorite_page.dart';
import 'package:game_tracker/pages/library/library_page.dart';
import 'package:game_tracker/pages/profile/profile_page.dart';
import '../../theme/app_theme.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => NavigationState();
}

class NavigationState extends State<NavigationPage> {
  ThemeData themeData = AppTheme.buildThemeData();

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _navigationPages = [
    Consumer(builder: (context, ref, child) {
      return LibraryPage(player: ref.watch(playerProvider));
    }),
    Consumer(builder: (context, ref, child) {
      return FavoritePage(player: ref.watch(playerProvider));
    }),
    Consumer(builder: (context, ref, child) {
      return ProfilePage(player: ref.watch(playerProvider));
    }),
  ];
  int navigationIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      navigationIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: themeData.dividerColor.withOpacity(0.12),
              width: 2.0,
            ),
          ),
        ),
        child: Scaffold(
            body: _navigationPages[navigationIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_books), label: 'Libreria'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: 'Preferiti',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profilo',
                ),
              ],
              currentIndex: navigationIndex,
              unselectedItemColor: Colors.black,
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontFamily: 'Inter'),
              selectedItemColor: Colors.purple,
              selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontFamily: 'Inter'),
              onTap: onItemTapped,
            )));
  }
}
