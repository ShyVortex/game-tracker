import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/controller/gamePlayerService.dart';
import 'package:game_tracker/main.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/pages/navigationBar/navigation_page.dart';
import 'package:game_tracker/utilities/login_utilities.dart';
import 'package:game_tracker/widgets/date_picker_field.dart';
import 'package:game_tracker/widgets/images_list.dart';
import 'package:game_tracker/widgets/location_field.dart';
import 'package:game_tracker/widgets/square_avatar.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';

class AddGamePage extends StatefulWidget {
  const AddGamePage({super.key});

  @override
  State<AddGamePage> createState() => AddGamePageState();
}

class AddGamePageState extends State<AddGamePage> {
  ThemeData themeData = AppTheme.buildThemeData();

  static const List<String> platformList = <String>['PC', 'Steam Deck', 'PS5',
    'Xbox Series S/X', 'Nintendo Switch', 'PS4', 'PS Vita', 'Xbox One', 'PS3',
    'PSP', 'Xbox 360', 'Nintendo Wii U', 'Nintendo 3DS', 'Nintendo Wii', 'PS2',
    'Xbox', 'Nintendo DS', 'Nintendo GameCube', 'Nintendo GBA', 'Retro console'
  ];
  static const List<String> scoreList = <String>[
    '0/10', '1/10', '2/10', '3/10', '4/10', '5/10', '6/10', '7/10', '8/10',
    '9/10', '10/10'
  ];
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sviluppatoreController = TextEditingController();
  final TextEditingController _oreDiGiocoController = TextEditingController();
  final TextEditingController _trofeiOttenutiController = TextEditingController();
  final TextEditingController _trofeiTotaliController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _piattaformaController = TextEditingController();
  final TextEditingController _valutazioneController = TextEditingController();


  final _nomeFormKey = GlobalKey<FormFieldState>();
  final _sviluppatoreFormKey = GlobalKey<FormFieldState>();
  final _trofeiTotaliFormKey = GlobalKey<FormFieldState>();
  final _trofeiOttenutiFormKey = GlobalKey<FormFieldState>();

  Game gameToInsert = Game();
  GamePlayer gamePlayerToInsert = GamePlayer();

  final GamePlayerservice _gamePlayerservice = GamePlayerservice();

  bool isLoadedImage = false;

  String dropdownValue = "";

  void navigateBack() {
    Navigator.pop(context);
  }

  Future<void> onAddImage() async {
    gameToInsert.immagineURL = await _pickImageFromGallery();
    if(gameToInsert.immagineURL != ""){
      setState(() {
        isLoadedImage = true;
        gameToInsert.isNetworkImage = false;
      });
    }
  }
  Future<void> onAddHighlightsImage() async {
    String? imageToInsert = await _pickImageFromGallery();
    if(imageToInsert != "") {
      gamePlayerToInsert.immagini!.add(imageToInsert);
      setState(() {

      });
    }
    else {

    }
  }


