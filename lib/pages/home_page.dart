import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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

import '../admin_pages/admin_home.dart' as admin;

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var controller = Get.put(HomePageLogic(), tag: GlobalKey().toString());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        width: Get.width * 0.7,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                  child: Column(
                children: [
                  Image.asset(
                    "asset/images/logo.png",
                    height: 80.w,
                    width: 80.w,
                    color: AppColors.whiteColor,
                  ),
                  Text(
                    'প্যাকেজ পান্ডা',
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 20.w,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              )),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
              ),
            ),
            FutureBuilder(
                future: FirebaseApi().isAdmin(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  if (snapshot.data == true) {
                    return ListTile(
                      title: Text('Admin'),
                      onTap: () {
                        // Update the state of the app
                        // Then close the drawer
                        Get.offAll(admin.AdminHomePage());
                      },
                    );
                  }
                  return Container();
                }),
            if (FirebaseApi.UserId == "")
              ListTile(
                title: Text('লগইন'),
                onTap: () {
                  // Update the state of the app
                  // Then close the drawer
                  Get.to(LoginPage());
                },
              ),
            ListTile(
              title: Text('আপডেট প্রোফাইল'),
              onTap: () async {
                if (FirebaseApi.UserId == "") {
                  Get.to(() => LoginPage());
                  return;
                }

                Get.to(() => CreateProfilePage(
                      isCreate: false,
                    ));
              },
            ),
            ListTile(
              title: Text('ট্রানস্যাকশন হিস্টোরি'),
              onTap: () {
                if (FirebaseApi.UserId == "") {
                  Get.to(() => LoginPage());
                  return;
                }

                Get.to(() => HistoryPage());
              },
            ),
            ListTile(
              title: Text('ব্যবহার বিধি'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
              },
            ),
            if (FirebaseApi.UserId != "")
              ListTile(
                title: Text('লগ আউট'),
                onTap: () {
                  FirebaseMessaging.instance
                      .unsubscribeFromTopic(FirebaseApi.UserId);
                  FirebaseApi().googleSignIn.signOut();

                  FirebaseAuth.instance.signOut();

                  Get.offAll(() => HomePage());
                  FirebaseApi.UserId = "";
                  FirebaseApi.userModel = null;

                  // Update the state of the app
                  // Then close the drawer
                },
              ),
            Gap(35.w),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Text(
                    "যে কোনো সাহায্যের জন্য যোগাযোগ করুন:",
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap(10.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "asset/images/facebook.jpg",
                      height: 60.w,
                      width: 80.w,
                    ),
                    Image.asset(
                      "asset/images/whatsapp.png",
                      height: 60.w,
                      width: 80.w,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      body: Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 5.w,
              left: 20.w,
              right: 20.w),
          child: CustomScrollView(
            // clipBehavior: Clip.none,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15.w),
                            height: 80.w,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10.w),
                                border: Border.all(
                                  color: AppColors.mainColor,
                                  width: 2.w,
                                )),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              //mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Gap(8.w),
                                FaIcon(
                                  FontAwesomeIcons.bars,
                                  color: AppColors.whiteColor,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "প্যাকেজ পান্ডা",
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 20.w,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      FirebaseApi.userModel == null
                                          ? "অতিথি"
                                          : (FirebaseApi.userModel!.name ?? "")
                                              .split(" ")[0],
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 20.w,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                    onTap: () {
                                      if (FirebaseApi.UserId == "") {
                                        Get.to(() => LoginPage());
                                        return;
                                      }

                                      Get.to(() => CreateProfilePage(
                                            isCreate: false,
                                          ));
                                    },
                                    child: ProfileImageWidget(
                                        controller: controller)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(10.w),
                    InkWell(
                      onTap: () {
                        if (FirebaseApi.UserId == "") {
                          Get.to(() => LoginPage());
                          return;
                        }
                        Get.to(() => HistoryPage());
                      },
                      child: Container(
                        //   margin: EdgeInsets.only(top: 15.w),
                        height: 50.w,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(10.w),
                            border: Border.all(
                              color: AppColors.mainColorMedium,
                              width: 2.w,
                            )),
                        child: Center(
                          child: Text(
                            "ট্রানস্যাকশন হিস্টোরি",
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 16.w,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    Gap(15.w),
                  ],
                ),
              ),
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
                        List<PackageModel>? data = snapshot.data!;

                        return SliverList(

                            delegate: SliverChildBuilderDelegate(
                                    childCount: 5,
                                    (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => OrderPage(data: data[index]),
                                  arguments: getColor(data[index].sim));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.w),
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: AppColors.whiteColor,
                                border: Border.all(
                                  color: AppColors.mainColor.withOpacity(0.5),
                                  width: 1.w
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadowColor,
                                    blurRadius: 5.0,
                                    offset: Offset(0,3)
                                  ),

                                ]
                              ),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.w),
                                      border: Border.all(
                                          color: AppColors.mainColor.withOpacity(0.5),
                                          width: 1.w
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("BTCUSD",style: TextStyle(color: AppColors.mainColor,fontSize: 20.w,fontWeight: FontWeight.w600),),
                                        Gap(5.w),
                                        Text("10:22 2/3/2024",style: TextStyle(color: AppColors.shadowColor,fontSize: 14.w,fontWeight: FontWeight.w400),),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.all(8.w),

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.w),
                                      border: Border.all(
                                          color: AppColors.mainColor.withOpacity(0.5),
                                          width: 1.w
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Active",style: TextStyle(color: AppColors.grameenCOlor,fontSize: 20.w,fontWeight: FontWeight.w600),),
                                        Gap(5.w),
                                        Text("Tp-1",style: TextStyle(color: AppColors.banglalinkColor,fontSize: 16.w,fontWeight: FontWeight.w400),),
                                      ],
                                    ),
                                  ),

                                  Container(
                                      padding: EdgeInsets.all(8.w),

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.w),
                                        border: Border.all(
                                            color: AppColors.mainColor.withOpacity(0.5),
                                            width: 1.w
                                        ),
                                      ),

                                      child: Text("Buy",style: TextStyle(color: AppColors.mainColor,fontSize: 24.w,fontWeight: FontWeight.w600),))
                                  
                                ],
                              ),
                            ),
                          );
                        }));



                        /*SliverGrid.builder(
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
                                Get.to(() => OrderPage(data: data[index]),
                                    arguments: getColor(data[index].sim));
                              },
                              child: ViewOfferItem(
                                simTypeName: data[index].sim,
                                data: data[index],
                              ),
                            );
                          },
                        );*/
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

