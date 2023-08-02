import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance
  );

  final _localNotifPlugin = FlutterLocalNotificationsPlugin();


  Future<void> handleBackgroundMessage(RemoteMessage? msg) async{
    if(msg == null) return;
    print('AA ${msg.notification?.title}');
    print(msg.notification?.body);
    print(msg.data);
  }



  Future<void>initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token $fcmToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    await initPushNotifications();
    await initLocalNotification();
  }

  Future initLocalNotification() async{
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifPlugin.initialize(settings);
    final platform = _localNotifPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
}

  Future initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleBackgroundMessage); //handleMessage
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage); //handleMessage
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if(notification == null) return;
      _localNotifPlugin.show(notification.hashCode, notification.title, notification.body, NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@drawable/ic_launcher'
        ),
      ),
        payload: jsonEncode(event.toMap()),

      );
    });

  }
}