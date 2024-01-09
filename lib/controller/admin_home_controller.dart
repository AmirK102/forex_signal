import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
enum simType {all, robi, airtel, banglalink, gp }
class AdminHomeLogic extends GetxController{

  RxString selectedButton="paymentVerified".obs;
  RxString selectedSimType= simType.all.name.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    FirebaseMessaging.instance.subscribeToTopic("adminNotifications");
  }

}