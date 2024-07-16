import 'package:flutter/material.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/registration/signup/game_selection_page.dart';
import 'package:game_tracker/pages/registration/login/login_page.dart';
import 'package:game_tracker/utilities/login_utilities.dart';
import 'package:game_tracker/widgets/loading_screen.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final PlayerService playerService = PlayerService();

  Player player = Player();
  bool isLoading = false;
  bool _showRegistrationLoadingScreen = false;
  bool isPasswordHidden = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final _passwordFormKey = GlobalKey<FormFieldState>();
  final _emailFormKey = GlobalKey<FormFieldState>();
  final _usernameFormKey = GlobalKey<FormFieldState>();

  void _switchScreen() {
    setState(() {
      player.username = _usernameController.text;
      player.email = _emailController.text;
      player.password = _passwordController.text;
      _showRegistrationLoadingScreen = !_showRegistrationLoadingScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_showRegistrationLoadingScreen
        ? SafeArea(
            child: Scaffold(
                appBar: AppBar(
                    forceMaterialTransparency: true,
                    toolbarHeight: 150.0,
                    flexibleSpace: const MyContainerWidget(),
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
                body: SingleChildScrollView(
                    child: Center(
                  child: Column(children: [
                    SizedBox(
                      width: 325,
                      child: TextFormField(
                        key: _usernameFormKey,
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle: TextStyle(fontFamily: 'Inter'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserire un username';
                          }
                          else if(value.contains(" ")){
                            return "username non può contenere spazi";
                          }
                          return null;
                          
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                        width: 325,
                        child: TextFormField(
                            key: _emailFormKey,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email",
                              labelStyle: TextStyle(fontFamily: 'Inter'),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Per favore inserire una email';
                              } else if (LoginUtilities.isValidEmail(value)) {
                                return "formato email non valido";
                              } else {
                                return null;
                              }
                            })),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 325,
                      child: TextFormField(
                        key: _passwordFormKey,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Password",
                          labelStyle: const TextStyle(fontFamily: 'Inter'),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordHidden = !isPasswordHidden;
                              });
                            },
                            icon: Icon(
                              isPasswordHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: isPasswordHidden,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Per favore inserire la password';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    FilledButton(
                      onPressed: !isLoading?
                      () {
                        if (_usernameFormKey.currentState!.validate() &&
                            _emailFormKey.currentState!.validate() &&
                            _passwordFormKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            playerService.getPlayerByEmail(_emailController.text).then(
                              (onvalue){
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Utente già presente con questa email'),
                      
                    ));
                    setState(() {
                      isLoading = false;
                    });
                              }
                          ).catchError((onError){
                            _switchScreen();
                          });
                        }
                      } : null,
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white
                      ),
                      child: !isLoading?
                      const Text("PROSEGUI",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter')) :
                              const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  ),
                    ),
                    const SizedBox(height: 20),
                    Builder(builder: (BuildContext context) {
                      return TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.purple,
                              shadowColor: Colors.white
                          ),
                          child: const Text(
                              "Hai già un account? Effettua il login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter')));
                    })
                  ]),
                ))))
        : LoadingScreen(
            httpOperation: playerService.addPlayer(player),
            widget: GameSelectPage(data: _emailController.text));
  }
}

class MyContainerWidget extends StatelessWidget {
  const MyContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(children: [
          Transform.translate(
              offset: const Offset(0, 30),
              child: const Text("Registrazione",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      fontFamily: 'Inter'))),
          Transform.translate(
            offset: const Offset(0, 30),
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    opacity: 1,
                    fit: BoxFit.scaleDown),
              ),
            ),
          ),
        ]));
  }
}
