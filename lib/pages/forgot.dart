import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

TextEditingController email = TextEditingController();

reset() async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
}

class _ForgotState extends State<Forgot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot'),
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
            ElevatedButton(
                onPressed: (() => reset()), child: const Text('Send Link'))
          ],
        ),
      ),
    );
  }
}
