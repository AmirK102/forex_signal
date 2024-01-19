import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_panda/admin_pages/create_package.dart';
import 'package:package_panda/admin_pages/create_post.dart';
import 'package:package_panda/admin_pages/package_details.dart';
import 'package:package_panda/admin_pages/package_view_page.dart' as adminPackage;
import 'package:package_panda/admin_pages/payment_methods.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/common_widget/MainInputFiled.dart';
import 'package:package_panda/controller/admin_home_controller.dart';
import 'package:package_panda/model/PackageModel.dart';
import 'package:package_panda/model/TransactionModel.dart';
import 'package:package_panda/pages/home_page.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';


class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});

  var controller = Get.put(AdminHomeLogic());

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Gap(10.w),
              SizedBox(
                  child: MainButtonSmall(
                    onTap: () {
                      Get.to(() => PaymentMethods());
                    },
                    buttonText: "Change Payment Method",
                  )),
              Gap(15.w),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      width: double.infinity,
                      child: MainButtonSmall(
                        onTap: () {
                          Get.to(() => CreatePackage());
                        },
                        buttonText: "Add Signal",
                        // isIcon: true,
                        icon: FontAwesomeIcons.plus,
                      ),
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: MainButtonSmall(
                        onTap: () {
                          Get.to(() => adminPackage.PackageViewPage());
                        },
                        buttonText: "Edit Signal",

                      ),
                    ),
                  ),
                ],
              ),
              Gap(15.w),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      width: double.infinity,
                      child: MainButtonSmall(
                        onTap: () {
                          Get.to(() => CreatePost());
                        },
                        buttonText: "Add Post",
                        // isIcon: true,
                        icon: FontAwesomeIcons.plus,
                      ),
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: MainButtonSmall(
                        onTap: () {
                          Get.to(() => adminPackage.PackageViewPage());
                        },
                        buttonText: "Edit Post",

                      ),
                    ),
                  ),
                ],
              ),


              Gap(15.w),
              /*    SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 8.w),
                child: Obx(() {
                  return Row(
                    children: [
                      MainButtonSmall(
                          onTap: () async {
                            controller.selectedButton.value = "paymentVerified";
                          },
                          buttonText: "Payment Verified",
                          buttonColor: controller.selectedButton.value !=
                                  "paymentVerified"
                              ? AppColors.inActiveButtonTextColor
                              : AppColors.airtelColor),
                      Gap(8.w),
                      MainButtonSmall(
                          onTap: () async {
                            controller.selectedButton.value = "pending";
                          },
                          buttonText: "Pending",
                          buttonColor:
                              controller.selectedButton.value != "pending"
                                  ? AppColors.inActiveButtonTextColor
                                  : AppColors.airtelColor),
                      Gap(8.w),
                      MainButtonSmall(
                          onTap: () async {
                            controller.selectedButton.value = "all";
                          },
                          buttonText: "All Transaction",
                          buttonColor: controller.selectedButton.value != "all"
                              ? AppColors.inActiveButtonTextColor
                              : AppColors.airtelColor),
                      Gap(8.w),
                      MainButtonSmall(
                          onTap: () async {
                            controller.selectedButton.value = "completed";
                          },
                          buttonText: "Completed",
                          buttonColor:
                              controller.selectedButton.value != "completed"
                                  ? AppColors.inActiveButtonTextColor
                                  : AppColors.airtelColor),
                    ],
                  );
                }),
              ),*/
              Gap(10.w),

              /*  SizedBox(
                height: 50.w,
                child: MainDropdownPicker(
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
                    "Metal",
                    "Stocks",
                  ],
                  onChanged: (v) {
                    if (v == "Crypto") {
                      controller.selectedCurencyType.value =
                          currencyType.crypto.name;
                    } else if (v == "Forex") {
                      controller.selectedCurencyType.value =
                          currencyType.forex.name;
                    } else if (v == "Metal") {
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
              ),*/

              SizedBox(
                height: 50.w,
                child: MainDropdownPicker(
                  labelText: "Select Market",

                  options: [
                    "All",
                    "Crypto",
                    "Forex",
                    "Metal",
                    "Stocks",
                  ],
                  onChanged: (v) {
                    if (v == "Crypto") {
                      controller.selectedMarketType.value =
                          currencyType.crypto.name;
                    } else if (v == "Forex") {
                      controller.selectedMarketType.value =
                          currencyType.forex.name;
                    } else if (v == "Metal") {
                      controller.selectedMarketType.value =
                          currencyType.metal.name;
                    } else if (v == "Stocks") {
                      controller.selectedMarketType.value =
                          currencyType.stock.name;
                    } else {
                      controller.selectedMarketType.value =
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
              ),

              Gap(10.w),
              Obx(() {
                controller.selectedButton.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MainButton(onTap: () {
                      controller.selectedButton.value="Signal";
                    }, buttonText: "Signal",

                        buttonColor: controller.selectedButton.value!="Signal"?AppColors.inActiveButtonColor:AppColors.mainColor,
                    ),
                    MainButton(onTap: () {
                      controller.selectedButton.value="Post";
                    }, buttonText: "Post",
                      buttonColor: controller.selectedButton.value!="Post"?AppColors.inActiveButtonColor:AppColors.mainColor,

                    ),
                  ],
                );
              }),

              /*   SizedBox(
                height: 45,
                child: Row(
                  children: [
                    Expanded(
                      child: MainInputFiled(
                        hints: "Enter Transaction Id",
                        textEditingController: textEditingController,
                      ),
                    ),
                    Gap(15.w),
                    MainButtonSmall(
                        onTap: () {
                          controller.selectedSimType.refresh();
                        },
                        buttonText: "Search")
                  ],
                ),
              ),*/
              Gap(10.w),
              Expanded(child: Obx(() {


                return StreamBuilder<List<SignalModel>>(
                    stream: FirebaseApi().getAllPackagesStream(
                      // ascending: controller.lowToHigh.value,
                      //packageType: controller.selectedPackageCategory.value,
                      marketType: controller.selectedMarketType.value == "all"
                          ? null
                          : controller.selectedMarketType.value,
                    ),
                    builder: (context, snapshot) {
                      print(snapshot.data);
                      print("snapshot.hasError");
                      print(snapshot.hasError);

                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  //Get.to(() => SignalCard(data: snapshot.data[index]));
                                },
                                child: SignalCard(data: snapshot.data![index]),
                              );
                            });
                      }
                      return Container();
                    });
              }))
            ],
          ),
        ),
      ),
    );
  }
}
/*
class ProductCard extends StatelessWidget {
  ProductCard({super.key, this.simTypeName, required this.data});

  Color? simColor;
  String? simTypeName;
  TransactionModel data;

  @override
  Widget build(BuildContext context) {
   // simColor = getColor(simTypeName);
    return Container(
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.symmetric(vertical: 5.w),
      decoration: BoxDecoration(
          color: simColor!.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(
            color: simColor!,
            width: 1.w,
          )),
      child: Column(
        children: [
          // base on sim
          if (simTypeName == simType.airtel.name)
            Image.asset(
              "asset/images/airtel.png",
              height: 40.w,
            ),
          if (simTypeName == simType.gp.name)
            Image.asset(
              "asset/images/gp.png",
              height: 40.w,
            ),
          if (simTypeName == simType.banglalink.name)
            Image.asset(
              "asset/images/banglalink.png",
              height: 40.w,
            ),
          if (simTypeName == simType.robi.name)
            Image.asset(
              "asset/images/robi.png",
              height: 40.w,
            ),
          Gap(10.w),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 25.w,
                ),
                Gap(5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "name",
                      style: TextStyle(fontSize: 16.w),
                    ),
                    Text(
                      "01612662500",
                      style: TextStyle(fontSize: 16.w),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(10.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: packageInfo(data: data)),
              receiverInfo(data: data),
            ],
          ),
          Gap(10.w),
          paymentScreenshot(simColor: simColor, data: data),
          Gap(10.w),
          if (data.status == "pending")
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  data.status ?? "",
                  style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor),
                ),
              ),
            ),
          if (data.status == "paymentVerified")
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  data.status ?? "",
                  style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor),
                ),
              ),
            ),
          if (data.status == "rejected")
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  data.status ?? "",
                  style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor),
                ),
              ),
            ),
          if (data.status == "completed")
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  data.status ?? "",
                  style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor),
                ),
              ),
            ),

          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(10)),
            child: Text(
              "Message: " + (data.message ?? ""),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.w,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainColorLow),
            ),
          ),
        ],
      ),
    );
  }
}

Container packageInfo({required TransactionModel data}) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(5.w),
        Text(
          data.title ?? "",
          style: TextStyle(fontSize: 16.w),
        ),
        Gap(5.w),
        Text(
          "${data.duration} days",
          style: TextStyle(fontSize: 16.w),
        ),
        Gap(5.w),
        Text(
          "${data.price} taka",
          style: TextStyle(fontSize: 16.w),
        ),
        Gap(5.w),
        Text(
          // "12/02/24 12:40 am",
          formatDateTime(data.confirmDateTime!),
          style: TextStyle(fontSize: 16.w, color: Colors.black),
        ),
        Gap(5.w),
      ],
    ),
  );
}*/

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('MM/dd/yy hh:mm a');
  return formatter.format(dateTime);
}

