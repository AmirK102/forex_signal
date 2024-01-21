import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/common_widget/MainInputFiled.dart';
import 'package:package_panda/controller/create_package_controller.dart';
import 'package:package_panda/controller/create_post_controller.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';
import 'package:package_panda/utilities/common_methods.dart';

import 'create_signal.dart';

class CreatePost extends StatelessWidget {
  CreatePost({super.key});

  var controller = Get.put(CreatePostController());

  Map<String,dynamic>data={};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MainAppBar(appBarText: "Create post"),

                MainDropdownPicker(
                  labelText: "Select Market",
                  initialValue: controller.selectedCurencyType.value ==
                      ""
                      ? null
                      : getPackage(
                      controller.selectedCurencyType.value),
                  options: [
                    "All",
                    "Crypto",
                    "Forex",
                    "Metals",
                    "Stocks",
                  ],
                  onChanged: (v) {
                    if (v == "Crypto") {
                      controller.selectedCurencyType.value =
                          currencyType.crypto.name;
                    } else if (v == "Forex") {
                      controller.selectedCurencyType.value =
                          currencyType.forex.name;
                    } else if (v == "Metals") {
                      controller.selectedCurencyType.value =
                          currencyType.metal.name;
                    } else if (v == "Stocks") {
                      controller.selectedCurencyType.value =
                          currencyType.stock.name;
                    } else {
                      controller.selectedCurencyType.value =
                          currencyType.all.name;
                    }
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Select Market";
                    } else {
                      return null;
                    }
                  },
                ),
                    Gap(20.w),
                Obx(() {
                  return Stack(
                    children: [
                      InkWell(
                        onTap: () async {
                          controller.selectedImage.value =
                          await CommonMethods().pickImage();
                        },
                        child: Container(
                          height: 150.w,
                          width: double.infinity,
                          decoration: BoxDecoration(

                              border: Border.all(
                                color: AppColors.mainColor,
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(10.w)
                          ),

                          child: controller.selectedImage.value == "" ? Center(
                              child: Text("Upload Image")) :
                  kIsWeb? Image.network(controller.selectedImage.value)  :Image.file(
                              File(controller.selectedImage.value)),
                        ),
                      ),
                      Positioned.fill(
                          child:
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: (){
                            controller.selectedImage.value="";
                          },
                          icon: Icon(Icons.close),
                        ),
                      )
                      )

                    ],
                  );
                }),
                    
                Gap(20.w),
                MainInputFiled(
                  hints: "Post Title",
                  textEditingController: controller.title,
                ),
                Gap(20.w),
                MainInputFiled(
                  hints: "Post Description",
                  maxLine: 8,
                  textEditingController: controller.description,
                    
                ),
                Gap(20.w),
                MainButton(onTap: () async {

                  if(controller.selectedCurencyType.value==""){
                    showErrorMessage("Select Market");
                    return;
                  }
                    
                  data.addAll({
                    
                    "post_title": controller.title.text,
                    "date_time": DateTime.now(),
                    
                    "post_description": controller.description.text,
                    "market": controller.selectedCurencyType.value,
                    "screenshot": controller.selectedImage.value,
                    "like":0,
                    "dislike":0
                  });
                  print(data);

                    
                  EasyLoading.show(
                      maskType: EasyLoadingMaskType.black,
                      status: "অপেক্ষা করুন");

                    
            await FirebaseApi()
                      .createOrder(data);
                  EasyLoading.dismiss();
                    
                }, buttonText: "Post")
                    
                    
                    
              ],
            ),
          ),
        ),
      ),
    );
  }
}
