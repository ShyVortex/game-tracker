import 'package:flutter/material.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/Registration_page/RegistrationPage.dart';
import 'package:game_tracker/utilities/Utilities.dart';
import '../widgets/app_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  String? email; 
  String? password;
  final Playerservice _playerservice = Playerservice();
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
                      "LOGIN",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)
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
          decoration: const InputDecoration(
          border:  OutlineInputBorder(),
          labelText: "Password",
        ),
            onChanged: (value) {
              password = value;
            },
          ),
        ),
                  const SizedBox(height: 20),
                  CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Rimani connesso'),
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = value! ? true : false;
                        });
                      }
                  ),
                  const SizedBox(height: 40),
                  FilledButton(
                    child: const Text("LOGIN"),
                    onPressed: () async { 
                      if(password == null||email== null||password ==''||email == ''){
                        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                        content: Text('Compilare tutti i campi'),
                    ));
                    } else {
                      try{
                     _player = await  _playerservice.getPlayerByEmail(email!);
                     if(await Utilities.verifyPassword(password!, _player.password!)){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const Placeholder()),);
                     }
                     else{
                        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                        content: Text('Password sbagliata')));
                     }
                      }catch(error){
                        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                        content: Text('Nessun utente trovato con questa email'),
                    ));
                      }
                    }                 
  }),
                  const SizedBox(height: 20),
                  Builder(
          builder: (BuildContext context) {
            return TextButton(
                      onPressed: () {
                         Navigator.push(context,MaterialPageRoute(builder: (context) => const RegistrationPage()),);
                      },
                      child: const Text("Non hai un account? Registrati")
                  );
  }
  )             
                ]
            ),
          )
      );
  }
}