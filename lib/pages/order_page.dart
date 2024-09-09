import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_function/order_page_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/common_widget/MainInputFiled.dart';
import 'package:package_panda/controller/order_page_controller.dart';
import 'package:package_panda/model/PackageModel.dart';
import 'package:package_panda/model/PaymentMethod.dart';
import 'package:package_panda/pages/auth_pages/login_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';
import 'package:package_panda/utilities/common_methods.dart';

class OrderPage extends StatelessWidget {
  OrderPage({
    super.key, required this.signalData,
  });

  var controller = Get.put(OrderPageController(), tag: GlobalKey().toString());

  final SignalModel signalData;

  @override
  Widget build(BuildContext context) {
    TextStyle instructionTextStyle = TextStyle(
      color: AppColors.whiteColor,
      fontSize: 14.w,
    );

    FirebaseApi().getPaymentMethodsStream().listen((event) {});

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 40.w),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.mainColor,
                            width: 3.w
                        ),
                        borderRadius: BorderRadius.circular(10.w)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              signalData.pair??"",
                              style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontSize: 24.w,
                                  fontWeight: FontWeight.bold),
                            ),
                      /*      Text(
                              "10/02/24 12:34",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12.w,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400),
                            ),*/
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(       signalData.action!,      style: TextStyle(
                                color: AppColors.mainColor,
                                fontSize: 24.w,
                                fontWeight: FontWeight.bold),

                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                  Gap(5.w),
                  Text(
                    "Attention: Use only 1 to 2 % from your balance ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.robiColor,
                      fontSize: 18.w,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(5.w),
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.mainColor,
                        width: 3.w
                      ),
                      borderRadius: BorderRadius.circular(10.w)
                    ),
                    child: Column(
                      children: [
                        Container(

                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 1,
                              color: AppColors.mainColor
                            )
                          ),
                          child: Text("Open Entry: ${signalData.openEntru}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.w,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Gap(5.w),
                        Container(

                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: AppColors.airtelColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: AppColors.airtelColor
                              )
                          ),
                          child: Text("Stop loss: ${signalData.stopLoss}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.w,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Gap(5.w),
                        Center(child: Container(

                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.green
                              )
                          ),
                          child: Text("Take Profit 1: ${signalData.tp1!}",style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.w,
                              fontWeight: FontWeight.w600
                          ),),
                        )),
                        Gap(5.w),
                        if(signalData.tp2! !="")
                        Center(child: Container(

                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.green
                              )
                          ),
                          child: Text("Take Profit 2: ${signalData.tp2!}",style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.w,
                              fontWeight: FontWeight.w600
                          ),),
                        )),
                        Gap(5.w),
                        if(signalData.tp3! !="")
                        Center(child: Container(

                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.green
                              )
                          ),
                          child: Text("Take Profit 3: ${signalData.tp3!}",style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.w,
                              fontWeight: FontWeight.w600
                          ),),
                        )),
                      ],
                    ),
                  ),
                  Gap(10.w),
                  Text(
                      "Note: Please follow money management and take trades at  your own risk. Match mine with your own analysis do not take trade if you do not want to accept stop loss",
                      style: TextStyle(
                  color:AppColors.robiColor,
                      fontSize: 16.w,
                      fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic
                  ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

showErrorMessage(msg, {title = "একটা ভুল হয়েছে!"}) {
  if (!Get.isSnackbarOpen) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: AppColors.mainColor,
      duration: Duration(seconds: 5),
      colorText: Colors.white,
    );
  }
}
