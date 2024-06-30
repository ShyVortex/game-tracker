import 'package:flutter/material.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/Registration_page/RegistrationPage.dart';
import '../widgets/box_input_field.dart';
import '../widgets/app_logo.dart';
import '../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Login';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildThemeData(),
      title: appTitle,
      home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                      appTitle,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)
                  ),
                  const SizedBox(height: 24),
                  const AppLogo(),
                  const SizedBox(height: 32),
                  const BoxInputField(text: "Email"),
                  const SizedBox(height: 32),
                  const BoxInputField(text: "Password"),
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
                    onPressed: () {

                    },
                    child: const Text("LOGIN"),
                  ),
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
      ),
    );
  }
}