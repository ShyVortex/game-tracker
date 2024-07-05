import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/main.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/navigationBar/navigation_page.dart';
import 'package:game_tracker/pages/registration/signup/signup_page.dart';
import 'package:game_tracker/utilities/Utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/app_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool isPasswordHidden = true;
  String? email; 
  String? password;
  final PlayerService _playerservice = PlayerService();
  Player _player = Player();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        fontFamily: 'Inter'
                      )
                  ),
                  const SizedBox(height: 24),
                  const AppLogo(),
                  const SizedBox(height: 32),
                  SizedBox(
          width: 325,
          child: TextField(
          decoration: const InputDecoration(
          border:  OutlineInputBorder(),
          labelText: "Email",
              labelStyle: TextStyle(fontFamily: 'Inter')
        ),
            onChanged: (value) {
              email = value;
            },
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 325,
          child: TextField(
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
                    icon: const Icon(Icons.remove_red_eye)
                )),
            obscureText: isPasswordHidden,
            onChanged: (value) {
              password = value;
            },
          ),
        ),
        const SizedBox(height: 20),
        CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Rimani connesso',
                style: TextStyle(
                    fontFamily: 'Inter'
                )
            ),
            value: rememberMe,
            onChanged: (bool? value) {
              setState(() {
                rememberMe = value! ? true : false;
              });
            }),
        const SizedBox(height: 40),
        Consumer(
          builder: (context, ref,child){
        return FilledButton(
            child: const Text("LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                    fontFamily: 'Inter'
                )
            ),
            onPressed: () async {
              if (password == null ||
                  email == null ||
                  password == '' ||
                  email == '') {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Compilare tutti i campi'),
                ));
              } else {
                try {
                  _player = await _playerservice.getPlayerByEmail(email!);
                  if (await Utilities.verifyPassword(
                      password!, _player.password!)) {

                    ref.read(playerProvider.notifier).state = _player;

                    final prefs = await SharedPreferences.getInstance();

                    if(rememberMe){
                    await prefs.setString("password", _player.password!);
                    await prefs.setString("email", _player.email!);
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  const NavigationPage())
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password sbagliata')));
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Nessun utente trovato con questa email'),
                  ));
                }
              }
        });
          }),
        const SizedBox(height: 20),
        Builder(builder: (BuildContext context) {
          return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SignupPage()),
                );
              },
              child: const Text("Non hai un account? Registrati",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                      fontFamily: 'Inter'
                  )
              ));
        })
      ]),
    ));
  }
}