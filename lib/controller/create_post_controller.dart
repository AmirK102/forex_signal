import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_panda/model/PackageModel.dart';

class CreatePostController extends GetxController{

  RxString selectedImage= "".obs;

  RxString selectedCurencyType= "".obs;
  TextEditingController  title=TextEditingController();
  TextEditingController description=TextEditingController();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();


  }

}