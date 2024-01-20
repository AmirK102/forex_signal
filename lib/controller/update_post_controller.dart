import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_panda/model/TransactionModel.dart';

class UpdatePostController extends GetxController{

  RxString selectedImage= "".obs;

  RxString selectedCurencyType= "".obs;
  TextEditingController  title=TextEditingController();
  TextEditingController description=TextEditingController();
PostModel? data=Get.arguments;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    if(data!=null){
      selectedImage.value= data!.screenshot??"";
      title.text=data!.postTitle??"";
      description.text=data!.postDescription??"";
    }



  }

}