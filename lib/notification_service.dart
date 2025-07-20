import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_di_card/screens/contact/contact_details_screen.dart';
import 'package:my_di_card/screens/home_module/main_home_page.dart';
import 'package:my_di_card/utils/utility.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    Map<String, String> parsePayloadString(String payload) {
      final cleaned = payload.replaceAll('{', '').replaceAll('}', '');
      final parts = cleaned.split(',');

      final result = <String, String>{};

      for (var part in parts) {
        final kv = part.split(':');
        if (kv.length == 2) {
          final key = kv[0].trim();
          final value = kv[1].trim();
          result[key] = value;
        }
      }

      return result;
    }
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("response.datassssssss>>>${response.payload}");

        final data = parsePayloadString(response.payload ?? "");
        print("response.data>>>${data["type"]}");

        if(data["type"] == "contactAdd"){
          Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) =>
              ContactDetails(contactId:int.parse(data["id"].toString()) ?? 0 , tags: [],),));
        }else
        if(
            data["type"] == "groupSwitch" ||
            data["type"] == "addMemberGroup" ||
            data["type"] == "removeMemberGroup" ||
            data["type"] == "teamMemberAdd" ||
            data["type"] == "removeTeamMember" ||
            data["type"] == "teamRequest")
            {
          Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            CupertinoPageRoute(builder: (builder) => BottomNavBarExample(tabBarIndex: 3,)),
                (route) => false,
          );}
      },
    );
  }

  static void showNotification(RemoteMessage message) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _notificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(),
    );
  }
}
