import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flukepro/base.dart';
import 'package:flukepro/components/cons.dart';
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
