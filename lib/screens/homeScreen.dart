import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notificationswithfirebase/serveces/localNoti.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  getToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken();
    print('----------------------------------$myToken');
  }
  
  // حتى يظهر الاشعار في حالة التطبيق ان يكون مفتوح يجب استخدام ال local Notification
  // يتغير الtoken في كل مرة يتم حذف التطبيق واعادة تثبيته

  @override
  void initState() {
    
  NotificationWidget.init();
    //foreground message (https://firebase.flutter.dev/docs/messaging/usage)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('----------Got a message whilst in the foreground!');
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print('-------------------------------');
        NotificationWidget.showNotifications(
          title: '${message.notification!.title}',
          body: '${message.notification!.body}',
        );
      }
    });
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Notification With Firebase'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () async {
                await sendMessage('Hello My Friend', 'How Are you ??');
              },
              tooltip: 'Show notifications',
              child: const Icon(Icons.circle_notifications),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('notification'),
          ],
        ),
      ),
    );
  }
}

//بناء كود لإرسال الإشعارات باستخدام ال thunder client وذلك  بالاعتماد على الرابط التالي (https://stackoverflow.com/questions/37490629/firebase-send-notification-with-rest-api)
//ثم التحويل إلى لغة الdart
sendMessage(title, message) async {
  var headersList = {
    'Accept': '*/*',
    'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAA7gBDgU0:APA91bFsNeix-jPN1PLMGe8b4K8X4PIznZSyKyF71gYmO7n-l1CXO7gf9VvLt0-QPAPqaduM3Bblqoou9PNuKEPlT2Q4uud_0OFHP-gXlBHQ_njykxSV7-4Q2jzEap4Fq8v3mkHQy9pW'
  };
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

  var body = {
    "to":
        "faTvnHBZQdiAR8RWfu59UV:APA91bEvCuMY3BG-Ks-n0HSPJvuCWf0gfjRpa0PANmD3UPP-6guX05sEFgVe_iJ7fJ-6xg36itWhxQ3ISAfUt-ow4jbAN21Uf3G5poyv1nSEmkpT02j_tarMcqu3PjonKWJqgXFWKOCe",
    "notification": {
      "title": title,
      "body": message,
      "mutable_content": true,
      //"sound": sound
    }
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
