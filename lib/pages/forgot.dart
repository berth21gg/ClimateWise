import 'package:climate_wise/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  reset() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Lottie.asset('assets/animations/forgot_logo.json',
                    width: 210, height: 210),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Forgot Password ',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFFCFD8DC)
                              : Color(0xFF455A64),
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Center(
                  child: Text(
                    'Provide your email and we will send you a link to reset your password.',
                  ),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Card(
                    surfaceTintColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Color(0xFFCFD8DC)
                            : Color(0xFF455A64),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildEmailField(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: 16,
                    right: 16,
                    child: Center(
                      child: ElevatedButton(
                          onPressed: (() {
                            if (_formKey.currentState!.validate()) {
                              reset();
                            }
                          }),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent[400],
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 128),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'SEND',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Center(
                  child: RichText(
                      text: TextSpan(
                          text: 'Go back',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                (() => Get.offAll(() => const Wrapper())))),
                ),
              ),
            ],
          ),
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
      keyboardType: TextInputType.emailAddress,
      autofillHints: [AutofillHints.email],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        }
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}
