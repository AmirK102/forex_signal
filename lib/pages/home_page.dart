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
import 'package:package_panda/pages/subscription/chose_plan_screen.dart';
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

                Get.to(() => TimeLinePage());
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
          child: Column(
            children: [
              Expanded(
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
                                  height: 90.w,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Gap(8.w),
                                      FaIcon(
                                        FontAwesomeIcons.bars,
                                        color: AppColors.whiteColor,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            FirebaseApi.userModel == null
                                                ? "Guest Account"
                                                : (FirebaseApi
                                                            .userModel!.name ??
                                                        "")
                                                    .split(" ")[0],
                                            style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 20.w,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            FirebaseApi.userModel == null
                                                ? "Credit: 0"
                                                : (FirebaseApi
                                                    .userModel!.credits
                                                    .toString()),
                                            style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 14.w,
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
                              Get.to(() => TimeLinePage());
                            },
                            child: Container(
                              //   margin: EdgeInsets.only(top: 15.w),
                              height: 50.w,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppColors.banglalinkColor
                                      .withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(10.w),
                                  border: Border.all(
                                    color: AppColors.mainColorMedium,
                                    width: 2.w,
                                  )),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset("asset/images/credit.gif")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Gap(10.w),
                          InkWell(
                            onTap: () {
                              Get.to(() => TimeLinePage());
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
                                  "Timeline",
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
                      // collapsedHeight: 100.w,
                      // expandedHeight: 100.w,
                      actions: <Widget>[Container()],
                      flexibleSpace: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            MainDropdownPicker(
                              labelText: "Select Market",
                              options: [
                                "All",
                                "Crypto",
                                "Forex",
                                "Metals",
                                "Stocks",
                              ],
                              onChanged: (v) {
                                if (v == "Crypto") {
                                  controller.selectedMarketType.value =
                                      MarketType.crypto.name;
                                } else if (v == "Forex") {
                                  controller.selectedMarketType.value =
                                      MarketType.forex.name;
                                } else if (v == "Metals") {
                                  controller.selectedMarketType.value =
                                      MarketType.metal.name;
                                } else if (v == "Stocks") {
                                  controller.selectedMarketType.value =
                                      MarketType.stock.name;
                                } else {
                                  controller.selectedMarketType.value =
                                      MarketType.all.name;
                                }
                              },
                            ),
                            //  Gap(15.w),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      controller.selectedMarketType.value;
                      return StreamBuilder<List<SignalModel>>(
                          stream: FirebaseApi().getAllPackagesStream(
                            ascending: controller.lowToHigh.value,
                            packageType:
                                controller.selectedPackageCategory.value,
                            marketType:
                                controller.selectedMarketType.value == "all"
                                    ? null
                                    : controller.selectedMarketType.value,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<SignalModel>? data = snapshot.data!;

                              return SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      childCount: snapshot.data!.length,
                                      (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => OrderPage(
                                          signalData: snapshot.data![index]),
                                    );
                                  },
                                  child:
                                      SignalCard(data: snapshot.data![index]),
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
              ),
              InkWell(
                onTap: (){
                  Get.to(()=>SubscriptionScreen());
                },
                child: Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.banglalinkColor),
                  child: Center(
                    child: Text(
                      "Try Ad Free",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.w,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SignalCard extends StatelessWidget {
  const SignalCard({
    super.key,
    required this.data,
    this.showOption = false,
    this.exitOnTap,
    this.Tp1OnTap,
    this.Tp2OnTap,
    this.Tp3OnTap,
    this.SlOnTap,
  });

  final SignalModel? data;
  final bool showOption;

  final VoidCallback? exitOnTap;
  final VoidCallback? Tp1OnTap;
  final VoidCallback? Tp2OnTap;
  final VoidCallback? Tp3OnTap;
  final VoidCallback? SlOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.w),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: AppColors.whiteColor,
          border: Border.all(
              color: AppColors.mainColor.withOpacity(0.5), width: 1.w),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 5.0,
                offset: Offset(0, 3)),
          ]),
      child: Column(
        children: [
          if (!showOption && data!.isComplete == true)
            Builder(builder: (context) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "The Signal is complete",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blueAccent,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700),
                  ),
                  if (data!.isTp1Complete == true ||
                      data!.isTp2Complete == true ||
                      data!.isTp3Complete == true)
                    Text(
                      "with ",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700),
                    ),
                  if (data!.isTp1Complete == true)
                    Text(
                      "Tp1 ",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700),
                    ),
                  if (data!.isTp2Complete == true)
                    Text(
                      "Tp2 ",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700),
                    ),
                  if (data!.isTp3Complete == true)
                    Text(
                      "Tp3 ",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700),
                    ),
                ],
              );
            }),
          Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                      color: AppColors.mainColor.withOpacity(0.5), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data!.pair ?? "",
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 20.w,
                          fontWeight: FontWeight.w600),
                    ),
                    Gap(5.w),
                    //Text("10:22 2/3/2024",style: TextStyle(color: AppColors.shadowColor,fontSize: 14.w,fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                      color: AppColors.mainColor.withOpacity(0.5), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data!.action!,
                      style: TextStyle(
                          color: AppColors.grameenCOlor,
                          fontSize: 20.w,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              /* Container(
                  padding: EdgeInsets.all(8.w),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                        color: AppColors.mainColor.withOpacity(0.5),
                        width: 1.w
                    ),
                  ),

                  child: Text(data!.status!,style: TextStyle(color: AppColors.mainColor,fontSize: 20.w,fontWeight: FontWeight.w600),))*/
            ],
          ),
          Gap(5),
          if (showOption)
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                MainButton(
                  onTap: exitOnTap!,
                  buttonText: "Exit",
                  buttonColor: data!.isComplete == true
                      ? Colors.green
                      : AppColors.mainColor,
                ),
                MainButton(
                  onTap: Tp1OnTap!,
                  buttonText: "Tp1",
                  buttonColor: data!.isTp1Complete == true
                      ? Colors.green
                      : AppColors.mainColor,
                ),
                MainButton(
                  onTap: Tp2OnTap!,
                  buttonText: "Tp2",
                  buttonColor: data!.isTp2Complete == true
                      ? Colors.green
                      : AppColors.mainColor,
                ),
                MainButton(
                  onTap: Tp3OnTap!,
                  buttonText: "Tp3",
                  buttonColor: data!.isTp3Complete == true
                      ? Colors.green
                      : AppColors.mainColor,
                ),
                MainButton(
                  onTap: SlOnTap!,
                  buttonText: "SL",
                  buttonColor: data!.isSlComplete == true
                      ? Colors.green
                      : AppColors.mainColor,
                ),
              ],
            ),
        ],
      ),
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
