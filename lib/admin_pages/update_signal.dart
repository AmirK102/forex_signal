import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/admin_pages/create_signal.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/controller/update_signal_controller.dart';
import 'package:package_panda/model/PackageModel.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';

import '../common_widget/MainInputFiled.dart';

class UpdateSignal extends StatelessWidget {
  UpdateSignal({super.key,});



  GlobalKey<FormState> formKey = GlobalKey();

  var controller = Get.put(UpdateSignalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: MainAppBar(appBarText: "Package Create")),
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Delete Warning!",
                            content:
                            Text("Do you want to delete this package?"),
                            onConfirm: () {
                              try {
                                FirebaseApi()
                                    .deletePackage(controller.data!.id!);
                                Get.back();
                                Get.back();
                              } catch (e) {
                                Get.back();
                              }
                            },
                            onCancel: () {});
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Gap(20.w),
                        MainDropdownPicker(
                          labelText: "Select Market",
                          initialValue: controller.selectedMarket.value ==
                              ""
                              ? null
                              : getPackage(
                              controller.selectedMarket.value),
                          options: [
                            "All",
                            "Crypto",
                            "Forex",
                            "Metals",
                            "Stocks",
                          ],
                          onChanged: (v) {
                            if (v == "Crypto") {
                              controller.selectedMarket.value =
                                  currencyType.crypto.name;
                            } else if (v == "Forex") {
                              controller.selectedMarket.value =
                                  currencyType.forex.name;
                            } else if (v == "Metals") {
                              controller.selectedMarket.value =
                                  currencyType.metal.name;
                            } else if (v == "Stocks") {
                              controller.selectedMarket.value =
                                  currencyType.stock.name;
                            } else {
                              controller.selectedMarket.value =
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
                        Gap(35.w),
                        MainInputFiled(
                          hints: "Enter Pair Name",
                          textEditingController: controller.pair,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter package title";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(25.w),
                        MainInputFiled(
                          hints: "Open Entry",
                          textEditingController: controller.openEntry,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter Open Entry";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(25.w),
                        MainInputFiled(
                          hints: "Stop Loss",
                          textEditingController: controller.stopLoss,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Stop Loss";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(30.w),

                        MainInputFiled(
                          hints: "TP1",
                          textEditingController: controller.tp1,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter TP1";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(30.w),
                        MainInputFiled(
                          hints: "TP2",
                          textEditingController: controller.tp2,
                          keyboardType: TextInputType.number,

                        ),
                        Gap(30.w),
                        MainInputFiled(
                          hints: "TP 3",
                          textEditingController: controller.tp3,
                          keyboardType: TextInputType.number,

                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Gap(30.w),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Obx(() {
                  controller.isSell.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: MainButton(
                          onTap: () {
                            controller.isSell.value = true;
                          },
                          buttonText: "Sell",


                          buttonColor: controller.isSell.value == true
                              ? AppColors
                              .mainColor
                              : AppColors.inActiveButtonTextColor,
                        ),
                      ),
                      Gap(10.w),
                      Expanded(
                        child: MainButton(
                          onTap: () {
                            controller.isSell.value = false;
                          },
                          buttonText: "Buy",


                          buttonColor: controller.isSell.value == false
                              ? AppColors
                              .mainColor
                              : AppColors.inActiveButtonTextColor,
                        ),
                      ),
                    ],
                  );
                }),
              ),


              Gap(10.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Obx(() {
                  controller.isSell.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MainButton(
                        onTap: () {
                          controller.status.value = "Running";
                        },
                        buttonText: "Running",


                        buttonColor: controller.status.value == "Running"
                            ? AppColors
                            .mainColor
                            : AppColors.inActiveButtonTextColor,
                      ),
                      Gap(10.w),
                      MainButton(
                        onTap: () {
                          controller.status.value = "Loss";
                        },
                        buttonText: "Loss",


                        buttonColor: controller.status.value == "Loss"
                            ? AppColors
                            .mainColor
                            : AppColors.inActiveButtonTextColor,
                      ),
                      Gap(10.w),
                      MainButton(
                        onTap: () {
                          controller.status.value = "Profit";
                        },
                        buttonText: "Profit",


                        buttonColor: controller.status.value == "Profit"
                            ? AppColors
                            .mainColor
                            : AppColors.inActiveButtonTextColor,
                      )
                    ],
                  );
                }),
              ),
              Gap(20.w),
              MainButton(
                  onTap: () {


                    formKey.currentState!.save();

                    if (!formKey.currentState!.validate()) {
                      showErrorMessage("Fill all form");
                      return;
                    }
                    if (controller.status == "") {
                      showErrorMessage("Select status");
                      return;
                    }

                    _showConfirmationBottomSheet(context);
                  },
                  buttonText: "Submit")
            ],
          ),
        ),
      ),
    );


  }


}


void _showConfirmationBottomSheet(BuildContext context) {
  var controller = Get.find<UpdateSignalController>();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      double width =
          MediaQuery
              .of(context)
              .size
              .width * 0.40; // Adjust as needed
      double height = Get.width * 0.60;
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              'Are you sure?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Gap(10.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await submitPackageData(controller);
                    // Handle 'Yes' button click
                    Navigator.pop(context); // Close the bottom sheet
                    // Add your logic for 'Yes'
                  },
                  child: Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle 'No' button click
                    Navigator.pop(context); // Close the bottom sheet
                    // Add your logic for 'No'
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> submitPackageData(UpdateSignalController controller) async {
  Map<String, dynamic> packageData = {

    "pair": controller.pair.text,
    "open_entru":controller.openEntry.text,
    "stop_loss":controller.stopLoss.text,
    "tp1":controller.tp1.text,
    "tp2":controller.tp2.text,
    "tp3":controller.tp3.text,
    "date_time": DateTime.now(),

    "status": controller.status.value,
    "market": controller.selectedMarket.value,
    "action": controller.isSell.value,
  };
  EasyLoading.show();
  await FirebaseApi().createSignal(packageData,
      id: controller.data == null ? null : controller.data!.id,
      isUpdate: controller.data != null);
  EasyLoading.dismiss();
  showErrorMessage(title: "Success", "Signal update complete");
}
