import 'package:flutter/material.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class SearchPlacePage extends StatefulWidget {
  const SearchPlacePage({super.key});

  @override
  State<SearchPlacePage> createState() => SearchPlaceState();
}

class SearchPlaceState extends State<SearchPlacePage> {
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
    return Scaffold(
      body: Column(
        children: [
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
                          hintText: 'Cerca luogo...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                        ),
                        onSubmitted: (value) => searchLocation()
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
    );
  }

}