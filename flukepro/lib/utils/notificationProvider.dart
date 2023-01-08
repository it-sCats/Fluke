import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/base.dart';
import 'package:flukepro/components/cons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'SigningProvider.dart';

class notificationPRovider extends ChangeNotifier {
  String? deviceToken;
  GlobalKey<NavigatorState>? navigatorKey;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  requiesPremission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = NotificationSettings(
        alert: AppleNotificationSetting.enabled,
        announcement: AppleNotificationSetting.disabled,
        badge: AppleNotificationSetting.enabled,
        carPlay: AppleNotificationSetting.disabled,
        criticalAlert: AppleNotificationSetting.disabled,
        sound: AppleNotificationSetting.enabled,
        authorizationStatus: AuthorizationStatus.authorized,
        lockScreen: AppleNotificationSetting.enabled,
        notificationCenter: AppleNotificationSetting.disabled,
        showPreviews: AppleShowPreviewSetting.never,
        timeSensitive: AppleNotificationSetting.disabled);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('authorized');
    }
  }

  getToken() async {
    await FirebaseMessaging.instance
        .getToken()
        .then((value) => deviceToken = value);
    print('$deviceToken--------');
    siggning().saveTokenToDatabase(deviceToken);
  }

  initInfo(contxt) {
    var androidInitilier = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitilazition = DarwinInitializationSettings();

    var initSetting = InitializationSettings(
        android: androidInitilier, iOS: iosInitilazition);
    flutterLocalNotificationsPlugin.initialize(
      initSetting,
      // onDidReceiveBackgroundNotificationResponse: (details) async {
      //   if (details.payload != null && details.payload!.isNotEmpty) {
      //     Navigator.push(
      //         contxt,
      //         MaterialPageRoute(
      //           builder: (context) => base(
      //             onNotificationTap: 1,
      //           ),
      //         ));
      //   }
      // },
      onDidReceiveNotificationResponse: (details) async {
        try {
          if (details.payload != null && details.payload!.isNotEmpty) {
            Navigator.push(
                contxt,
                MaterialPageRoute(
                  builder: (context) => base(
                    onNotificationTap: 1,
                  ),
                ));
          } else {}
        } catch (e) {}
      },
    );
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
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
          AndroidNotificationDetails(channel.id, channel.name,
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

      if (message != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(siggning().loggedUser!.uid)
            .collection('notification')
            .doc(message!.data['eventId'])
            .set({
          'title': message!.notification!.title,
          'date': message.notification!.body,
          'creatorID': siggning().loggedUser!.uid,
          'creationDate': Timestamp.now()
        });
        final eventData = FirebaseFirestore.instance
            .collection('events')
            .doc(message.data['eventId'])
            .get();
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          //this settings for handling the notifications when the app is in the foreground
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(channel.id, channel.name,
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
      if (message != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(siggning().loggedUser!.uid)
            .collection('notification')
            .doc(message!.data['eventId'])
            .set({
          'title': message!.notification!.title,
          'date': message.notification!.body,
          'creatorID': siggning().loggedUser!.uid,
          'creationDate': Timestamp.now()
        });
        // navigatorKey?.currentState!.push(MaterialPageRoute(
        //   builder: (context) => base(
        //     onNotificationTap: 1,
        //   ),
        // ));
      }
    });
  }
}

sendPushToOrgnaizerNotification(
    String body, String title, field, eventId, createrId) async {
  final user = await FirebaseFirestore.instance
      .collection('users')
      .doc(createrId.toString().trim())
      .get();
  final userTokens = user.data()!['tokens'].last.toString();
  try {
    await http
        .post(
            Uri.parse(
                'https://fcm.googleapis.com/v1/projects/fluke-db/messages:send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'Bearer ya29.a0AX9GBdWrpODti7TDWt6eV0wXRnPrasf5iFE_pgsb8AA1WD9zcGZyVglUyGRzQVA5UKQWiUzt4vXh5b_ogDt0dkOTLtesZWyp0CbbxBt5Kbco7MOwhUcAoHes4mEliU_2Se8NsXJHHI8P717w12FvtvgmpvCaaCgYKAXcSARESFQHUCsbC6gTSlfxxcQLHWL9S73_EDA0163'
            },
            body: jsonEncode(<String, dynamic>{
              "message": {
                "token": userTokens,
                "notification": {"title": title, "body": body},
                "data": {
                  "click_action": "FLUTTER_NOTIFICATION_CLICK",
                  "creatorID": createrId,
                  "eventId": eventId
                }
              }
            }))
        .whenComplete(() => debugPrint('done Should send'));
  } catch (e) {
    print('erorr in pushing notifi:$e');
  }
}