  Future<void> onConfirmPress(int idPlayer) async {

    if(_nomeFormKey.currentState!.validate() && _sviluppatoreFormKey.currentState!.validate() && _trofeiTotaliFormKey.currentState!.validate() && _trofeiOttenutiFormKey.currentState!.validate()){
       if(!isLoadedImage){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Inserire una immagine del gioco!'),
                ));
        return;
       }
      await _performInsert(idPlayer);
    }

  }

  Future<String> _pickImageFromGallery() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
     final File imagesPath = File(pickedFile.path);
     return imagesPath.path;
  }
  else {
      return "";
  }
}
void updateState(){
  setState(() {

  });
}
Future<void> _performInsert(int idPlayer) async {
      gameToInsert.nome = _nomeController.text;
      gameToInsert.sviluppatore = _sviluppatoreController.text;
      gameToInsert.trofeiTotali = int.parse(_trofeiTotaliController.text);
      gameToInsert.piattaforme!.add(_piattaformaController.text);
      if(_oreDiGiocoController.text != "") gamePlayerToInsert.oreDiGioco = int.parse(_oreDiGiocoController.text);
      if(_trofeiOttenutiController.text != "") gamePlayerToInsert.trofeiOttenuti = int.parse(_trofeiOttenutiController.text);
      if(_placeController.text != "") gamePlayerToInsert.luogoCompletamento = _placeController.text;
      gamePlayerToInsert.valutazione =  LoginUtilities.valutazioneIntValue(_valutazioneController.text);
      if(_dateController.text != "") gamePlayerToInsert.dataCompletamento = _dateController.text;




      await _gamePlayerservice.performGameInsert(gameToInsert, idPlayer, gamePlayerToInsert);

     Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>   const NavigationPage())
                    );


}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                                          !isLoadedImage?
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
                                              )
                                          )
                                              : SquareAvatar(imageUrl: gameToInsert.immagineURL!, size: 100, isNetworkImage: gameToInsert.isNetworkImage!,updateParentState: (String value){
                                            gameToInsert.immagineURL = value;
                                          }),

                                          const SizedBox(width: 24),
                                          SizedBox(
                                              width: 170,
                                              child: TextFormField(
                                                key: _nomeFormKey,
                                                decoration: const InputDecoration(
                                                    border:  OutlineInputBorder(),
                                                    labelText: "Nome",
                                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                                ),
                                                keyboardType: TextInputType.text,
                                                controller: _nomeController,
                                                validator: (value) {
                                                  if(value == null|| value == '') {
                                                    return "inserire il nome del gioco";
                                                  }
                                                  else {
                                                    return null;
                                                  }
                                                },
                                              )
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                            key: _sviluppatoreFormKey,
                                            validator: (value){
                                              if(value == null || value == ""){
                                                return "inserire uno sviluppatore";
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                border:  OutlineInputBorder(),
                                                labelText: "Sviluppatore",
                                                labelStyle: TextStyle(fontFamily: 'Inter')
                                            ),
                                            keyboardType: TextInputType.text,
                                            controller: _sviluppatoreController,
                                          )
                                      ),
                                      const SizedBox(height: 24),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 9),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text("Piattaforma", style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter'
                                                )),
                                                DropdownMenu<String>(
                                                  controller: _piattaformaController,
                                                  width: 300,
                                                  initialSelection: "PS5",
                                                  onSelected: (String? value) {
                                                    setState(() {
                                                      dropdownValue = value!;
                                                    });
                                                  },
                                                  dropdownMenuEntries: platformList.map<DropdownMenuEntry<String>>((String value) {
                                                    return DropdownMenuEntry<String>(value: value, label: value);
                                                  }).toList(),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                border:  OutlineInputBorder(),
                                                labelText: "Ore di gioco",
                                                labelStyle: TextStyle(fontFamily: 'Inter')
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _oreDiGiocoController,
                                          )
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                            key: _trofeiOttenutiFormKey,
                                            decoration: const InputDecoration(
                                              border:  OutlineInputBorder(),
                                              labelText: "Trofei ottenuti",
                                              labelStyle: TextStyle(fontFamily: 'Inter'),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _trofeiOttenutiController,
                                            validator: (value) {
                                              if(value!= ""){
                                                if(int.parse(value!)  > int.parse(_trofeiTotaliController.text)){
                                                  return "Trofei ottenuti maggiori dei totali";
                                                }
                                              }},
                                          )
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                          width: 300,
                                          child: TextFormField(
                                            key: _trofeiTotaliFormKey,
                                            validator: (value) {
                                              if(value == null || value == ""){
                                                return "inserire i trofei totali del gioco";
                                              }
                                              else {
                                                return null;
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              border:  OutlineInputBorder(),
                                              labelText: "Trofei totali",
                                              labelStyle: TextStyle(fontFamily: 'Inter'),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _trofeiTotaliController,
                                          )
                                      ),
                                      const SizedBox(height: 24),
                                      gamePlayerToInsert.immagini!.isEmpty ?
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
                                                  onTap: onAddHighlightsImage,
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
                                      ): ImagesList(imagesPaths:gamePlayerToInsert.immagini!,notifyParent:updateState),

                                      const SizedBox(height: 10),
                                      DatePickerField(
                                          dateController:_dateController,
                                          label: "Data di completamento"
                                      ),
                                      const SizedBox(height: 24),
                                      LocationField(placeController: _placeController,),
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
                                                  controller: _valutazioneController,
                                                  initialSelection: scoreList[0],
                                                  onSelected: (String? value) {
                                                    setState(() {
                                                      dropdownValue = value!;
                                                    });
                                                  },
                                                  dropdownMenuEntries: scoreList.map<DropdownMenuEntry<String>>((String value) {
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
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                  gamePlayerToInsert.immagini!.isNotEmpty ?
                  FloatingActionButton(
                    heroTag: "add_game_page_selection-photo",
                    shape: const CircleBorder(),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    onPressed:onAddHighlightsImage,
                    child: const Icon(Icons.photo_library, color: Colors.black, size: 30),
                  ): const SizedBox()
                  ,
                  const SizedBox(height: 10,),
                  Consumer(builder:
                      (context,ref,child){
                    return FloatingActionButton(
                      heroTag: "confirm_add_page",
                      shape: const CircleBorder(),
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        await onConfirmPress(ref.watch(playerProvider).id!);
                      } ,
                      child: const Icon(Icons.check, color: Colors.white, size: 30),
                    );
                  })



                ]
            )
        )
    );
  }
}