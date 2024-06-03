import 'package:climate_wise/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

signUp() async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text, password: password.text);

  // Navega a la pantalla 'Wrapper()' y elimina todas las rutas anteriores del stack de navegación.
  Get.offAll(() => Wrapper());
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                onPressed: (() => signUp()), child: const Text('Sign Up'))
          ],
        ),
      ),
    );
  }
}
