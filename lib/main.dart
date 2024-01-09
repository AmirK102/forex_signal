import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_panda/admin_pages/admin_home.dart';
import 'package:package_panda/pages/get_started_page.dart';
import 'package:package_panda/push_notification.dart';
import 'package:package_panda/utilities/app_colors.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,


  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  pushNotification().setupFlutterNotifications();
  pushNotification().initPushNotificationListener();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,

      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return
          GetMaterialApp(
            title: 'Forx Signal',
            theme: ThemeData(

              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
              useMaterial3: true,
            ),

            home:  GetStarted(),
            builder: EasyLoading.init(
            ),
          );
      },

    );
  }
}

