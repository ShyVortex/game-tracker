import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/profile/search_games_page.dart';
import 'package:game_tracker/pages/registration/login/login_page.dart';
import 'package:game_tracker/utilities/image_utilities.dart';
import 'package:game_tracker/utilities/login_utilities.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../models/genere.dart';
import '../navigationBar/navigation_page.dart';

class ProfilePage extends StatefulWidget {
  static String oldPsw = "";

  final Player player;

  const ProfilePage({super.key, required this.player});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  static List<String> genderList = <String>[Genere.MASCHIO.name,
    Genere.FEMMINA.name, Genere.NON_BINARIO.name
  ];
  static const List<String> platformList = <String>['PC', 'Steam Deck', 'PS5',
    'Xbox Series S/X', 'Nintendo Switch', 'PS4', 'PS Vita', 'Xbox One', 'PS3',
    'PSP', 'Xbox 360', 'Nintendo Wii U', 'Nintendo 3DS', 'Nintendo Wii', 'PS2',
    'Xbox', 'Nintendo DS', 'Nintendo GameCube', 'Nintendo GBA', 'Retro console'
  ];
  File? galleryFile;
  ImageProvider<Object>? convertedImage;
  final picker = ImagePicker();
  final int currentYear = DateTime.now().year;
  bool isLoading = true;

  final PlayerService playerService = PlayerService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController platformController = TextEditingController();
  final TextEditingController favouriteController = TextEditingController();

  final _emailFormKey = GlobalKey<FormFieldState>();
  final int settingsIndex = 3;

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
    ProfilePage.oldPsw = widget.player.password!;

