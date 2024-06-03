import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:climate_wise/pages/forgot.dart';
import 'package:climate_wise/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isPasswordVisible = false;

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

  signInGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );
    if (loginResult.status == LoginStatus.success) {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_FAILED',
        message: loginResult.message,
      );
    }
  }

  Future<void> signInGitHub() async {
    // Verificar si hay una sesión activa en Firebase
    if (FirebaseAuth.instance.currentUser != null) {
      print('Ya hay una sesión activa');
      return;
    }

    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: 'Ov23liEHCw9cn5vKeUII',
        clientSecret: '5142a9c2a9dc5e2a02d86fb7b40bf9f236bb8881',
        redirectUrl: 'https://pmsn2024-87bbf.firebaseapp.com/__/auth/handler');

    var result = await gitHubSignIn.signIn(context);

    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        print(result.token);
        try {
          final AuthCredential credential =
              GithubAuthProvider.credential(result.token!);

          await FirebaseAuth.instance.signInWithCredential(credential);
        } catch (e) {
          print('Error al auntenticar con Firebase: $e');
        }
        break;
      case GitHubSignInResultStatus.cancelled:
        print('Inicio de sesión cancelado por el usuario');
        break;
      case GitHubSignInResultStatus.failed:
        print('Error durante el inicio de sesión: ${result.errorMessage}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: const Text('Login'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Card(
                        surfaceTintColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildEmailField(),
                              Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Colors.grey[300]),
                              _buildPasswordField(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: 16,
                        right: 16,
                        child: Center(
                          child: ElevatedButton(
                              onPressed: (() => signIn()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent[400],
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 128),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                        text: TextSpan(
                            text: 'Forgot Password?',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (() => Get.to(() => const Forgot())))),
                  ),
                  ElevatedButton(
                    onPressed: (() => Get.to(() => SignUp())),
                    child: const Text('Register Now'),
                  ),
                  ElevatedButton(
                    onPressed: (() => Get.to(() => Forgot())),
                    child: const Text('Forgot Password?'),
                  ),
                  ElevatedButton(
                    onPressed: (() => signInGoogle()),
                    child: const Text('Sign In Google'),
                  ),
                  ElevatedButton(
                    onPressed: (() => signInFacebook()),
                    child: const Text('Sign In Facebook'),
                  ),
                  ElevatedButton(
                    onPressed: (() => signInGitHub()),
                    child: const Text('Sign In GitHub'),
                  ),
                ],
              ),
            ),
          );
  }

  _buildEmailField() {
    return TextFormField(
      controller: email,
      decoration: InputDecoration(
        hintText: 'Email Address',
        prefixIcon: const Icon(Icons.email_outlined),
        suffixIcon: email.text.isEmpty
            ? const Icon(Icons.close, color: Colors.red)
            : const Icon(Icons.check, color: Colors.green),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  _buildPasswordField() {
    return TextFormField(
      controller: password,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }
}
