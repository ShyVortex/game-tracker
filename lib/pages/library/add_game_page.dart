import 'package:flutter/material.dart';
import 'package:game_tracker/widgets/date_picker_field.dart';
import 'package:game_tracker/widgets/location_field.dart';
import '../../theme/app_theme.dart';

class AddGamePage extends StatefulWidget {
  const AddGamePage({super.key});

  @override
  State<AddGamePage> createState() => AddGamePageState();
}

class AddGamePageState extends State<AddGamePage> {
  ThemeData themeData = AppTheme.buildThemeData();
  static const List<String> list = <String>[
    '0/10', '1/10', '2/10', '3/10', '4/10', '5/10', '6/10', '7/10', '8/10',
    '9/10', '10/10'
  ];
  String dropdownValue = "";

  void navigateBack() {
    Navigator.pop(context);
  }

  void onAddImage() {

  }

  void onConfirmPress() {

  }

  void onAddPlace() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 1), // +1 è lo spazio dedicato al Divider
          child: Column(
            children: [
              AppBar(
                title: const Text(
                  "Aggiunta gioco",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    fontFamily: 'Inter',
                  ),
                ),
                // Impedisce di cambiare colore quando il contenuto viene scrollato
                forceMaterialTransparency: true
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: themeData.dividerColor.withOpacity(0.35),
              ),
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                          children: [
                            Card.outlined(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.black.withOpacity(0.25),
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.purple.withAlpha(30),
                                  onTap: onAddImage,
                                  child: const Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 16, left: 20, right: 20),
                                        child: Column(
                                          children: [
                                            Text("+",
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Inter')),
                                            Text("Aggiungi\nimmagine",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Inter'))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            const SizedBox(width: 24),
                            const SizedBox(
                                width: 170,
                                child: TextField(
                                    decoration: InputDecoration(
                                        border:  OutlineInputBorder(),
                                        labelText: "Nome",
                                        labelStyle: TextStyle(fontFamily: 'Inter')
                                    )
                                )
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Sviluppatore",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Piattaforma",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Ore di gioco",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Trofei ottenuti",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text("Highlights", style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter'
                                )),
                                Card.outlined(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Colors.black.withOpacity(0.25),
                                      width: 2,
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    splashColor: Colors.purple.withAlpha(30),
                                    onTap: onAddImage,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 12, left: 12, right: 12),
                                      child: Text("+",
                                          style: TextStyle(
                                              fontSize: 72,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Inter')),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const DatePickerField(),
                        const SizedBox(height: 24),
                        const LocationField(),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(left: 9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Text("Valutazione", style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter'
                                  )),
                                  DropdownMenu<String>(
                                    initialSelection: "",
                                    onSelected: (String? value) {
                                      setState(() {
                                        dropdownValue = value!;
                                      });
                                    },
                                    dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                                      return DropdownMenuEntry<String>(value: value, label: value);
                                    }).toList(),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                    const SizedBox(height: 84)
                          ],
                        )
                  )
                ))
            ]
        )
    ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.green,
          onPressed: onConfirmPress,
          child: const Icon(Icons.check, color: Colors.white, size: 30),
        ),
    );
  }
}