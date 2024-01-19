import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_panda/model/PackageModel.dart';

class CreatePackageLogic extends GetxController{

  RxString selectedCurencyType= "".obs;

  RxBool isSell=false.obs;

  RxString status="".obs;

  TextEditingController pair=TextEditingController();
  TextEditingController stopLoss=TextEditingController();
  TextEditingController tp1=TextEditingController();
  TextEditingController tp2=TextEditingController();
  TextEditingController tp3=TextEditingController();


  TextEditingController openEntry=TextEditingController();

  SignalModel? data;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    data= Get.arguments;

    if(data!=null){
/*      selectedCurencyType.value= data!.sim??"";
      isBestDeal.value= data!.hotDeal??false;
      selectedAction.value= data!.packageType??"";
      pair.text=data!.title??"";
      stopLoss.text=data!.price.toString();
      commission.text=data!.commission.toString();
      discount.text=data!.discount.toString();
      openEntry.text=data!.duration.toString();
      description.text=data!.description??"";*/

    }

  }

}