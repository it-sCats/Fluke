import 'package:flukepro/components/cons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notificationPRovider extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initInfo() {
    var androidInitilier = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitilazition = DarwinInitializationSettings();

    var initSetting = InitializationSettings(
        android: androidInitilier, iOS: iosInitilazition);
    flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (details) async {
        try {
          if (details.payload != null && details.payload!.isNotEmpty) {
          } else {}
        } catch (e) {}
      },
    );
    FirebaseMessaging.onMessage.listen((message) async {
      //هذه الدالة الي حنخلينا نستمعو للإشعارات
      // print('----------*on message *-------------');
      // print(
      //     'on message:${message.notification!.title}/${message.notification!.body}');this was for testing
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          //this settings for handling the notifications when the app is in the foreground
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('dbfood', 'dbfood',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.max,
              playSound: false);
      NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: DarwinNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data['body']);
    });
  }
}
