import 'package:climate_wise/pages/profile.dart';
import 'package:climate_wise/widgets/custom_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;

  signOut() async {
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      await FacebookAuth.instance.logOut();
    }
    await GoogleSignIn().signOut();

    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Text('${user!.email}'),
                Text('${user!.displayName}'),
                Text('${user!.photoURL}'),
                Text(user!.providerData[0].providerId)
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 120,
            padding: const EdgeInsets.all(20),
            child: CustomBottomBar(
                color: Colors.blue,
                onTapProfile: (() => Get.to(() => const Profile())),
                onTapExit: (() => signOut())),
          )
        ],
      ),
    );
  }
}
