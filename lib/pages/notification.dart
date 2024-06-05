import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const route = '/notification-screen';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Lottie.asset('assets/animations/notification2.json',
                  width: 210, height: 210),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: '${message.notification?.title}',
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Center(
                child: Text(
                  '${message.notification?.body}',
                ),
              ),
            ),
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
                          ..onTap = (() => Get.back()))),
              ),
            ),
            // Text('${message.notification?.title}'),
            // Text('${message.notification?.body}'),
            // Text('${message.data}'),
          ],
        ),
      ),
    );
  }
}
