import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notificationswithfirebase/firebase_options.dart';
import 'package:notificationswithfirebase/serveces/localNoti.dart';

import 'screens/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await NotificationServices.initializedNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}


//هذا التابع حصرا يجب ان يكون بال main وهو لتشغيل الإشعار بال background and terminated
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print('----------Got a message whilst in the background!');
    print(message.notification!.title);
    print(message.notification!.body);
    print('-------------------------------');
    NotificationWidget.showNotifications(
      title: '${message.notification!.title}',
      body: '${message.notification!.body}',
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //عند الضغط على الإشعار يتم التنقل إلى صفحة معينة

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade900),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
