import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/admin_pages/create_package.dart' as editPackage;
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/controller/home_page_controller.dart';
import 'package:package_panda/model/PackageModel.dart';
import 'package:package_panda/pages/auth_pages/create_profile_page.dart';
import 'package:package_panda/pages/auth_pages/login_page.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:package_panda/pages/transaction_history.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';

import '../pages/home_page.dart';
import 'admin_home.dart' as admin;

class PackageViewPage extends StatelessWidget {
  PackageViewPage({super.key});

  var controller = Get.put(HomePageLogic(), tag: GlobalKey().toString());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 5.w,
              left: 20.w,
              right: 20.w),
          child: CustomScrollView(
            // clipBehavior: Clip.none,
            slivers: [
              SliverAppBar(
                snap: false,
                 automaticallyImplyLeading: false,
                pinned: true,
                backgroundColor: Colors.white,
                collapsedHeight: 145.w,
                expandedHeight: 150.w,
                actions: <Widget>[Container()],
                flexibleSpace: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      MainDropdownPicker(
                        labelText: "একটি সিম বাছাই করুন",
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
                            controller.selectedSimType.value = simType.gp.name;
                          } else {
                            controller.selectedSimType.value = simType.all.name;
                          }
                        },
                      ),
                      Gap(15.w),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MainButton(
                                onTap: () {
                                  controller.selectedPackageCategory.value =
                                      "bundle";
                                },
                                buttonText: "বান্ডেল",
                                buttonColor:
                                    controller.selectedPackageCategory.value ==
                                            "bundle"
                                        ? AppColors.mainColor
                                        : AppColors.inActiveButtonTextColor
                                            .withOpacity(0.8)),
                            MainButton(
                                onTap: () {
                                  controller.selectedPackageCategory.value =
                                      "minute";
                                },
                                buttonText: "মিনিট",
                                buttonColor:
                                    controller.selectedPackageCategory.value ==
                                            "minute"
                                        ? AppColors.mainColor
                                        : AppColors.inActiveButtonTextColor
                                            .withOpacity(0.8)),
                            MainButton(
                                onTap: () {
                                  controller.selectedPackageCategory.value =
                                      "internet";
                                },
                                buttonText: "নেট",
                                buttonColor:
                                    controller.selectedPackageCategory.value ==
                                            "internet"
                                        ? AppColors.mainColor
                                        : AppColors.inActiveButtonTextColor
                                            .withOpacity(0.8)),
                          ],
                        );
                      }),
                      Gap(15.w),
                      Obx(() {
                        return InkWell(
                          onTap: () {
                            controller.lowToHigh.value =
                                !controller.lowToHigh.value;
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller.lowToHigh.value
                                    ? "দাম: কম থেকে বেশি"
                                    : "দাম: বেশি থেকে কম",
                                style: TextStyle(
                                    color: AppColors.mainColor,
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w500),
                              ),
                              Gap(5.w),
                              FaIcon(
                                FontAwesomeIcons.circleArrowDown,
                                color: AppColors.mainColor,
                                size: 12.w,
                              )
                            ],
                          ),
                        );
                      }),
                      //Gap(10.w),
                    ],
                  ),
                ),
              ),
              Obx(() {
                controller.selectedSimType.value;
                return StreamBuilder<List<PackageModel>>(
                    stream: FirebaseApi().getAllPackagesStream(
                      ascending: controller.lowToHigh.value,
                      packageType: controller.selectedPackageCategory.value,
                      sim: controller.selectedSimType.value == "all"
                          ? null
                          : controller.selectedSimType.value,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<PackageModel>? data = snapshot.data;

                        return SliverGrid.builder(
                          itemCount: data!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15.w,
                                  mainAxisSpacing: 30.w,
                                  childAspectRatio: 0.60),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Get.to(() => editPackage.CreatePackage(),
                                    arguments: data[index]);
                              },
                              child: ViewOfferItem(
                                simTypeName: data[index].sim,
                                data: data[index],
                              ),
                            );
                          },
                        );
                      }
                      return SliverToBoxAdapter();
                    });
              }),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 10.w,
              )),
            ],
          ),
        );
      }),
    );
  }
}

getColor(simTypeName) {
  print(simTypeName);
  if (simTypeName == simType.airtel.name) return AppColors.airtelColor;
  if (simTypeName == simType.gp.name) return AppColors.grameenCOlor;
  if (simTypeName == simType.banglalink.name) return AppColors.banglalinkColor;
  if (simTypeName == simType.robi.name) return AppColors.robiColor;
  return AppColors.grameenCOlor;
}


class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.controller,
  });

  final HomePageLogic controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset("asset/icons/photo_border.svg",
            height: 110.w, width: 110.w, semanticsLabel: 'Logo'),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Obx(() {
                if (controller.profileImage.value == "") {
                  return Image.asset(
                    controller.userGender.value == "male"
                        ? "asset/images/male.png"
                        : "asset/images/female.png",
                  );
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10000),
                  child: FirebaseApi.userModel != null
                      ? CachedNetworkImage(
                          imageUrl: FirebaseApi.userModel!.profilePhoto ?? "",
                          height: 75.w,
                          width: 75.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            FirebaseApi.userModel!.gender == "male"
                                ? "asset/images/male.png"
                                : "asset/images/female.png",
                            height: 75.w,
                            width: 75.w,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          "asset/images/male.png",
                          height: 75.w,
                          width: 75.w,
                          fit: BoxFit.cover,
                        ),
                );
              })),
        ),
      ],
    );
  }
}