/*Container receiverInfo({required TransactionModel data}) {
  return Container(
    padding: EdgeInsets.all(15.w),
    decoration: BoxDecoration(
        color: AppColors.whiteColor, borderRadius: BorderRadius.circular(7.w)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Receiver info",
          style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.w600),
        ),
        Gap(5.w),
        InkWell(
          onTap: () async {
            await Clipboard.setData(
                    ClipboardData(text: data.transactionId ?? ""))
                .then((value) {
              showErrorMessage("Copied!", title: "Transaction ID");

              return;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w),
            decoration: BoxDecoration(border: Border.all()),
            child: Text(
              (data.transactionId ?? "") + " 📋",
              style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Gap(5.w),
        InkWell(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: data.offerNumber!))
                .then((value) {
              return;
            });
          },
          child: Text(
            data.offerNumber ?? "",
            style: TextStyle(fontSize: 16.w, fontWeight: FontWeight.w500),
          ),
        ),
        Gap(5.w),
        if (data.status == "pending")
          InkWell(
            onTap: () {
              var textEditingControllerMsg = TextEditingController();
              Get.defaultDialog(
                title: "Verify Payment",
                titleStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      "Amount:-   ${data.price}",
                      style: TextStyle(
                        fontSize: 14.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Transaction ID:-    ${data.transactionId}",
                      style: TextStyle(
                        fontSize: 14.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Gap(20.w),
                    MainInputFiled(
                      textEditingController: textEditingControllerMsg,
                      hints: "মেসেজ লিখুন (Optional)",
                    ),

                    Gap(10.w),

                    // Add more payment details as needed
                  ],
                ),
                contentPadding: EdgeInsets.all(16),
                textConfirm: "Confirm",
                textCancel: "Reject",
                confirmTextColor: Colors.white,
                cancelTextColor: Colors.red,
                buttonColor: AppColors.mainColor,
                onCancel: () {
                  print("Dialog canceled");
                  var rejectText =
                      "আপনার অনুরোধটি ব্যর্থ হয়েছে। পেমেন্ট ভেরিফিকেশন থেকে রিজেক্ট করা হয়েছে।";

                  if (textEditingControllerMsg.text.isNotEmpty) {
                    rejectText = textEditingControllerMsg.text;
                  }

                  FirebaseApi().changeStatusForOrder(
                      "rejected", rejectText, data.id, data);
                  Get.back();

                  showErrorMessage("Success!", title: "Payment Verification");
                },
                onConfirm: () {
                  print("Dialog confirmed");
                  var confirmText = "পেমেন্ট নিশ্চিতকরণ সফলভাবে সম্পন্ন হয়েছে।";
                  if (textEditingControllerMsg.text.isNotEmpty) {
                    confirmText = textEditingControllerMsg.text;
                  }

                  FirebaseApi().changeStatusForOrder(
                      "paymentVerified", confirmText, data.id, data);
                  Get.back();

                  showErrorMessage("Success!", title: "Payment Verification");

                  // Add your logic here for payment verification
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Text(
                "Verify Payment",
                style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor),
              ),
            ),
          ),
        if (data.status == "paymentVerified")
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Text(
                "Payment Verified",
                style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor),
              ),
            ),
          ),
        if (data.status == "rejected")
          InkWell(
            onTap: () {
              var textEditingControllerMsg = TextEditingController();
              Get.defaultDialog(
                title: "Verify Payment",
                titleStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      "Amount:-   ${data.price}",
                      style: TextStyle(
                        fontSize: 14.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Transaction ID:-    ${data.transactionId}",
                      style: TextStyle(
                        fontSize: 14.w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Gap(20.w),
                    MainInputFiled(
                      textEditingController: textEditingControllerMsg,
                      hints: "মেসেজ লিখুন (Optional)",
                    ),

                    Gap(10.w),

                    // Add more payment details as needed
                  ],
                ),
                contentPadding: EdgeInsets.all(16),
                textConfirm: "Confirm",
                textCancel: "Reject",
                confirmTextColor: Colors.white,
                cancelTextColor: Colors.red,
                buttonColor: AppColors.mainColor,
                onCancel: () {
                  print("Dialog canceled");
                  var rejectText =
                      "আপনার অনুরোধটি ব্যর্থ হয়েছে। পেমেন্ট ভেরিফিকেশন থেকে রিজেক্ট করা হয়েছে।";

                  if (textEditingControllerMsg.text.isNotEmpty) {
                    rejectText = textEditingControllerMsg.text;
                  }

                  FirebaseApi().changeStatusForOrder(
                      "rejected", rejectText, data.id, data);
                  Get.back();

                  showErrorMessage("Success!", title: "Payment Verification");
                },
                onConfirm: () {
                  print("Dialog confirmed");
                  var confirmText = "পেমেন্ট নিশ্চিতকরণ সফলভাবে সম্পন্ন হয়েছে।";
                  if (textEditingControllerMsg.text.isNotEmpty) {
                    confirmText = textEditingControllerMsg.text;
                  }

                  FirebaseApi().changeStatusForOrder(
                      "paymentVerified", confirmText, data.id, data);
                  Get.back();

                  showErrorMessage("Success!", title: "Payment Verification");

                  // Add your logic here for payment verification
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Text(
                "Payment Rejected",
                style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor),
              ),
            ),
          ),
        if (data.status == "completed")
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Text(
                "Completed",
                style: TextStyle(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                    color: AppColors.whiteColor),
              ),
            ),
          ),
      ],
    ),
  );
}*/

Container paymentScreenshot(
    {simColor, height, width, required TransactionModel data}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          width: 1.w,
          color: simColor ?? AppColors.mainColor,
        )),
    child: CachedNetworkImage(
      imageUrl: data.screenshot ?? "",
      height: height ?? 100.w,
      width: width ?? 100.w,
      fit: BoxFit.cover,
    ),
  );
}
