import 'package:flutter/material.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/registration/signup/game_selection_page.dart';
import 'package:game_tracker/pages/registration/login/login_page.dart';
import 'package:game_tracker/utilities/Utilities.dart';
import 'package:game_tracker/widgets/loading_Screen.dart';

class SignupPage extends StatefulWidget{

     const SignupPage({super.key});

     @override
     _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {

   final Playerservice playerService = Playerservice();
   Player player= Player();
   String? username;
   String? password;
   String? email;
   bool _showRegistrationLoadingScreen = false;

   void _switchScreen(){
    setState(() {
       player.username = username;
       player.email = email;
       player.password = password;
      _showRegistrationLoadingScreen = !_showRegistrationLoadingScreen;
    });
   }

   @override
     Widget build(BuildContext context) {
   return
   !_showRegistrationLoadingScreen ?
   Scaffold(
        appBar: AppBar(
          toolbarHeight: 150.0,
          flexibleSpace: const MyContainerWidget(),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }
        )
        ),
        body:
         Center(
        child: Column(
          children:[
          SizedBox(
          width: 325,
          child: TextField(
          decoration: const InputDecoration(
          border:  OutlineInputBorder(),
          labelText: "Username",
        ),
        onChanged: (value) {
              username = value;
            },
      ),
          ),
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
        const SizedBox(height: 40),
            FilledButton(
                  onPressed: () {
                    if (password == null ||
                        email == null ||
                        username == null ||
                        password == '' ||
                        email == '' ||
                        username == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Compilare tutti i campi'),
                        ),
                      );
                    } else if (Utilities.isValidEmail(email!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Email non valida, inserire una email valida'),
                        ),
                      );
                    } else {
                      _switchScreen();
                    }
                  },
                  child: const Text("PROSEGUI"),
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
                  child: const Text("Hai già un account? Effettua il login"));
            })
              ]),
        )

   )




      : LoadingScreen(httpOperation:playerService.addPlayer(player),widget:  GameSelectionPage(data: email ));
  }

}

class MyContainerWidget extends StatelessWidget {
  const MyContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column( children:
      [
            Transform.translate(offset: const Offset(0, 30),
      child: const Text("Registrazione", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26))),
            Transform.translate(
        offset: const Offset(0, 30),
        child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('logo1.jpg'),
            opacity: 1,
            fit: BoxFit.scaleDown
        ),
      ),
    ),
      ),
      ])
    );


  }
}
