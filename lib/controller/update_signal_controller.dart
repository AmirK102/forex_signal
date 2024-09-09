import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_panda/model/PackageModel.dart';

class UpdateSignalController extends GetxController{

  RxString selectedMarket= "".obs;


  RxString selectedEntryType="".obs;

  RxString status="".obs;

  TextEditingController pair=TextEditingController();
  TextEditingController stopLoss=TextEditingController();
  TextEditingController tp1=TextEditingController();
  TextEditingController tp2=TextEditingController();
  TextEditingController tp3=TextEditingController();


  TextEditingController openEntry=TextEditingController();

  SignalModel? data=Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    data= Get.arguments;

    if(data!=null){
      selectedMarket.value= data!.market??"";
      selectedEntryType.value= data!.action!;
      status.value= data!.status??"";
      pair.text=data!.pair??"";
      tp1.text=data!.tp1??"";
      tp2.text=data!.tp2??"";
      tp3.text=data!.tp3??"";
      stopLoss.text=data!.stopLoss.toString();
      openEntry.text=data!.openEntru.toString();
    }
    print("data");
    print(data?.toJson());

  }

}