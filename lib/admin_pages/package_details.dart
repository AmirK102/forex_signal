import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/admin_pages/admin_home.dart';
import 'package:package_panda/admin_pages/create_package.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/controller/package_details_controller.dart';
import 'package:package_panda/model/TransactionModel.dart';
import 'package:package_panda/model/UserModel.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';
import 'package:package_panda/utilities/common_methods.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class PackageDetails extends StatelessWidget {
  PackageDetails({super.key, required this.simColor, required this.data});

  Color simColor;
  TransactionModel data;
  var ignor = false.obs;

  var controller = Get.put(PackageDetailsLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container() /*Column(
          children: [
            Row(
              children: [
                Expanded(child: MainAppBar(appBarText: "Package Confirm")),
                IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                          title: "Reject Warning!",
                          content: Text("Do you want to reject this package?"),
                          onConfirm: () async {
                            await FirebaseApi().changeRejectStatusForOrder(
                                data.id,
                                "আপনার অনুরোধটি বাতিল করা হয়েছে। আপনি ভুল ট্রানজেকশন ID দিয়েছেন",
                                data);
                            Get.back();
                          },
                          onCancel: () {});
                    },
                    icon: Icon(Icons.stop_circle))
              ],
            ),
            Expanded(
              child: StreamBuilder<TransactionModel?>(
                  stream: FirebaseApi().getForOrderUpdateStream(
                      data.id!,
                      FirebaseApi.userModel!.name!,
                      FirebaseApi.userModel!.uid!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      data = snapshot.data!;
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            Gap(10.w),
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                  color: simColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10.w)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  receiverInfo(data: data),
                                  paymentScreenshot(
                                      simColor: simColor,
                                      height: 145.w,
                                      width: 110.w,
                                      data: data),
                                ],
                              ),
                            ),
                            Gap(15.w),
                            if (data.status != "completed")
                              SizedBox(
                                height: 180.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Obx(() {
                                      return InkWell(
                                        onTap: () async {
                                          controller.screenshotPath.value =
                                              await CommonMethods().pickImage();
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 180.w,
                                              width: 140.w,
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppColors.offWhiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.w),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: AppColors
                                                            .shadowColor,
                                                        offset: Offset(0, 1),
                                                        blurRadius: 7)
                                                  ],
                                                  border: Border.all(
                                                      color: simColor,
                                                      width: 1.w)),
                                              child: controller.screenshotPath
                                                          .value ==
                                                      ""
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons.plus,
                                                          color: simColor,
                                                        ),
                                                        Gap(30.w),
                                                        SizedBox(
                                                          width: 100.w,
                                                          child: Text(
                                                            "স্ক্রীনশট আপলোড করুন",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color:
                                                                    simColor),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Image.file(File(controller
                                                      .screenshotPath.value)),
                                            ),
                                            if (controller
                                                    .screenshotPath.value !=
                                                "")
                                              Positioned.fill(
                                                child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: InkWell(
                                                        onTap: () {
                                                          controller
                                                              .screenshotPath
                                                              .value = "";
                                                        },
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .solidCircleXmark,
                                                          color: AppColors
                                                              .airtelColor,
                                                        ))),
                                              )
                                          ],
                                        ),
                                      );
                                    }),
                                    Gap(20.w),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MainButton(
                                          onTap: () async {
                                            if (data.status !=
                                                "paymentVerified") {
                                              showErrorMessage(
                                                  "Payment now verified. payment verify fast");
                                              return;
                                            }

                                            EasyLoading.show(
                                                status: "Checking...");

                                            if (await FirebaseApi()
                                                .setWorkingStatusForOrder(
                                                    data.id,
                                                    FirebaseApi.userModel?.name,
                                                    FirebaseApi
                                                        .userModel!.uid)) {
                                              EasyLoading.dismiss();
                                              var resSim =
                                                  await Get.defaultDialog(
                                                title: "Select SIM",
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      title: Text("SIM 1"),
                                                      onTap: () {
                                                        Get.back(
                                                            result:
                                                                1); // Return 1 for SIM 1
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: Text("SIM 2"),
                                                      onTap: () {
                                                        Get.back(
                                                            result:
                                                                2); // Return 2 for SIM 2
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (resSim == null) {
                                                return;
                                              } else {
                                                if (ignor.value) {
                                                  showErrorMessage(
                                                      "Already requested check and wait for 2 minutes");
                                                  return;
                                                }
                                                ignor.value = true;
                                                try {
                                                  var res = await UssdAdvanced
                                                      .sendUssd(
                                                          code: "*124#",
                                                          subscriptionId:
                                                              resSim);
                                                } on Exception catch (e) {
                                                  // TODO
                                                }

                                                print("res");
                                              }
                                            } else {
                                              showErrorMessage(
                                                  "Already Working.. Try another..");
                                            }
                                            EasyLoading.dismiss();
                                          },
                                          buttonText: "Send Offer",
                                          buttonColor: simColor,
                                        ),
                                        Gap(20.w),
                                        Text("Working \n${data.workingBy}"),
                                        MainButton(
                                          onTap: () async {
                                            if (controller
                                                    .screenshotPath.value ==
                                                "") {
                                              showErrorMessage(
                                                  "Upload offer screenshot for prof");
                                              return;
                                            }

                                            if (data.status !=
                                                "paymentVerified") {
                                              showErrorMessage(
                                                  "Payment now verified. payment verify fast");
                                              return;
                                            }
                                            if (await FirebaseApi()
                                                .isAllowSendUssd(
                                                    data.id,
                                                    FirebaseApi
                                                        .userModel!.uid!)) {
                                              showConfirmationDialog(
                                                  context, data);
                                            } else {
                                              showErrorMessage(
                                                  "You can't submit now. already working");
                                            }
                                          },
                                          buttonText: "Confirm",
                                          buttonColor: simColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            if (data.status == "completed")
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Order Confirm By\n${data.confirmDateTime}",
                                          style: TextStyle(
                                              fontSize: 16.w,
                                              color: AppColors.mainColor),
                                        ),
                                        ListTile(
                                          title:
                                              Text(data.orderConfirmBy!.name!),
                                          subtitle:
                                              Text(data.orderConfirmBy!.email!),
                                          isThreeLine: true,
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(data
                                                    .orderConfirmBy!
                                                    .profilePhoto!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(3.w),
                                        border: Border.all(
                                          width: 1.w,
                                          color:
                                              simColor ?? AppColors.mainColor,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: data.adminProfImage ?? "",
                                        height: 150.w,
                                        width: 100.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            Gap(15.w),
                            Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                    color: simColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10.w)),
                                child: packageInfo(data: data)),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                  color: simColor,
                                  borderRadius: BorderRadius.circular(10.w)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(5.w),
                                  Text(
                                    "Original Price: ${data.packageRate}",
                                    style: TextStyle(
                                        fontSize: 16.w,
                                        color: AppColors.whiteColor),
                                  ),
                                  Gap(5.w),
                                  Text(
                                    "Commission: ${data.commission}",
                                    style: TextStyle(
                                      fontSize: 16.w,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  Gap(5.w),
                                  Text(
                                    "Discount: ${data.discount}",
                                    style: TextStyle(
                                        fontSize: 16.w,
                                        color: AppColors.whiteColor),
                                  ),
                                  Gap(5.w),
                                  Text(
                                    "Earning: ${data.earnings}",
                                    style: TextStyle(
                                        fontSize: 16.w,
                                        color: AppColors.whiteColor),
                                  ),
                                  Gap(5.w),
                                  Text(
                                    "Cash out Charge: 0",
                                    style: TextStyle(
                                        fontSize: 16.w,
                                        color: AppColors.whiteColor),
                                  ),
                                  Text(
                                    "Revenue: ${data.revenue}",
                                    style: TextStyle(
                                        fontSize: 16.w,
                                        color: AppColors.whiteColor),
                                  ),
                                  Gap(5.w),
                                  Gap(5.w),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),*/
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to change the order status?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                var message =
                    "আপনার অর্ডার সফলভাবে পাঠানো হয়েছে। ধন্যবাদ আপনার আমাদের সাথে কাছাকাছি থাকার জন্য।";
                EasyLoading.show();
                await FirebaseApi().changeStatusForOrder(
                  "completed",
                  message,
                  data.id,
                  data,
                  adminProfImage: controller.screenshotPath.value,
                );
                EasyLoading.dismiss();
                Navigator.of(context)
                    .pop(); // Close the dialog after changing the status
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
