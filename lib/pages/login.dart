import 'package:flutter/material.dart';
import 'package:climate_wise/pages/forgot.dart';
import 'package:climate_wise/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Credenciales invalidas', e.code,
          icon: const Icon(
            Icons.warning,
            color: Colors.red,
          ));
    } catch (e) {
      Get.snackbar('Oops..! ', e.toString(),
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                    decoration:
                        const InputDecoration(hintText: 'Ingresa tu email'),
                  ),
                  TextField(
                    controller: password,
                    decoration: const InputDecoration(
                        hintText: 'Ingresa tu contraseña'),
                  ),
                  ElevatedButton(
                    onPressed: (() => signIn()),
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: (() => Get.to(SignUp())),
                    child: const Text('Register Now'),
                  ),
                  ElevatedButton(
                    onPressed: (() => Get.to(Forgot())),
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
            ),
          );
  }
}
