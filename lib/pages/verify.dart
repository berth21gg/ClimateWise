import 'package:climate_wise/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  void initState() {
    super.initState();
    sendVerifyLink();
  }

  sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser!;

    if (!user.emailVerified) {
      try {
        await user.sendEmailVerification();
        Get.snackbar(
          'Enlace enviado',
          'Un enlace ha sido enviado a tu email',
          margin: const EdgeInsets.all(30),
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'too-many-requests') {
            Get.snackbar(
              'Demasiadas solicitudes',
              'Hemos bloqueado todas las solicitudes desde este dispositivo debido a actividad inusual. Intenta de nuevo más tarde.',
              margin: const EdgeInsets.all(30),
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            Get.snackbar(
              'Error',
              'Ocurrió un error al enviar el enlace de verificación. Por favor intenta de nuevo más tarde.',
              margin: const EdgeInsets.all(30),
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        }
      }
    } else {
      Get.snackbar(
        'Email ya verificado',
        'Tu email ya está verificado.',
        margin: const EdgeInsets.all(30),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  reload() async {
    await FirebaseAuth.instance.currentUser!
        .reload()
        .then((value) => {Get.offAll(Wrapper())});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text(
              'Abre tu correo y  da click en el enlace proporcionado para verificar tu email y recarga esta página'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => reload()),
        child: const Icon(Icons.restart_alt_rounded),
      ),
    );
  }
}
