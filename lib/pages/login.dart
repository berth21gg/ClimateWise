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
  // final AppLinks _appLinks = AppLinks();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _checkForDeepLink();
  // }

  // Future<void> _checkForDeepLink() async {
  //   _appLinks.uriLinkStream.listen((Uri? uri) {
  //     if (uri != null && uri.scheme == 'https') {
  //       final code = uri.queryParameters['code'];
  //       if (code != null) {
  //         _signInWithGitHub(code);
  //       }
  //     }
  //   });

  //   final uri = await _appLinks.getInitialLink();
  //   if (uri != null && uri.scheme == 'https') {
  //     final code = uri.queryParameters['code'];
  //     if (code != null) {
  //       _signInWithGitHub(code);
  //     }
  //   }
  // }

  // Future<void> _signInWithGitHub(String code) async {
  //   try {
  //     final credential = GithubAuthProvider.credential(code);
  //     final userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     print('signed in with GitHub: ${userCredential.user}');
  //   } catch (e) {
  //     print('Error signing in with GitHub: $e');
  //   }
  // }

  // Future<void> _launchGitHubSignIn() async {
  //   const clientId = 'Ov23liEHCw9cn5vKeUII';
  //   const redirectUri =
  //       'https://pmsn2024-87bbf.firebaseapp.com/__/auth/handler';
  //   const url =
  //       'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=read:user,user:email';
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

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

  // Future<void> signInGitHub(BuildContext context) async {
  //   try {
  //     final result = await FlutterWebAuth.authenticate(
  //       url:
  //           'https://github.com/login/oauth/authorize?client_id=Ov23liEHCw9cn5vKeUII&scope=read:user user:email',
  //       callbackUrlScheme: 'https',
  //     );

  //     final code = Uri.parse(result).queryParameters['code'];

  //     final response = await http.post(
  //       Uri.parse('https://github.com/login/oauth/access_token'),
  //       headers: {
  //         'Accept': 'application/json',
  //       },
  //       body: {
  //         'client_id': 'Ov23liEHCw9cn5vKeUII',
  //         'client_secret': '5142a9c2a9dc5e2a02d86fb7b40bf9f236bb8881',
  //         'code': code,
  //       },
  //     );

  //     final accessToken = jsonDecode(response.body)['acces_token'];

  //     final AuthCredential credential =
  //         GithubAuthProvider.credential(accessToken);
  //     final UserCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     print('Failed to sign in with GitHub: $e');
  //   }
  // }

  // Future<void> handleRedirectResult() async {
  //   try {
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.getRedirectResult();
  //     if (userCredential.user != null) {
  //       print('user signed in: ${userCredential.user}');
  //     }
  //   } catch (e) {
  //     print('Error handling redirect result: $e');
  //   }
  // }

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> signInGitHub(String accessToken) async {
  //   try {
  //     final githubAuthCredential = GithubAuthProvider.credential(accessToken);
  //     final userCredential =
  //         await _auth.signInWithCredential(githubAuthCredential);
  //     print('Usuario autenticado: ${userCredential.user}');
  //   } catch (e) {
  //     print('Erro al inciar sesión con Github: $e');
  //   }
  // }

  // void onClickGitHubLoginButton() async {
  //   const String url =
  //       'https://github.com/login/oauth/authorize?client_id=Ov23liEHCw9cn5vKeUII&scope=public_repo%20read:user%20user:email';
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     final bool launched = await launchUrl(
  //       uri,
  //       mode: LaunchMode.externalApplication,
  //     );
  //     if (!launched) {
  //       print('CANNOT LAUNCH THIS URL!');
  //     }
  //   } else {
  //     print('CANNON LAUnCH THIS URL');
  //   }
  // }

  bool isSignSuccess = false;

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
                  ElevatedButton(
                    onPressed: (() => signInGoogle()),
                    child: const Text('Sign In Google'),
                  ),
                  ElevatedButton(
                    onPressed: (() => signInFacebook()),
                    child: const Text('Sign In Facebook'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final GitHubSignIn gitHubSignIn = GitHubSignIn(
                          clientId: 'Ov23liEHCw9cn5vKeUII',
                          clientSecret:
                              '5142a9c2a9dc5e2a02d86fb7b40bf9f236bb8881',
                          redirectUrl:
                              'https://pmsn2024-87bbf.firebaseapp.com/__/auth/handler');
                      var result = await gitHubSignIn.signIn(context);

                      switch (result.status) {
                        case GitHubSignInResultStatus.ok:
                          print(result.token);
                          isSignSuccess = true;
                          setState(() {});
                          break;
                        case GitHubSignInResultStatus.cancelled:
                        case GitHubSignInResultStatus.failed:
                          print(result.errorMessage);
                          break;
                      }
                    },
                    child: const Text('Sign In GitHub'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('You have signed in or not'),
                      Text(
                        '$isSignSuccess',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
