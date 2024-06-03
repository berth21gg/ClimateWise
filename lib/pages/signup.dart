import 'package:climate_wise/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  signUp() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text, password: password.text);

    // Navega a la pantalla 'Wrapper()' y elimina todas las rutas anteriores del stack de navegación.
    Get.offAll(() => Wrapper());
  }

  @override
  void initState() {
    super.initState();
    password.addListener(_updateState);
    confirmPassword.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    password.removeListener(_updateState);
    confirmPassword.removeListener(_updateState);
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
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
                child: Lottie.asset('assets/animations/logo.json',
                    width: 210, height: 210),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Climate ',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Color(0xFFCFD8DC)
                                    : Color(0xFF455A64),
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                        children: const [
                          TextSpan(
                              text: 'Wise',
                              style: TextStyle(
                                  color: Color(0xFF78909C),
                                  fontSize: 32,
                                  fontWeight: FontWeight.normal)),
                        ]),
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
                            Divider(
                                thickness: 1,
                                height: 1,
                                color: Colors.grey[300]),
                            _buildPasswordField(),
                            Divider(
                                thickness: 1,
                                height: 1,
                                color: Colors.grey[300]),
                            _buildConfirmPasswordField(),
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
                              signUp();
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
                            'SIGN UP',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              if (password.text != confirmPassword.text)
                const Text(
                  'Please make sure your password match',
                  style: TextStyle(color: Colors.red),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 150.0, bottom: 20.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: "Already have a account? ",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (() => Get.offAll(() => Wrapper())),
                          )
                        ]),
                  ),
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

  _buildPasswordField() {
    return TextFormField(
      controller: password,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Icons.key_outlined),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  _buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPassword,
      obscureText: !isConfirmPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isConfirmPasswordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: () {
            setState(() {
              isConfirmPasswordVisible = !isConfirmPasswordVisible;
            });
          },
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != confirmPassword.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
