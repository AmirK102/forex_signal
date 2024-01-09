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
  OrderPage({super.key, required this.data});

  final PackageModel data;

  var controller = Get.put(OrderPageController(), tag: GlobalKey().toString());

  @override
  Widget build(BuildContext context) {
    TextStyle instructionTextStyle = TextStyle(
      color: AppColors.whiteColor,
      fontSize: 14.w,
    );

    FirebaseApi().getPaymentMethodsStream().listen((event) {});

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MainAppBar(
                appBarText: "এখন অর্ডার করুন",
              ),
              Gap(20.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OrderPageButton(
                          onTap: () {},
                          buttonText: data.title ?? "",
                          buttonColor: controller.pageColor),
                    ),
                    if(data.description!="" && data.description!=null)
                    Gap(15.w),
                    if(data.description!="" && data.description!=null)
                    SizedBox(
                      width: double.infinity,
                      child: OrderPageButton(
                          onTap: () {},
                          buttonText: data.description ?? "",
                          buttonColor: controller.pageColor),
                    ),
                    Gap(15.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OrderPageButton(
                              onTap: () {},
                              buttonText:
                                  "মাত্র ${data.price!.toStringAsFixed(0)} ৳",
                              buttonColor: controller.pageColor),
                        ),
                        Gap(25.w),
                        Expanded(
                          child: OrderPageButton(
                              onTap: () {},
                              buttonText: "${data.duration} দিন",
                              buttonColor: controller.pageColor),
                        ),
                      ],
                    ),

                    Gap(15.w),
                    Container(
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                          color: controller.pageColor,
                          borderRadius: BorderRadius.circular(12.w)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "নির্দেশনা",
                              style:
                                  instructionTextStyle.copyWith(fontSize: 22.w),
                            ),
                          ),
                          Gap(5.w),
                          Center(
                            child: Container(
                              height: 1.w,
                              width: 50.w,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          Gap(10.w),
                          FirebaseApi.UserId != ""
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "১. নিচের নম্বরে সেন্ড মানি করুন ",
                                      style: instructionTextStyle,
                                    ),
                                    Text(
                                      "২. সেন্ড মানির স্ক্রীনশট আপলোড করুন  ",
                                      style: instructionTextStyle,
                                    ),
                                    Text(
                                      "৩. সেন্ড মানি ট্রান্সেকশন ID লিখুন  ",
                                      style: instructionTextStyle,
                                    ),
                                    Text(
                                      "৪. যে নম্বরে অফারটি পেতে চান সেই নম্বরটি লিখুন",
                                      style: instructionTextStyle,
                                    ),
                                    Text(
                                      "৫. কিছুক্ষন অপেক্ষা করুন আপনার অর্ডারকৃত প্যাকেজ টি কিচু সময় পরে এ পেয়ে যাবেন",
                                      style: instructionTextStyle,
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    "এই প্যাকেজ টি কেনার আগে লগইন করুন | এটি আপনার পেয়েমন্ট সম্পর্কিত কোনো সমস্যার সমাধানের জন্য এবং আপনার ট্রানসাকশান এর হিসাব রাখার জন্য জরুরি.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Gap(15.w),
                    StreamBuilder<List<PaymentMethod>>(
                        stream: FirebaseApi().getPaymentMethodsStream(),
                        builder: (context, snapshot) {
                          print("snapshot.error");
                          print(snapshot.hasError);

                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                clipBehavior: Clip.none,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data![index];
                                  return Container(
                                    margin: EdgeInsets.only(top: 15.w),
                                    width: double.infinity,
                                    child: OrderPageButton(
                                        onTap: () async {
                                          await Clipboard.setData(ClipboardData(
                                                  text: data.phone))
                                              .then((value) {
                                            showErrorMessage("সাকসেস!",
                                                title: "কপি করা হয়েছে");
                                            return;
                                          });
                                        },
                                        buttonText:
                                            "${data.phone} (${data.type})",
                                        isCopy: true,
                                        buttonColor: controller.pageColor),
                                  );
                                });
                          }
                          return Container(
                            child: Text("এখন কোনো পেমেন্ট সক্রিয় নেই",style: TextStyle(
                              color: controller.pageColor
                            ),),
                          );
                        }),
                    /* Gap(15.w),
                    SizedBox(
                      width: double.infinity,
                      child: OrderPageButton(
                          onTap: () async {
                            await Clipboard.setData(
                                    ClipboardData(text: "০১৯৫৬২২৪৪৪৪"))
                                .then((value) {
                              return;
                            });
                          },
                          isCopy: true,
                          buttonText: "০১৯৫৬২২৪৪৪৪ (বিকাশ)",
                          buttonColor: controller.pageColor),
                    ),*/
                    Gap(25.w),
                    if (FirebaseApi.UserId != "")
                      SizedBox(
                        //height: 146.w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return InkWell(
                                onTap: () async {
                                  controller.screenshotPath.value =
                                      await CommonMethods().pickImage();
                                },
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 215.w,
                                        width: 114.w,
                                        decoration: BoxDecoration(
                                            color: AppColors.offWhiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10.w),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColors.shadowColor,
                                                  offset: Offset(0, 1),
                                                  blurRadius: 7)
                                            ],
                                            border: Border.all(
                                                color: controller.pageColor,
                                                width: 1.w)),
                                        child: controller.screenshotPath.value ==
                                                ""
                                            ? Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.plus,
                                                    color: controller.pageColor,
                                                  ),
                                                  Gap(30.w),
                                                  SizedBox(
                                                    width: 100.w,
                                                    child: Text(
                                                      "স্ক্রীনশট\nআপলোড করুন ",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: controller
                                                              .pageColor),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(9.w),
                                              child: Image.file(File(
                                                  controller.screenshotPath.value,),fit: BoxFit.cover,),
                                            ),
                                      ),
                                    ),
                                    if (controller.screenshotPath.value != "")
                                      Positioned.fill(
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                                onTap: () {
                                                  controller.screenshotPath
                                                      .value = "";
                                                },
                                                child: FaIcon(
                                                  FontAwesomeIcons
                                                      .solidCircleXmark,
                                                  color: AppColors.airtelColor,
                                                ))),
                                      )
                                  ],
                                ),
                              );
                            }),
                            Gap(20.w),
                            Expanded(
                              //width: 100.w,
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MainDropdownPicker(
                                      labelText: "পেমেন্ট মেথড",
                                      options: [
                                        "Bkash",
                                        "Nagad"
                                      ],
                                      onChanged: (v){
                                        controller.selectedPaymentMethod.value=v??"";
                                      },
                                      validator: (v) {
                                        if (v == null || v == "") {
                                          return "পেমেন্ট মেথড নির্বাচন করতে হবে";
                                        }
                                        return null;
                                      },
                                    ),
                                    Gap(20.w),
                                    MainInputFiled(
                                      validator: (v) {
                                        if (v == null || v == "") {
                                          return "ট্রান্সেকশন ID দিতে হবে";
                                        }
                                        return null;
                                      },
                                      hints: "ট্রান্সেকশন ID",
                                      onChanged: (v) {
                                        controller.data
                                            .addAll({"transaction_id": v});
                                      },
                                    ),
                                    Gap(20.w),
                                    MainInputFiled(
                                      validator: (v) {
                                        if (v == null || v == "") {
                                          return "মোবাইল নম্বর দিতে হবে";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.phone,
                                      hints: "মোবাইল নম্বর",
                                      onChanged: (v) {
                                        controller.data
                                            .addAll({"offer_number": v});
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "যে নম্বরে প্যাকেজটি নিতে চান ঐ নম্বরটি লিখুন",
                                        style: TextStyle(
                                          color: controller.pageColor,
                                          fontSize: 12.w,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    Gap(25.w),
                    SizedBox(
                        width: Get.width * 0.6,
                        child: MainButton(
                          onTap: () async {
                            if (FirebaseApi.UserId == "") {
                              Get.to(() => LoginPage());

                              return;
                            }

                            controller.formKey.currentState!.save();
                            if (controller.formKey.currentState!.validate()) {
                              if (controller.screenshotPath.value.isEmpty) {
                                showErrorMessage("স্ক্রীনশট আপলোড করুন");
                                return;
                              }

                              controller.data.addAll({
                                "screenshot": controller.screenshotPath.value
                              });
                              controller.data.addAll({
                                "payment_method": controller.selectedPaymentMethod.value
                              });
                              controller.data.addAll({
                                "user_obj": FirebaseApi.userModel!.toJson()
                              });

                              EasyLoading.show(
                                  maskType: EasyLoadingMaskType.black,
                                  status: "অপেক্ষা করুন");

                              var map = data.toJson();
                              map.addAll(controller.data);

                              var res = await FirebaseApi()
                                  .createOrder(map, map["transaction_id"]);

                              if (res == false) {
                                showErrorMessage(
                                    "আপনার ট্রান্সেকশন ID (${controller.data["transaction_id"]}) ইতিমধ্যেই ব্যবহার করা হয়েছে");
                              } else {
                                ConfirmationPopUp();
                              }

                              EasyLoading.dismiss();
                            } else {
                              showErrorMessage(
                                  "ট্রান্সাকশন ID এবং মোবাইল নম্বর এবং পেমেন্ট মেথড  দিতে হবে");
                            }
                          },
                          buttonText: FirebaseApi.UserId != ""
                              ? "আবেদন করুন"
                              : "লগইন করুন",
                          buttonColor: controller.pageColor,
                        )),
                  ],
                ),
              ),
              Gap(30),
            ],
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

Future ConfirmationPopUp() {
  return Get.dialog(
    PopScope(
      canPop: false, // prevent dialog from closing on back press
      child: AlertDialog(
        title: Image.asset(
          "asset/images/congrats.png",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'আপনার অনুরোধটি গ্রহণ করা হয়েছে',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.w),
            ),
            Gap(15.w),
            Text(
              'অফার পেতে কিছুক্ষণ অপেক্ষা করুন, এটি আসছে আপনার জন্য একটি আশ্চর্যজনক অফার!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.w),
            ),
          ],
        ),
        actions: <Widget>[
          Center(
            child: MainButton(
              buttonText: "অপেক্ষা করুন",
              onTap: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false, // prevent dialog from closing on outside tap
  );
}
