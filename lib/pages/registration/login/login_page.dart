import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/main.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/navigationBar/navigation_page.dart';
import 'package:game_tracker/pages/registration/signup/signup_page.dart';
import 'package:game_tracker/utilities/login_utilities.dart';
import 'package:game_tracker/utilities/reference_utilities.dart';
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
  bool isLoading = false;
  final PlayerService _playerservice = PlayerService();
  Player _player = Player();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _passwordFormKey = GlobalKey<FormFieldState>();
  final _emailFormKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Text("Login",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                fontFamily: 'Inter')),
        const SizedBox(height: 24),
        const AppLogo(),
        const SizedBox(height: 32),
        SizedBox(
          width: 325,
          child:  TextFormField(
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
              } 
              else if(LoginUtilities.isValidEmail(value)) {
                return "formato email non valido";
              }
              else {
                return null;
              }
            }
          )
        ),
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
                  isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            obscureText: isPasswordHidden,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Per favore inserire la password';
              }else { 
              return null;
            }},
          ),
        ),
        const SizedBox(height: 20),
        CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Rimani connesso',
                style: TextStyle(fontFamily: 'Inter')),
            value: rememberMe,
            onChanged: (bool? value) {
              setState(() {
                rememberMe = value! ? true : false;
              });
            }),
        const SizedBox(height: 40),
        Consumer(builder: (context, ref, child) {
          return FilledButton(
              onPressed: !isLoading ? () async {
                if(_emailFormKey.currentState!.validate() && _passwordFormKey.currentState!.validate()){
                  setState(() {
                    isLoading = true;
                  });
                     _playerservice.getPlayerByEmail(_emailController.text).then((onValue){
                     _player = onValue;
                     LoginUtilities.verifyPassword(_passwordController.text, _player.password!).then((onValue) async {
                      if(onValue){
                      ref.read(playerProvider.notifier).state = _player;

                      final prefs = await SharedPreferences.getInstance();

                      if (rememberMe) {
                        await prefs.setString("password", _player.password!);
                        await prefs.setString("email", _player.email!);
                      }

                      ReferenceUtilities.setActivePlayer(_player);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavigationPage()));
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password sbagliata')));
                        setState(() {
                          isLoading = false;
                        });
                      }
                     });

                    }).catchError((onError){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Nessun utente trovato con questa email'),
                    ));
                    setState(() {
                        isLoading = false;
                      });
                    });
                }
              } : null,
              child: !isLoading?
              const Text("LOGIN",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: 'Inter')
                      ) : const SizedBox(
                    height: 12,
                    width: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  )

              );
        }),
        const SizedBox(height: 20),
        Builder(builder: (BuildContext context) {
          return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text("Non hai un account? Registrati",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontFamily: 'Inter')));
        })
      ]),
    ))));
  }
}
