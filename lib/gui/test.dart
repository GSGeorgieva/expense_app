// part of main.dart;
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('assets/finance.png');
//
//
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid);
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }
//
//   notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails('channelId', 'channelName',
//             importance: Importance.max));
//   }
//
//   Future showNotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return notificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }
//
//   Future scheduleNotification(
//       {int id = 0,
//       String? title,
//       String? body,
//       String? payLoad,
//       required DateTime scheduledNotificationDateTime}) async {
//     return notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.from(
//           scheduledNotificationDateTime,
//           tz.local,
//         ),
//         await notificationDetails(),
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }
// }
