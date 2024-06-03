import 'package:climate_wise/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
        .then((value) => {Get.offAll(() => Wrapper())});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Lottie.asset('assets/animations/verify_logo.json',
                  width: 210, height: 210),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Verify your email address ',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color(0xFFCFD8DC)
                            : Color(0xFF455A64),
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Center(
                child: Text(
                  'We have just send email verification link on your email. Please check your email and click on that link to verify your Email address.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Center(
                child: Text(
                  'If not auto redirected after verification, click on the Reload button.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Center(
                  child: ElevatedButton(
                      onPressed: (() => reload()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent[400],
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 128),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'RELOAD',
                        style: TextStyle(color: Colors.white),
                      ))),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Center(
                child: RichText(
                    text: TextSpan(
                        text: 'Back to login',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (() => Get.offAll(() => const Wrapper())))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
