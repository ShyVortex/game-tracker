import 'package:flutter/material.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/utilities/reference_utilities.dart';

import '../../controller/playerService.dart';
import '../../models/gamePlayer.dart';
import '../../widgets/square_avatar.dart';

class SearchGamesPage extends StatefulWidget {
  const SearchGamesPage({super.key});

  @override
  State<SearchGamesPage> createState() => SearchGamesState();
}

class SearchGamesState extends State<SearchGamesPage> {
  final TextEditingController searchController = TextEditingController();
  final PlayerService playerService = PlayerService();

  List<GamePlayer> favoritesGame = [];
  List<GamePlayer> searchResults = [];
  bool isLoading = true;

  @override
  void initState()  {
    super.initState();
    playerService.getAllGiochiPreferiti(
        ReferenceUtilities.getActivePlayer().id!
    ).then((onValue){
      setState(() {
        favoritesGame = onValue;
        isLoading = false;
      });
    });
  }

  void navigateBack() {
    Navigator.pop(context);
  }

  Future<void> searchGame() async {
    setState(() {
      isLoading = true;
    });

    final searchResult = favoritesGame.where(
        (result) => result.game!.nome!.toLowerCase()
            .contains(searchController.text.toLowerCase())).toList(
    );

    setState(() {
      searchResults = searchResult;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(children: [
      Card.outlined(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.black.withOpacity(0.35),
            width: 2,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                BackButton(
                  onPressed: navigateBack,
                ),
                Expanded(
                    child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cerca gioco...',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                        ),
                        onSubmitted: (value) => searchGame()))
              ],
            )),
      ),
      const SizedBox(height: 5),
      if (isLoading) const CircularProgressIndicator(),
              if (searchResults.isEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: favoritesGame.length,
                    itemBuilder: (context, index) {
                      final item = favoritesGame[index];
                      return ListTile(
                        title: Text(item.game!.nome!, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        subtitle: Text(item.game!.sviluppatore!, style: const TextStyle(fontFamily: 'Inter')),
                        leading: SquareAvatar(
                          imageUrl: item.game!.immagineURL!,
                          size: 35,
                          isNetworkImage: item.game!.isNetworkImage!,
                          isTouchable: false
                        ),
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                      );
                    },
                  ),
                ),
              if (searchResults.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index];
                      return ListTile(
                        title: Text(result.game!.nome!, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        subtitle:  Text(result.game!.sviluppatore!, style: const TextStyle(fontFamily: 'Inter')),
                        leading: SquareAvatar(
                            imageUrl: result.game!.immagineURL!,
                            size: 35,
                            isNetworkImage: result.game!.isNetworkImage!,
                            isTouchable: false
                        ),
                        onTap: () {
                          Navigator.pop(context, result);
                        },
                      );
                    },
                  ),
                )
    ])));
  }
}
