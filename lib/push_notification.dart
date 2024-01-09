import 'dart:async';
import 'dart:convert';

import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart' as getx;
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ///
  pushNotification().showSimpleNotification(message);

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

class pushNotification {
  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel? channel;
  var placeHolderAppLogoImage = "";

  var _token = "";

  var currentInitTime = DateTime.now();

  bool isFlutterLocalNotificationsInitialized = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isFlutterLocalNotificationsInitialized = true;
  }

  Future<AndroidBitmap<Object>?> _getAndroidBitmapFromUrl(String url) async {
    print(url);

    try {
      final Response response = await Dio().get<List<int>>(url,
          options: Options(responseType: ResponseType.bytes));

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        AndroidBitmap<Object> androidBitmap =
            ByteArrayAndroidBitmap(response.data);
        return androidBitmap;
      } else {
        // If the request failed, return null or handle the error as needed
        return null;
      }
    } catch (e) {
      // Handle any exceptions that might occur during the request
      print('Error: $e');
      return null;
    }
  }

  showSimpleNotification(RemoteMessage notificationMsg) async {
    print("notification.data");
    print(notificationMsg.toMap());
    print(notificationMsg.data);

    var notification = CustomPushNotification.fromJson(notificationMsg.data);

    var profileImage = (await _getAndroidBitmapFromUrl(
        notification.imageUrl ?? placeHolderAppLogoImage));

    var bigImage = (await _getAndroidBitmapFromUrl(
        notification.bigImage ?? placeHolderAppLogoImage));

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.message,
      NotificationDetails(
        android: AndroidNotificationDetails(
            notification.channelId!, "High Importance Notifications",
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: "ic_bg_service_small",
            styleInformation: bigImage == null
                ? null
                : BigPictureStyleInformation(
                    bigImage,
                    largeIcon: profileImage,
                    hideExpandedLargeIcon: false,
                    contentTitle: notification.title ?? "",
                    htmlFormatContentTitle: true,
                    summaryText: notification.message,
                  ),
            priority: Priority.max),
      ),
      payload: jsonEncode(notification),
    );
  }

  initPushNotificationListener() {
    getToken();
    //app open
    FirebaseMessaging.instance.getInitialMessage().then(
      (value) {
        print(
            "value?.data.toString()=====================================getInitialMessage");

        print(value);
      },
    );

    currentInitTime = DateTime.now();
    FirebaseMessaging.onMessage.listen(showSimpleNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(
          "value?.data.toString()=====================================onMessageOpenedApp");
      print(message.data);
      showSimpleNotification(message);
    });
  }

  getToken() {
    FirebaseMessaging.instance.getToken().then(setToken);
    Stream<String> _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    //_tokenStream.listen(setToken);
  }

  Future<void> setToken(String? token) async {
    print('FCM Token: $token');
    _token = token!;

    await FirebaseMessaging.instance.subscribeToTopic("generalNotifications");

   // await Future.delayed(Duration(seconds: 3));
   /* await sendPushMessage(
      token: "generalNotifications", //FirebaseMessaging.instance.subscribeToTopic("generalNotifications");
      title: "title of no",
      message: "message",
      imageUrl:
          "https://as2.ftcdn.net/v2/jpg/06/05/84/99/1000_F_605849984_XnHh0EiaRHB1B0meTs1pWx9PIPAmNOsU.jpg",
      senderAvaterUrl:
          "https://t4.ftcdn.net/jpg/00/91/24/17/240_F_91241738_y1y50vmBrGZPvkbyCPf9nEhX7bOUFs74.jpg",
    );*/

    //@todo set user token here

    /*  Timer.periodic(Duration(seconds: 10), (t) {
      sendPushMessage("dsadse", "dsfd", token, placeHolderCoverImage,
          placeHolderProfileImage, "${AppData.user!.user!.id!}", "");
      t.cancel();
    });*/
  }
}

clickNotification(NotificationResponse notificationResponse) async {
  var data = notificationResponse.payload;

  if (data == null || data == "") {
    return;
  }

/*  var notification = MessageNotificationModel.fromJson(jsonDecode(data));

  if (notification.type == "push_message") {
    await getx.Get.toNamed(Routes.chatListRoute);
  }*/
}

Future<void> sendPushMessage(
    {title,
    message,
    imageUrl,
    senderAvaterUrl,
    token}) async {
  print('message sending');

  try {
    var res = await Dio().post('https://fcm.googleapis.com/fcm/send',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAA6VKRbaE:APA91bE5ypNPDHFAThPZzug8Yis3Lducc6Ki_HBA4upNiudu99i3-c5dK8uXfGpyAB8dbYvUDf6NzHkooG83QP3FKMtN2FKRTKVD9nKLvfyFCTmCBAiDCF1KDIsgluy_yrR_9SxgQpMi',
          },
        ),
        data: {
          "data": {
            "message": message,
            "title": title,
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "channel_id": "high_importance_channel",
            "imageUrl": "$senderAvaterUrl",
            "bigImage": "$imageUrl",
            "priority": "high",
            "type": "push_message",
          },
          "priority": "normal",
          "to": "/topics/$token"
        });
    print(res.data);
    print('FCM request for device sent!');
  } on DioError catch (e) {
    print(e.response!.data);
    print(e);
  }
}

class CustomPushNotification {
  final String? message;
  final String? title;
  final String? messageId;
  final String? conversionId;
  final String? clickAction;
  final String? channelId;
  final String? imageUrl;
  final String? bigImage;
  final String? priority;
  final String? type;
  final String? senderUserId;

  CustomPushNotification({
    this.message,
    this.title,
    this.messageId,
    this.conversionId,
    this.clickAction,
    this.channelId,
    this.imageUrl,
    this.bigImage,
    this.priority,
    this.type,
    this.senderUserId,
  });

  factory CustomPushNotification.fromJson(Map<String, dynamic> json) {
    return CustomPushNotification(
      message: json['message'],
      title: json['title'],
      messageId: json['messageId'],
      conversionId: json['conversionId'],
      clickAction: json['click_action'],
      channelId: json['channel_id'],
      imageUrl: json['imageUrl'],
      bigImage: json['bigImage'],
      priority: json['priority'],
      type: json['type'],
      senderUserId: json['sender_user_id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'title': title,
      'messageId': messageId,
      'conversionId': conversionId,
      'click_action': clickAction,
      'channel_id': channelId,
      'imageUrl': imageUrl,
      'bigImage': bigImage,
      'priority': priority,
      'type': type,
      'sender_user_id': senderUserId,
    };
  }
}
