import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_panda/utilities/app_colors.dart';

class OrderPageController extends GetxController {

  TextEditingController transactionId= TextEditingController();
  TextEditingController phoneNumber= TextEditingController();
  RxString screenshotPath="".obs;
  RxString selectedPaymentMethod="".obs;
  var pageColor=Get.arguments;

  Map<String, dynamic> data={};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



}