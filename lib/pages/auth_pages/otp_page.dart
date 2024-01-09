import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/controller/otp_controller.dart';
import 'package:package_panda/pages/auth_pages/create_profile_page.dart';
import 'package:package_panda/utilities/app_colors.dart';
import 'package:pinput/pinput.dart';

class OtpSubmitPage extends StatelessWidget {
   OtpSubmitPage({super.key});

var controller=Get.put(OtpPageLogic());

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.mainColor/*Color.fromRGBO(234, 239, 243, 1)*/),
      borderRadius: BorderRadius.circular(20),
    ),
  );


/*

  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    borderRadius: BorderRadius.circular(8),
  );

  final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration.copyWith(
      color: Color.fromRGBO(234, 239, 243, 1),
    ),
  );*/



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainAppBar(appBarText: "ওটিপি সাবমিট"),
            Gap(15.w),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.w),
                child: Column(
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
                    Gap(30.w),

                    Text(
                      "ওটিপি দিন",
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 24.w,
                          fontWeight: FontWeight.bold),
                    ),

                    Gap(20.w),
                    Pinput(
                      length: 6,
                      controller: controller.pinController,
                      defaultPinTheme: defaultPinTheme,
                    //  focusedPinTheme: focusedPinTheme,
                      //submittedPinTheme: submittedPinTheme,
                      keyboardType: TextInputType.number,
                      androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                      validator: (s) {
                       // return s == '2222' ? null : 'Pin is incorrect';
                      },
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) {
                        controller.verifyOtp();
                        print(pin);
                       // Get.to(CreateProfilePage(isCreate: true,));
                      },
                    ),


                  ],
                ),
              ),
            ),
            MainButton(onTap: (){

              controller.verifyOtp();


            }, buttonText: "সাবমিট ওটিপি")
          ],
        ),
      ),
    );
  }
}
