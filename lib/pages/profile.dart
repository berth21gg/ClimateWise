import 'package:climate_wise/providers/db_provider.dart';
import 'package:climate_wise/settings/theme_controller.dart';
import 'package:climate_wise/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  final ThemeController themeController = Get.find();
  bool isLoading = false;

  signOut() async {
    setState(() {
      isLoading = true;
    });
    final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      await FacebookAuth.instance.logOut();
    }
    await GoogleSignIn().signOut();

    await FirebaseAuth.instance.signOut();
    setState(() {
      isLoading = false;
    });
    print(isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Card(
                      surfaceTintColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Color(0xFFCFD8DC)
                              : Color(0xFF455A64),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: !user!.providerData.any(
                                      (info) => info.providerId == 'password')
                                  ? NetworkImage(user?.photoURL ?? '')
                                  : const AssetImage('assets/user_profile.png')
                                      as ImageProvider,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.displayName ?? 'User Name',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.email ?? 'email@test.com',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[300]
                                            : Colors.grey[600],
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            if (user?.providerData.any(
                                    (info) => info.providerId == 'password') ??
                                false)
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit))
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Settings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        !themeController.isDarkMode.value
                            ? Icons.nightlight_outlined
                            : Icons.wb_sunny_outlined,
                        color: themeController.isDarkMode.value
                            ? Colors.amber
                            : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(!themeController.isDarkMode.value
                              ? 'Night Mode'
                              : 'Light Mode')),
                      Switch(
                        inactiveThumbColor: Colors.blue[600],
                        inactiveTrackColor: Colors.grey[200],
                        activeTrackColor: const Color(0xFF455A64),
                        activeColor: Colors.amber[600],
                        value: themeController.isDarkMode.value,
                        onChanged: (value) {
                          themeController.toggleTheme();
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Divider(
                        thickness: 1, height: 1, color: Colors.grey[600]),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.exit_to_app),
                      const SizedBox(width: 10),
                      const Expanded(child: Text('Logout')),
                      IconButton(
                          onPressed: () async {
                            await DBProvider.db.deleteAllUser();
                            signOut();
                            Get.offAll(() => const Wrapper());
                          },
                          icon: const Icon(Icons.logout)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(32)),
                          child: const Text(
                            'Signed in with',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: AssetImage(_getProviderLogo(
                                      user?.providerData[0].providerId ?? '')),
                                  fit: BoxFit.cover)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blueAccent[400],
              shape: CircleBorder(),
              onPressed: (() => Get.back()),
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          );
  }

  _getProviderLogo(String providerId) {
    switch (providerId) {
      case 'google.com':
        return 'assets/google_logo.jpg';
      case 'facebook.com':
        return 'assets/facebook_logo.png';
      case 'github.com':
        return 'assets/github_logo.png';
      case 'password':
        return 'assets/email_logo.png';
    }
  }
}
