import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_panda/model/PackageModel.dart';
enum simType {all, robi, airtel, banglalink, gp }
enum packageType {bundle, minute, internet}
class CreatePackageLogic extends GetxController{

  RxString selectedSimType= "".obs;
  RxString selectedPackageType= "".obs;
  RxBool isBestDeal=false.obs;

  TextEditingController title=TextEditingController();
  TextEditingController price=TextEditingController();
  TextEditingController commission=TextEditingController();
  TextEditingController discount=TextEditingController();
  TextEditingController duration=TextEditingController();
  TextEditingController description=TextEditingController();

  PackageModel? data;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    data= Get.arguments;

    if(data!=null){
      selectedSimType.value= data!.sim??"";
      isBestDeal.value= data!.hotDeal??false;
      selectedPackageType.value= data!.packageType??"";
      title.text=data!.title??"";
      price.text=data!.price.toString();
      commission.text=data!.commission.toString();
      discount.text=data!.discount.toString();
      duration.text=data!.duration.toString();
      description.text=data!.description??"";

    }

  }

}