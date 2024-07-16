import 'package:flutter/material.dart';
import 'package:game_tracker/main.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

import '../../theme/app_theme.dart';

class SearchPlacePage extends StatefulWidget {
  const SearchPlacePage({super.key});

  @override
  State<SearchPlacePage> createState() => SearchPlaceState();
}

class SearchPlaceState extends State<SearchPlacePage> {
  final ThemeData themeData = AppTheme.buildThemeData();
  final TextEditingController searchController = TextEditingController();
  List<Place> searchResults = [];
  bool isLoading = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void navigateBack() {
    Navigator.pop(context);
  }

  Future<void> searchLocation() async {
    setState(() {
      isLoading = true;
    });

    final searchResult = await Nominatim.searchByName(
      query: searchController.text,
      limit: 10,
      addressDetails: false,
      extraTags: true,
      nameDetails: true,
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
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
                Card.outlined(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Colors.black.withOpacity(0.35),
                      width: 2,
                    ),
                  ),
                  color: GameTracker.isLightOrDark(context) == "Light"
                      ? themeData.textTheme.bodyLarge?.backgroundColor
                      : Colors.grey[300],
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          BackButton(
                            color: Colors.black,
                            onPressed: navigateBack,
                          ),
                          Expanded(
                              child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Cerca luogo...',
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter',
                                        color: Colors.black
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                                  ),
                                  onSubmitted: (value) => searchLocation(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                    color: Colors.black
                                ),
                              )
                          )
                        ],
                      )
                  ),
                ),
                if (isLoading) const CircularProgressIndicator(),
                if (searchResults.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final result = searchResults[index];
                        return ListTile(
                          title: Text(result.displayName),
                          onTap: () {
                            Navigator.pop(context, result);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        )
    );
  }

}