import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Login';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
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
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/logo.png'),
                          width: 135,
                          height: 101.8,
                        ),
                      ]
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(
                    width: 325,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(
                    width: 325,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
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
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.purple),
                      foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text("LOGIN"),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.purple)
                      ),
                      onPressed: () {},
                      child: Text("Non hai un account? Registrati")
                  )
                ]
            ),
          )
      ),
    );
  }
}