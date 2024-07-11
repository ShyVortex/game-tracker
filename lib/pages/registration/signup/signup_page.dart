import 'package:flutter/material.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/registration/signup/game_selection_page.dart';
import 'package:game_tracker/pages/registration/login/login_page.dart';
import 'package:game_tracker/utilities/login_utilities.dart';
import 'package:game_tracker/widgets/loading_screen.dart';

class SignupPage extends StatefulWidget{

     const SignupPage({super.key});

     @override
     SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
   final PlayerService playerService = PlayerService();
   Player player= Player();
   String? username;
   String? password;
   String? email;
   bool _showRegistrationLoadingScreen = false;
   bool isPasswordHidden = true;

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
        SingleChildScrollView(child:
         Center(
        child: Column(
          children:[
          SizedBox(
          width: 325,
          child: TextField(
          decoration: const InputDecoration(
          border:  OutlineInputBorder(),
          labelText: "Username",
              labelStyle: TextStyle(fontFamily: 'Inter')
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
                  child: const Text("PROSEGUI",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter'
                      )
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
                  child: const Text("Hai già un account? Effettua il login",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter'
                      )
                  ));
            })
              ]),
        )
        )
   )
        : LoadingScreen(
            httpOperation: playerService.addPlayer(player),
            widget: GameSelectPage(data: email)
   );
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
      child: const Text("Registrazione", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, fontFamily: 'Inter'))),
            Transform.translate(
        offset: const Offset(0, 30),
        child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo1.jpg'),
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
