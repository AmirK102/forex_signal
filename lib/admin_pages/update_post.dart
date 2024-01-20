import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/admin_pages/create_signal.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/common_widget/MainInputFiled.dart';
import 'package:package_panda/controller/update_post_controller.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';
import 'package:package_panda/utilities/common_methods.dart';

class UpdatePost extends StatelessWidget {
   UpdatePost({super.key});
   var controller = Get.put(UpdatePostController());
   Map <String,dynamic> data={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MainAppBar(appBarText: "Update post"),

               Text("Market: ${controller.data!.market}",style: TextStyle(
                 color: AppColors.mainColor,
                 fontSize: 24.w,
                 fontWeight: FontWeight.w600
               ),
               ),
                Gap(20.w),
                if(controller.selectedImage.value!="")
                  SizedBox(
                      height: 100.w,
                      child: CachedNetworkImage(imageUrl: controller.selectedImage.value)),

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

                  data.addAll({
                    "post_title": controller.title.text,
                    "post_description": controller.description.text,
                  });
                  print(data);


                  EasyLoading.show(
                      maskType: EasyLoadingMaskType.black,
                      status: "Wait");


                  await FirebaseApi()
                      .updatePost(id: controller.data!.id,data: data);
                  EasyLoading.dismiss();
                  Get.back();

                }, buttonText: "Update")



              ],
            ),
          ),
        ),
      ),
    );
  }
}
