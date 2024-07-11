import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/utilities/concrete_image_utilities.dart';
import 'package:game_tracker/utilities/reference_utilities.dart';
import 'package:game_tracker/widgets/date_picker_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.idPlayer});
  final int idPlayer;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  static const List<String> genderList = <String>['Maschio', 'Femmina', 'Non binario'];
  static const List<String> platformList = <String>['PC', 'Steam Deck', 'PS5',
    'Xbox Series S/X', 'Nintendo Switch', 'PS4', 'PS Vita', 'Xbox One', 'PS3',
    'PSP', 'Xbox 360', 'Nintendo Wii U', 'Nintendo 3DS', 'Nintendo Wii', 'PS2',
    'Xbox', 'Nintendo DS', 'Nintendo GameCube', 'Nintendo GBA', 'Retro console'
  ];
  String dropdownValue = "";
  bool hasFavouriteGame = false; // variabile placeholder
  File? galleryFile;
  final picker = ImagePicker();

  Player player = Player();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController platformController = TextEditingController();
  final TextEditingController favouriteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    player = ReferenceUtilities.getActivePlayer();
    loadProfileImage();
    initializeFields();
  }

  Future<void> loadProfileImage() async {
    // Carica immagine nuovo utente
    galleryFile = File("assets/new-user.png");

    final prefs = await SharedPreferences.getInstance();
    String? b64Img = prefs.getString('profileImage');
    if (b64Img != null && b64Img.isNotEmpty) {
      try {
        // Con await ottiene il file da Future<File>
        File imageFile = await ConcreteImageUtilities.instance.decodeImage(b64Img);

        setState(() {
          galleryFile = imageFile;
        });
      } catch (e) {
        // Handle error, such as displaying an error message
        print("Error decoding image: $e");
      }
    }
  }

  Future<void> initializeFields() async {
    emailController.text = player.email!;
    passwordController.text = "................";

    if (player.birthday != null) {
      dateController.text = player.birthday!;
    }
    if (player.genere != null) {
      genderController.text = player.genere?.name as String;
    }
    if (player.piattaforma != null) {
      platformController.text = player.piattaforma!.name;
    }
  }

  void handleChangePfp({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Fotocamera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galleria'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
      ImageSource img,
      ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);

          // Converti in base64 e salva in locale
          processImage(galleryFile!);
        }
      },
    );
  }

  Future processImage(File imageFile) async {
    String b64Img = await ConcreteImageUtilities.instance
        .encodeImage(galleryFile!);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileImage", b64Img);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: null,
                icon: Icon(Icons.settings, size: 28, color: Colors.black))
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 32),
                child: Text("Profilo",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        fontFamily: 'Inter'))),
          ],
        ),
        const Divider(),
            Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, left: 30, right: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                AvatarView(
                                  radius: 50,
                                  avatarType: AvatarType.CIRCLE,
                                  imagePath: galleryFile!.path,
                                ),
                                Positioned(
                                  top: 70,
                                    left: 25,
                                    child: RawMaterialButton(
                                      constraints: const BoxConstraints(
                                        minWidth: 25,
                                        minHeight: 25,
                                        maxWidth: 25,
                                        maxHeight: 25
                                      ),
                                      onPressed: () {
                                        handleChangePfp(context: context);
                                      },
                                      fillColor: Colors.white,
                                      shape: const CircleBorder(),
                                      child: const Icon(
                                        Icons.photo_camera,
                                        size: 20,
                                      ),
                                    )
                                )
                              ],
                            ),
                            const SizedBox(width: 25),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(player.username!, style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                )),
                                const SizedBox(height: 5),
                                SizedBox(
                                    width: 170,
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          border:  null,
                                          labelText: "Email",
                                      ),
                                      keyboardType: TextInputType.text,
                                    )
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        DatePickerField(
                            dateController: dateController,
                            label: "Data di nascita"
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Genere",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                    )),
                                DropdownMenu<String>(
                                  controller: genderController,
                                  width: 250,
                                  initialSelection: "",
                                  onSelected: (String? value) {
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  dropdownMenuEntries: genderList.map<DropdownMenuEntry<String>>((String value) {
                                    return DropdownMenuEntry<String>(value: value, label: value);
                                  }).toList(),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Piattaforma preferita",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                    )),
                                DropdownMenu<String>(
                                  controller: platformController,
                                  width: 250,
                                  initialSelection: "",
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
                        const SizedBox(height: 24),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: favouriteController,
                                decoration: const InputDecoration(
                                  labelText: 'Gioco preferito',
                                  labelStyle: TextStyle(fontFamily: 'Roboto'),
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (!hasFavouriteGame)
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {},
                              ),
                            if (hasFavouriteGame)
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {},
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
            )
      ]),
    ),
    );
  }
}