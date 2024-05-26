import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

signIn() async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email.text, password: password.text);
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: 'Ingresa tu email'),
            ),
            TextField(
              controller: password,
              decoration:
                  const InputDecoration(hintText: 'Ingresa tu contraseña'),
            ),
            ElevatedButton(
                onPressed: (() => signIn()), child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
