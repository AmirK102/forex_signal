import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/common_widget/MainInputFiled.dart';
import 'package:package_panda/controller/admin_home_controller.dart';
import 'package:package_panda/controller/create_package_controller.dart';
import 'package:package_panda/model/PackageModel.dart';
import 'package:package_panda/pages/home_page.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';

class CreatePackage extends StatelessWidget {
  CreatePackage({
    super.key,
  });

  var formKey = GlobalKey<FormState>();

  var controller = Get.put(CreatePackageLogic());

  getPacakge(value) {
    print("value==============");
    print(value);
    if (value == simType.gp.name) {
      return "গ্রামীন ফোন";
    }
    if (value == simType.banglalink.name) {
      return "বাংলালিংক";
    }
    if (value == simType.airtel.name) {
      return "এয়ারটেল";
    }
    if (value == simType.robi.name) {
      return "রবি";
    }

    return "";
  }

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
                          labelText: "Select Sim",
                          initialValue: controller.selectedSimType.value == ""
                              ? null
                              : getPacakge(controller.selectedSimType.value),
                          options: [
                            "সব সিম",
                            "রবি",
                            "এয়ারটেল",
                            "বাংলালিংক",
                            "গ্রামীন ফোন",
                          ],
                          onChanged: (v) {
                            if (v == "রবি") {
                              controller.selectedSimType.value =
                                  simType.robi.name;
                            } else if (v == "এয়ারটেল") {
                              controller.selectedSimType.value =
                                  simType.airtel.name;
                            } else if (v == "বাংলালিংক") {
                              controller.selectedSimType.value =
                                  simType.banglalink.name;
                            } else if (v == "গ্রামীন ফোন") {
                              controller.selectedSimType.value =
                                  simType.gp.name;
                            } else {
                              controller.selectedSimType.value =
                                  simType.all.name;
                            }
                          },
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Select Sim";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(25.w),
                        MainDropdownPicker(
                          labelText: "Select Type",
                          initialValue:
                              controller.selectedPackageType.value == ""
                                  ? null
                                  : controller.selectedPackageType.value,
                          options: [
                            packageType.bundle.name,
                            packageType.minute.name,
                            packageType.internet.name,
                          ],
                          onChanged: (v) {
                            controller.selectedPackageType.value = v ?? "";
                          },
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Select Type";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(35.w),
                        MainInputFiled(
                          hints: "Enter package title",
                          textEditingController: controller.title,
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
                          hints: "Enter package Duration",
                          textEditingController: controller.duration,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter package Duration";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(25.w),
                        MainInputFiled(
                          hints: "Enter package Price",
                          textEditingController: controller.price,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter package Price";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(25.w),
                        MainInputFiled(
                          hints: "Enter package Commission",
                          textEditingController: controller.commission,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Enter package Commission";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(25.w),
                        MainInputFiled(
                          hints: "How much you want to give discount",
                          textEditingController: controller.discount,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "আপনার নাম লিখুন";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Gap(25.w),
                        MainInputFiled(
                          hints: "Package Details",
                          textEditingController: controller.description,
                          /*validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Package details required";
                            } else {
                              return null;
                            }
                          },*/
                        ),
                        Gap(25.w),
                        Obx(() {
                          controller.isBestDeal.value;
                          return InkWell(
                            onTap: () {
                              controller.isBestDeal.value =
                                  !controller.isBestDeal.value;
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 16.w,
                                  width: 16.w,
                                  decoration: BoxDecoration(
                                      color: controller.isBestDeal.value
                                          ? AppColors.mainColor
                                          : AppColors.whiteColor,
                                      border: Border.all(
                                        color: AppColors.mainColor,
                                        width: 1.w,
                                      )),
                                ),
                                Gap(10.w),
                                Text(
                                  "Want to make it best deal?",
                                  style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ),
              Gap(30.w),
              MainButton(
                  onTap: () {
                    /*         if(controller.selectedSimType.value==simType.all.name||controller.selectedPackageType.value==""

              ||controller.title.text==""  ||controller.duration.text==""
                  ||controller.price.text==""
                  ||controller.commission.text==""
                  ||controller.discount.text==""

              ){
                showErrorMessage("Fill up all data");
                return;
              }*/

                    formKey.currentState!.save();
                    if (!formKey.currentState!.validate()) {
                      showErrorMessage("Fill all form");
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
  var controller = Get.find<CreatePackageLogic>();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      double width =
          MediaQuery.of(context).size.width * 0.40; // Adjust as needed
      double height = Get.width * 0.60;
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Column(
                children: [
                  Text(
                    "Earnings:${getEarnings(controller)}",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                  Text(
                    "Cash out charge:${getCashoutCharge(getDiscountPrice(controller))}",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                  Text(
                    "Revenue: ${getEarnings(controller) - getCashoutCharge(getDiscountPrice(controller))}",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
            Text(
              'Are you sure?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(width: width, height: height, child: ViewOfferItem()),
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

Future<void> submitPackageData(CreatePackageLogic controller) async {
  Map<String, dynamic> packageData = {
    "title": controller.title.text,
    "duration": int.parse(controller.duration.text),
    "price": getDiscountPrice(controller).toDouble(),
    "date_time": DateTime.now(),
    "package_rate": double.parse(controller.price.text),
    "commission": double.parse(controller.commission.text),
    "discount": double.parse(controller.discount.text),
    "earnings": getEarnings(controller).toDouble(),
    "revenue": (getEarnings(controller) -
            getCashoutCharge(getDiscountPrice(controller)))
        .toDouble(), // Assuming 6 is the cash out fee
    "status": "active",
    "sim": controller.selectedSimType.value,
    "package_type": controller.selectedPackageType.value,
    "hot_deal": controller.isBestDeal.value,
    "description": controller.description.text,
  };
  EasyLoading.show();
  await FirebaseApi().createPackage(packageData,
      id: controller.data == null ? null : controller.data!.id,
      isUpdate: controller.data != null);
  EasyLoading.dismiss();
  showErrorMessage(title: "Success", "Product create complete");
}

enum simType { all, robi, airtel, banglalink, gp }

class ViewOfferItem extends StatelessWidget {
  ViewOfferItem({
    super.key,
  });

  Color? simColor;
  final controller = Get.put(CreatePackageLogic());

  @override
  Widget build(BuildContext context) {
    simColor = getColor(controller.selectedSimType.value);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 4.w, color: simColor!),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.w),
                topLeft: Radius.circular(12.w),
                bottomLeft: Radius.circular(22.w),
                bottomRight: Radius.circular(14.w)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 2.0,
                offset: const Offset(0, 4),
              ),
            ],
            color: const Color(0xFFF8F8F8),
          ),
        ),
        Positioned.fill(
            child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Gap(5.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.w),
                  child: Text(
                    controller.title.text ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: simColor,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    // height: 100.w,
                    width: 95.w,
                    decoration: BoxDecoration(
                        color: simColor!.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.w)),
                    child: Center(
                      child: Text(
                        "মাত্র\n ${getDiscountPrice(controller)} ৳",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: simColor,
                            fontSize: 18.w,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                Gap(10.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
                  decoration: BoxDecoration(
                      color: simColor!.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.w)),
                  child: Text(
                    "${controller.duration.text} দিন",
                    style: TextStyle(
                        color: simColor,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Gap(10.w),
              ],
            )),

            // base on sim
            if (controller.selectedSimType.value == simType.airtel.name)
              Image.asset("asset/images/airtel.png"),
            if (controller.selectedSimType.value == simType.gp.name)
              Image.asset("asset/images/gp.png"),
            if (controller.selectedSimType.value == simType.banglalink.name)
              Image.asset("asset/images/banglalink.png"),
            if (controller.selectedSimType.value == simType.robi.name)
              Image.asset("asset/images/robi.png"),
          ],
        ))
      ],
    );
  }
}

getDiscountPrice(controller) {
  var mainPrice = double.parse(controller.price.text);
  var commission = double.parse(controller.commission.text);
  var discount = double.parse(controller.discount.text);
  var priceForUser = mainPrice - discount;

  return priceForUser;
}

getEarnings(controller) {
  var commission = double.parse(controller.commission.text);
  var discount = double.parse(controller.discount.text);
  var earnings = commission - discount;

  return earnings;
}

int getCashoutCharge(var price) {
  double percentage = 1.9;
  double result = price * percentage / 100;
  return result.round();
}