    waitLoad();
    loadProfileImage();
    initializeFields();
  }

  Future<void> waitLoad() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadProfileImage() async {
    // Carica immagine nuovo utente
    setState(() {
      convertedImage = const AssetImage('assets/new-user.png');
    });

    final prefs = await SharedPreferences.getInstance();
    String associatedUser = widget.player.id.toString();
    String? encoded = prefs.getString('profileImage_$associatedUser');

    if (encoded != null && encoded.isNotEmpty) {
      // Se l'utente ha già impostato un avatar allora caricalo
      try {
        // Con await ottiene il file da Future<File>
        Uint8List imgBytes = ImageUtilities.instance.decodeImage(encoded);

        setState(() {
          convertedImage = MemoryImage(imgBytes);
        });
      } catch (e) {
        print("Error decoding image: $e");
      }
    }
  }

  Future<void> initializeFields() async {
    setState(() {
      emailController.text = widget.player.email!;
      passwordController.text = placeholder;

      currentEmail = emailController.text;
      currentPassword = passwordController.text;

      if (widget.player.birthday != null) {
        dateController.text = widget.player.birthday!;
      } else {
        dateController.text = "";
      }
      if (widget.player.genere != null) {
        genderController.text = widget.player.genere!.name;
      } else {
        genderController.text = "";
      }
      if (widget.player.piattaforma != null) {
        platformController.text = widget.player.piattaforma!;
      } else {
        platformController.text = "";
      }
      if (widget.player.giocoPreferito != null) {
        favouriteController.text = widget.player.giocoPreferito!;
      } else {
        favouriteController.text = "";
      }

      currentDate = dateController.text;
      currentGender = genderController.text;
      currentFavPlatform = platformController.text;
      currentFavGame = favouriteController.text;
    });
  }

  void routeToSettings() {
    Navigator.push(context,
        MaterialPageRoute(builder:
            (context) => NavigationState.setCurrentPage(settingsIndex))
    );
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
    String b64Img = ImageUtilities.instance.encodeImage(galleryFile!);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileImage_${widget.player.id.toString()}", b64Img);

    Uint8List bytes = ImageUtilities.instance.decodeImage(b64Img);
    setState(() {
      convertedImage = MemoryImage(bytes);
    });
  }

  Future<void> selectBirthday(BuildContext context) async {
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
        currentDate = dateController.text;
      });
    }
  }

  Future<void> onAddFavGame() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchGamesPage(player: widget.player)
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
    if (currentEmail != widget.player.email || currentPassword != placeholder) {
      return true;
    }
    if (currentDate != widget.player.birthday && dateController.text.isNotEmpty) {
      return true;
    }
    if (currentGender != widget.player.genere?.name && currentGender.isNotEmpty) {
      return true;
    }
    if (currentFavPlatform != widget.player.piattaforma && currentFavPlatform.isNotEmpty) {
      return true;
    }
    if (currentFavGame != widget.player.giocoPreferito && currentFavGame.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<void> onConfirmPress(int idPlayer, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();

    if(_emailFormKey.currentState!.validate()){
    try {
      setState(() {
        isLoading = true;

        if (currentPassword == placeholder) {
          currentPassword = widget.player.password!;
        }

        Player updated = widget.player;

        updated.email = currentEmail;
        updated.password = currentPassword;

        if (currentDate.isNotEmpty) {
          if (widget.player.birthday == null) {
            playerService.addPlayerBirthday(widget.player.id!, currentDate);
          } else {
            playerService.updatePlayerBirthday(widget.player.id!, currentDate);
          }
          updated.birthday = currentDate;
        }

        if (currentGender.isNotEmpty) {
          currentGender = currentGender.toUpperCase();
          Genere? updatedGender = GenereExtension.genereFromBackend(currentGender);

          if (widget.player.genere == null) {
            playerService.addPlayerGenere(widget.player.id!,
                updatedGender!.backendValue);
          } else {
            playerService.updatePlayerGenere(widget.player.id!,
                updatedGender!.backendValue);
          }

          updated.genere = updatedGender;
        }

        updated.piattaforma = currentFavPlatform;
        updated.giocoPreferito = currentFavGame;


        playerService.updatePlayer(updated, idPlayer);
        prefs.setString("email",updated.email!);

        ref.read(playerProvider.notifier)
          .update((state) => updated);

        initializeFields();
        waitLoad();
      });

      ProfilePage.oldPsw = widget.player.password!;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Dati modificati con successo!'),
      ));

    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Errore nella modifica, riprova più tardi.'),
      ));
    }
    }
  }

  Future<void> onAccountDelete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();

      await playerService.deletePlayer(widget.player.id!);

      Navigator.pop(context, 'SI');
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LoginPage())
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Dati eliminati con successo.'),
      ));

    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Errore nella rimozione, riprova più tardi.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 85),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: routeToSettings,
                        icon: Icon(Icons.settings,
                            size: 28,
                            color: GameTracker.isLightOrDark(context) == "Light"
                                ? Colors.black
                                : Colors.grey[100]))
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
                if (isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                if (!isLoading)
                  Expanded(
                      child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 30, right: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: convertedImage,
                                  ),
                                  Positioned(
                                      top: 75,
                                      left: 25,
                                      child: RawMaterialButton(
                                        constraints: const BoxConstraints(
                                            minWidth: 25,
                                            minHeight: 25,
                                            maxWidth: 25,
                                            maxHeight: 25),
                                        onPressed: () {
                                          handleChangePfp(context: context);
                                        },
                                        fillColor: Colors.white,
                                        shape: const CircleBorder(),
                                        child: const Icon(Icons.photo_camera,
                                            size: 20, color: Colors.black),
                                      ))
                                ],
                              ),
                              const SizedBox(width: 25),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.player.username!,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                          width: 135,
                                          child: TextFormField(
                                            key: _emailFormKey,
                                            controller: emailController,
                                            decoration: const InputDecoration(
                                              border: null,
                                              labelText: "Email",
                                            ),
                                            style:
                                                const TextStyle(fontSize: 15),
                                            keyboardType: TextInputType.text,
                                            readOnly: !isEditingEmail,
                                            validator: (value) {
                                              if (value == null ||
                                                  value == "") {
                                                return "Compilare il campo";
                                              } else if (LoginUtilities
                                                  .isValidEmail(value)) {
                                                return "Inserire un'email valida";
                                              }
                                              return null;
                                            },
                                          )),
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          if (!isEditingEmail)
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              iconSize: 20,
                                              onPressed: () {
                                                setState(() {
                                                  emailController.text =
                                                      currentEmail;
                                                  isEditingEmail = true;
                                                });
                                              },
                                            ),
                                          if (!isEditingEmail &&
                                              currentEmail !=
                                                  widget.player.email)
                                            Positioned(
                                              top: 22.5,
                                              child: IconButton(
                                                icon: const Icon(Icons
                                                    .settings_backup_restore),
                                                iconSize: 20,
                                                onPressed: () {
                                                  setState(() {
                                                    currentEmail =
                                                        widget.player.email!;
                                                    emailController.text =
                                                        currentEmail;
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
                                                    emailController.text =
                                                        currentEmail;
                                                    isEditingEmail = false;
                                                  });
                                                }),
                                          if (isEditingEmail)
                                            Positioned(
                                                top: 22.5,
                                                child: IconButton(
                                                    icon: const Icon(
                                                        Icons.check_circle),
                                                    iconSize: 20,
                                                    onPressed: () {
                                                      setState(() {
                                                        isEditingEmail = false;

                                                        if (emailController
                                                            .text.isEmpty) {
                                                          emailController.text =
                                                              currentEmail;
                                                        } else {
                                                          currentEmail =
                                                              emailController
                                                                  .text;
                                                        }
                                                      });
                                                    }))
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
                                  onPressed: () => selectBirthday(context),
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
                            const SizedBox(height: 24),
                            FilledButton.icon(
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Attenzione'),
                                    content: const Text('Sei sicuro di voler eliminare il tuo account?\n'
                                    "Quest'azione è irreversibile."
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'NO'),
                                        child: const Text('NO'),
                                      ),
                                      TextButton(
                                        onPressed: onAccountDelete,
                                        child: const Text('SI'),
                                      ),
                                    ],
                                  ),
                                ),
                                label: const Text("Cancella account",
                                    style: TextStyle(
                                  color: Colors.white
                                )),
                              icon: const Icon(
                                  Icons.warning,
                                color: Colors.white,
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                                )
                              )
                            )
                          ],
                        ),
                      ),
                    )
                ),
              ]),
            ),
            floatingActionButton:
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isLoading && !isEditingEmail
                    && !isEditingPassword && hasAnyValueChanged()
                )
                  FloatingActionButton(
                    heroTag: "restore_fields",
                    shape: const CircleBorder(),
                    backgroundColor: GameTracker.isLightOrDark(context) == "Light"
                        ? Colors.black
                        : Colors.white,
                    onPressed: initializeFields,
                    child: Icon(
                        Icons.settings_backup_restore,
                        color: GameTracker.isLightOrDark(context) == "Light"
                            ? Colors.white
                            : Colors.black,
                        size: 30),
                  ),
                const SizedBox(width: 16),
                if (!isLoading && !isEditingEmail
                    && !isEditingPassword && hasAnyValueChanged()
                )
                  Consumer(builder: (context, ref, child) {
                    return FloatingActionButton(
                      heroTag: "confirm_profile_update",
                      shape: const CircleBorder(),
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        await onConfirmPress(ref.watch(playerProvider).id!, ref);
                      },
                      child: const Icon(Icons.check, color: Colors.white, size: 30),
                    );
                  })
              ],
            )
        )
    );
  }
}