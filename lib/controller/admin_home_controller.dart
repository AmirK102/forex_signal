import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:package_panda/controller/home_page_controller.dart';

class AdminHomeLogic extends GetxController{

  RxString selectedButton="Signal".obs;
  RxString selectedMarketType= MarketType.all.name.obs;
  //MarketType.crypto.name.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    FirebaseMessaging.instance.subscribeToTopic("adminNotifications");
  }

}