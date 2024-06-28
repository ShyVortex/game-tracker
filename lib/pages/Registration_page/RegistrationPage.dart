import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/utilities/Utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget{

     const RegistrationPage({super.key,});

     @override
     _RegistrationPage createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  
   final Playerservice playerService = Playerservice();
   Player? player;
   String? username;
   String? password;
   String? email;

   @override
     Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
          toolbarHeight: 150.0,
          flexibleSpace: const MyContainerWidget(),
        ),
        body:  
         Center(
        child: Column(
          children:[
             Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            textAlign: TextAlign.start,
            decoration: const InputDecoration(
              hintText: 'Username',
              border: OutlineInputBorder(),
            ),
             onChanged: (value) {
              username = value;
            },
          ),
        ),
         Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            textAlign: TextAlign.start,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              email = value;
            },
          ),
        ),
          Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            textAlign: TextAlign.start,
            decoration: const InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              password = value;
            },
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
                    onPressed: () async {
                      if(password == null||email==null||username==null||password ==''||email == ''||username == ''){
                         ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Compilare tutti i campi'),
                    ),
                  );
                      }
                      else if(Utilities.isValidEmail(email!)){
                        ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email non valida, inserire una email valida'),
                    ),
                        );
                      }
                    else {
                      Player player = Player();
                      player.username = username;
                      player.email = email;

                      String salt = Utilities.generateSalt();
                      password = Utilities.hashPassword(password!, salt);

                      player.password = password;

                      var JsonPlayer = jsonEncode(player);
                      try{
                       playerService.addPlayer(JsonPlayer);
                      }
                      catch(errore){
                        print(errore);
                      }
                    }
                    },
                    child: const Text("PROSEGUI"),

                  ),
        ]),
        ),
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
      child: Text("Registrazione", style: GoogleFonts.aBeeZee(fontSize: 35,color: Colors.black,decoration: TextDecoration.none,))),
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