class ViewOfferItem extends StatelessWidget {
  ViewOfferItem({
    super.key,
    this.simTypeName,
    required this.data,
  });

  final simTypeName;
  final PackageModel data;

  Color? simColor;

  @override
  Widget build(BuildContext context) {
    simColor = getColor(simTypeName);

    return Stack(
      clipBehavior: Clip.none,
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
                Gap(10.w),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                  ),
                  child: Text(
                    data.title ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: simColor,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Gap(5.w),
                Expanded(
                  child: Stack(
                    children: [


                      Center(
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          // height: 100.w,
                          width: 95.w,
                          decoration: BoxDecoration(
                              color: simColor!.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8.w),
                         /* border: Border.all(
                            color: data.hotDeal==true? simColor!: Colors.transparent,
                            width: 3,
                          )*/
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${data.packageRate!.toStringAsFixed(0)} ৳",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: simColor,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor:
                                          AppColors.inActiveButtonTextColor,
                                      decorationThickness: 1.2,
                                      fontSize: 12.w,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  "মাত্র",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: simColor,
                                      fontSize: 16.w,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "${data.price!.toStringAsFixed(0)} ৳",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: simColor,
                                      fontSize: 18.w,
                                      fontWeight: FontWeight.w800),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical:  2.w,horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8.w)),
                                    color: AppColors.whiteColor.withOpacity(0.73),
                                    border: Border.all(
                                      color: simColor!.withOpacity(0.35)
                                    )
                                  ),
                                  child: Text(
                                    "Save ${data.discount!.toStringAsFixed(0)} ৳",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: simColor,
                                        fontSize: 14.w,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if(data.hotDeal==true)
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                // color: Colors.yellow,
                                  child: Container(
                                      height: 18.w,
                                      child: CachedNetworkImage(
                                        imageUrl: "https://images.squarespace-cdn.com/content/v1/528d3636e4b06e6e83ecb6c9/1557365804845-M9Y7X95Z0VB0WZ8WICOK/Seasons_Social_Hot-Deal_R1_v2.gif?format=1500w",
                                        height: 18.w,
                                        width: 70.w,
                                        fit: BoxFit.fitWidth,

                                      )))),
                        ),
                    ],
                  ),
                ),
                Gap(8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
                  decoration: BoxDecoration(
                      color: simColor!.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.w)),
                  child: Text(
                    "${data.duration} দিন",
                    style: TextStyle(
                        color: simColor,
                        fontSize: 16.w,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Gap(3.w),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                  ),
                  child: Text(
                    data.description ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: simColor,
                        fontSize: 12.w,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Gap(5.w),
              ],
            )),

            // base on sim
            if (simTypeName == simType.airtel.name)
              Image.asset("asset/images/airtel.png"),
            if (simTypeName == simType.gp.name)
              Image.asset("asset/images/gp.png"),
            if (simTypeName == simType.banglalink.name)
              Image.asset("asset/images/banglalink.png"),
            if (simTypeName == simType.robi.name)
              Image.asset("asset/images/robi.png"),
          ],
        )),
        /*Positioned.fill(
          bottom: -15,
            right: -15,
            child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(

                  "asset/images/hot_deal.png", width:100.w,fit: BoxFit.contain,

                ))),*/
      ],
    );
  }
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
