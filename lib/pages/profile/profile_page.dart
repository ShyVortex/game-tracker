import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/profile/search_games_page.dart';
import 'package:game_tracker/utilities/concrete_image_utilities.dart';
import 'package:game_tracker/utilities/reference_utilities.dart';
import 'package:game_tracker/widgets/date_picker_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

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
  File? galleryFile;
  final picker = ImagePicker();
  final int currentYear = DateTime.now().year;

  Player player = Player();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController platformController = TextEditingController();
  final TextEditingController favouriteController = TextEditingController();

  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isPasswordHidden = true;

  String placeholder = "................";
  String currentEmail = "";
  String currentPassword = "";
  String currentDate = "";
  String currentGender = "";
  String currentFavPlatform = "";
  String currentFavGame = "";

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
      // Se l'utente ha già impostato un avatar allora caricalo
      try {
        // Con await ottiene il file da Future<File>
        File imageFile = await ConcreteImageUtilities.instance.decodeImage(b64Img);

        setState(() {
          galleryFile = imageFile;
        });
      } catch (e) {
        print("Error decoding image: $e");
      }
    }
  }

  Future<void> initializeFields() async {
    setState(() {
      emailController.text = player.email!;
      passwordController.text = placeholder;

      currentEmail = emailController.text;
      currentPassword = passwordController.text;

      if (player.birthday != null) {
        dateController.text = player.birthday!;
      } else {
        dateController.text = "";
      }
      if (player.genere != null) {
        genderController.text = player.genere?.name as String;
      } else {
        genderController.text = "";
      }
      if (player.piattaforma != null) {
        platformController.text = player.piattaforma!.name;
      } else {
        platformController.text = "";
      }

      currentDate = dateController.text;
      currentGender = genderController.text;
      currentFavPlatform = platformController.text;
      currentFavGame = favouriteController.text;
    });
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(currentYear - 100),
        lastDate: DateTime.now(),
        locale: const Locale('it', 'IT')
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> onAddFavGame() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SearchGamesPage()
        )
    );

    if (result != null) {
      setState(() {
        favouriteController.text = result.game.nome;
        currentFavGame = favouriteController.text;
      });
    }
  }

  bool hasAnyValueChanged() {
    if (currentEmail != player.email || currentPassword != placeholder) {
      return true;
    }
    if (currentDate != player.birthday && dateController.text.isNotEmpty) {
      return true;
    }
    if (currentGender != player.genere?.name && currentGender.isNotEmpty) {
      return true;
    }
    if (currentFavPlatform != player.piattaforma?.name && currentFavPlatform.isNotEmpty) {
      return true;
    }

    return false;
  }


  Future<void> onConfirmPress(int idPlayer) async {

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
                              clipBehavior: Clip.none,
                              children: [
                                AvatarView(
                                  radius: 50,
                                  avatarType: AvatarType.CIRCLE,
                                  imagePath: galleryFile!.path,
                                ),
                                Positioned(
                                  top: 75,
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
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 135,
                                        child: TextFormField(
                                          controller: emailController,
                                          decoration: const InputDecoration(
                                            border:  null,
                                            labelText: "Email",
                                          ),
                                          style: const TextStyle(fontSize: 15),
                                          keyboardType: TextInputType.text,
                                          readOnly: !isEditingEmail,
                                        )
                                    ),
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        if (!isEditingEmail)
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            iconSize: 20,
                                            onPressed: () {
                                              setState(() {
                                                emailController.text = currentEmail;
                                                isEditingEmail = true;
                                              });
                                            },
                                          ),
                                        if (!isEditingEmail && currentEmail != player.email)
                                          Positioned(
                                            top: 22.5,
                                            child: IconButton(
                                              icon: const Icon(Icons.settings_backup_restore),
                                              iconSize: 20,
                                              onPressed: () {
                                                setState(() {
                                                  currentEmail = player.email!;
                                                  emailController.text = currentEmail;
                                                });
                                              },
                                            ),
                                          ),

                                        if (isEditingEmail)
                                          IconButton(
                                              icon: const Icon(Icons.cancel),
                                              iconSize: 20,
                                              onPressed: () {
                                                setState(() {
                                                  emailController.text = currentEmail;
                                                  isEditingEmail = false;
                                                });
                                              }
                                          ),
                                        if (isEditingEmail)
                                          Positioned(
                                            top: 22.5,
                                            child: IconButton(
                                              icon: const Icon(Icons.check_circle),
                                              iconSize: 20,
                                              onPressed: () {
                                                setState(() {
                                                  isEditingEmail = false;

                                                  if (emailController.text.isEmpty) {
                                                    emailController.text = currentEmail;
                                                  } else {
                                                    currentEmail = emailController.text;
                                                  }
                                                });
                                              }
                                            )
                                          )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 38),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: !isEditingPassword,
                                obscureText: isPasswordHidden,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                if (!isEditingPassword)
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      setState(() {
                                        isEditingPassword = true;
                                        isPasswordHidden = false;

                                        if (currentPassword == placeholder) {
                                          passwordController.text = "";
                                        } else {
                                          passwordController.text = currentPassword;
                                        }
                                      });
                                    },
                                  ),
                                if (isEditingPassword)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: IconButton(
                                        icon: const Icon(Icons.cancel),
                                        iconSize: 20,
                                        onPressed: () {
                                          setState(() {
                                            passwordController.text = currentPassword;
                                            isEditingPassword = false;
                                            isPasswordHidden = true;
                                          });
                                        }
                                    ),
                                  ),
                                if (isEditingPassword)
                                  Positioned(
                                      top: 30,
                                      child: IconButton(
                                          icon: const Icon(Icons.check_circle),
                                          iconSize: 20,
                                          onPressed: () {
                                            setState(() {
                                              isEditingPassword = false;
                                              isPasswordHidden = true;

                                              if (passwordController.text.isEmpty) {
                                                passwordController.text = currentPassword;
                                              } else {
                                                currentPassword = passwordController.text;
                                              }
                                            });
                                          }
                                      )
                                  )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: dateController,
                                decoration: const InputDecoration(
                                  labelText: "Data di nascita",
                                  border: OutlineInputBorder(),
                                ),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () => selectDate(context),
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
                                      currentGender = value!;
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
                                      currentFavPlatform = value!;
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
                            if (currentFavGame.isEmpty)
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: onAddFavGame,
                              ),
                            if (currentFavGame.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.edit_document),
                                onPressed: onAddFavGame,
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
      floatingActionButton:
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isEditingEmail && !isEditingPassword && hasAnyValueChanged())
              FloatingActionButton(
                heroTag: "restore_fields",
                shape: const CircleBorder(),
                backgroundColor: Colors.black,
                onPressed: initializeFields,
                child: const Icon(Icons.settings_backup_restore, color: Colors.white, size: 30),
              ),
              if (!isEditingEmail && !isEditingPassword && hasAnyValueChanged())
                Consumer(builder: (context, ref, child) {
                  return FloatingActionButton(
                    heroTag: "confirm_profile_update",
                    shape: const CircleBorder(),
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      await onConfirmPress(ref.watch(playerProvider).id!);
                    },
                    child: const Icon(Icons.check, color: Colors.white, size: 30),
                  );
                })
            ],
          )
      );
  }
}