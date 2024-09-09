import 'package:advanced_shadows/advanced_shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/common_widget/MainInputFiled.dart';
import 'package:package_panda/controller/login_page_controller.dart';
import 'package:package_panda/pages/auth_pages/create_profile_page.dart';
import 'package:package_panda/pages/auth_pages/otp_page.dart';
import 'package:package_panda/pages/home_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  var controller = Get.put(LoginPageLogic());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "asset/images/logo.png",
                        height: 150.w,
                        width: 150.w,
                        color: AppColors.mainColor,
                      ),
                      Gap(5.w),
                      Text(
                        "Package Panda",
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 24.w,
                            fontWeight: FontWeight.bold),
                      ),
                      Gap(30.w)
                    ],
                  ),
                  Gap(10.w),
               /*   Container(
                    width: 1.sw * 0.7,
                    child: MainInputFiled(
                      textEditingController: controller.phoneNumberController,
                      hints: "মোবাইল নম্বর লিখুন",
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Gap(25.w),
                  MainButton(
                    onTap: () async {
                      EasyLoading.show();
                      await controller.phoneAuth();
                    },
                    buttonText: "সেন্ড OTP",
                  ),*/
                ],
              ),
              Column(
                children: [
        /*          Text(
                    "অথবা",
                    style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 18.w,
                        fontWeight: FontWeight.bold),
                  ),
                  Gap(10.w),*/
                  MainButton(
                    onTap: () async {
                      FirebaseApi firebaseApi = FirebaseApi();
                      var res = await firebaseApi.handleSignInGoogle();

                      print("fdfdf: $res");

                      if (res) {
                        var resUSer = await firebaseApi.isUserExist(
                            firebaseApi.googleSignIn.currentUser!.id);

                        if (resUSer) {
                          Get.offAll(() => HomePage());
                        } else {
                          Get.to(() => CreateProfilePage());
                        }
                      } else {
                        Get.snackbar("Error", "Error sign in. try again");
                      }

                      print("ontatp");
                      //  Get.to(() => CreateProfilePage());
                    },
                    buttonText: "গুগলের সাহায্যে লগইন",
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
