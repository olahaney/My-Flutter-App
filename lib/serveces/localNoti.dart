import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationWidget {
  static final _notifications = FlutterLocalNotificationsPlugin();
  
  static Future init() async {
    AndroidInitializationSettings initAndroidSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    final settings = InitializationSettings(android: initAndroidSettings);
    await _notifications.initialize(settings);
  }
  
  static Future showNotifications(
      {var id = 0, required String title, body}) async {
    _notifications.show(id, title, body, await notificationDetails());
  }
}

notificationDetails() async {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'channel id 0', 'channel name',
      importance: Importance.max,
      //sound: RawResourceAndroidNotificationSound('noti')
    ),
  );
}
