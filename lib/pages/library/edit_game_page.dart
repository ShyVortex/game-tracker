import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/pages/library/map_page.dart';
import 'package:game_tracker/theme/app_theme.dart';
import 'package:game_tracker/widgets/images_list.dart';
import 'package:game_tracker/widgets/square_avatar.dart';
import 'package:image_picker/image_picker.dart';

class EditGamePage extends StatefulWidget {
  const EditGamePage({super.key, required this.gameplayer});
  final Gameplayer gameplayer;

  @override
  State<EditGamePage> createState() => _EditGamePageState();
}

class _EditGamePageState extends State<EditGamePage> {
  ThemeData themeData = AppTheme.buildThemeData();
  static const List<String> scoreList = <String>[
    '0/10', '1/10', '2/10', '3/10', '4/10', '5/10', '6/10', '7/10', '8/10',
    '9/10', '10/10'
  ];
  String dropdownValue = "";
  bool enableOreDiGiocoFormField = true;
  bool enableTrofeiOttenutiFormField = true;
  final TextEditingController placeController = TextEditingController();
  final TextEditingController _trofeiController = TextEditingController();
  final TextEditingController _oreDiGiocoController = TextEditingController();
  void onConfirmPress() {
  }
  Future<void> onButtonPress() async {
    String location = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MapPage())
    );

    setState(() {
      placeController.text = location;
    });
  }
   void onAddImage() {
  }

  void onSelectionPress() async{
    await _pickImageFromGallery();
    setState(() {
      
    });
  }

  void onDeletePress() {
  }

  Future<void> _pickImageFromGallery() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
     final File imagesPath = File(pickedFile.path); 
     widget.gameplayer.immagini?.add(imagesPath.path);
  } 
  else {

  }
}

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
            kToolbarHeight + 1), // +1 è lo spazio dedicato al Divider
        child: Column(
          children: [
            AppBar(
                title: const Text(
                  "Dettagli gioco",
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
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15, top: 30, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SquareAvatar(
                          imageUrl: widget.gameplayer.game!.immagineURL!,
                          size: 70,
                          isNetworkImage: widget.gameplayer.game!.isNetworkImage!,),
                      const SizedBox(
                        width: 40,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.gameplayer.game!.nome!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Inter',
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            Text(widget.gameplayer.game!.sviluppatore!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    fontFamily: 'Inter',
                                    color: Color.fromARGB(136, 105, 105, 105))),
                          ]),
                    ],
                  )
                  ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: 300,
                  child: 
                  Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const Text(
                         "Ore di gioco",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter')),
                      TextFormField(

                    decoration: InputDecoration(
                        hintText: widget.gameplayer.oreDiGioco!.toString(),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit), // Icona di modifica
                          onPressed: () {
                            setState(() {
                              enableOreDiGiocoFormField = !enableOreDiGiocoFormField;
                            });
                          },
                        )),
                    keyboardType: TextInputType.number,
                    controller: _oreDiGiocoController,
                    readOnly: enableOreDiGiocoFormField,
                  )
                  ]
                  )
                  ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Valutazione",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter')),
                      DropdownMenu<String>(
                        hintText: "${widget.gameplayer.valutazione!}/10",
                        width: 300,
                        onSelected: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        dropdownMenuEntries: scoreList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      )
                    ],
                  ),
                ],
              ),
               const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: 300,
                  child: 
                  Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const Text(
                         "Trofei Ottenuti",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter')),
                      TextFormField(
                    controller: _trofeiController,
                    decoration: InputDecoration(
                        hintText: "${widget.gameplayer.trofeiOttenuti!}/${widget.gameplayer.game!.trofeiTotali}",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit), 
                          onPressed: () {
                            setState(() {
                              enableTrofeiOttenutiFormField = !enableTrofeiOttenutiFormField;
                            });
                          },
                        )),
                    keyboardType: TextInputType.number,

                    readOnly: enableTrofeiOttenutiFormField,
                  )
                  ]
                  )
                  ),
                  const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: 300,
                  child: 
                  Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const Text(
                         "Luogo completamento",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter')),
                      TextFormField(
                    
                    controller: placeController,
                    decoration: InputDecoration(
                        hintText: "Roma",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.location_on), 
                          onPressed: () {
                            onButtonPress();
                          },
                        )),
                    
                    readOnly: true
                  )
                  ]
                  )
                  ),
             const SizedBox(
                height: 30,
             ),
            widget.gameplayer.immagini!.isNotEmpty ? 
       ImagesList(imagesPaths:widget.gameplayer.immagini!)
      : Column(
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
        ]          
          )],
          )
          
          ),
          floatingActionButton: 
          Column(  
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          FloatingActionButton(
          heroTag: "selection-photo",
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          onPressed:  onSelectionPress,
          child: const Icon(Icons.photo_library, color: Colors.black, size: 30),
        ), const SizedBox(height: 10,) ,
          FloatingActionButton(
          heroTag: "cancella",
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 223, 11, 11),
          onPressed: onDeletePress,
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 10,) ,
        FloatingActionButton(
          heroTag: "conferma",
          shape: const CircleBorder(),
          backgroundColor: Colors.green,
          onPressed:  onConfirmPress,
          child: const Icon(Icons.check, color: Colors.white, size: 30),
        ),
    ],
    ));
  }

  

 
}
