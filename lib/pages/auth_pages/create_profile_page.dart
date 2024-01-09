import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/common_widget/MainInputFiled.dart';
import 'package:package_panda/controller/create_profile_controller.dart';
import 'package:package_panda/model/UserModel.dart';
import 'package:package_panda/pages/home_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';
import 'package:package_panda/utilities/common_methods.dart';

class CreateProfilePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateProfilePage(
      {super.key, this.isCreate = true, this.accountCreateBy = "email"});

  var controller =
      Get.put(CreateProfileLogic(), tag: DateTime.now().toIso8601String());

  final isCreate;
  final accountCreateBy;

  Map<String, dynamic> data = {"email": "", "phone": ""};

  @override
  Widget build(BuildContext context) {
    if(!isCreate){
      try {
        controller.selectedGender.value = FirebaseApi.userModel!.gender ?? "";
        controller.pickedImagePath.value =
            FirebaseApi.userModel!.profilePhoto ?? "";
      } catch (e) {
        // TODO
      }
    }


    return Scaffold(
      body: SafeArea(
        child: isCreate
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    MainAppBar(
                      appBarText: "প্রোফাইল আপডেট",
                    ),
                    Gap(20.w),
                    ProfileImageWidget(controller: controller),
                    Gap(15.w),
                    MainButton(
                        onTap: () async {
                          controller.pickedImagePath.value =
                              await CommonMethods().pickImage();
                        },
                        icon: FontAwesomeIcons.cameraRetro,
                        isIcon: true,
                        buttonText: "ছবি আপলোড"),
                    Gap(25.w),
                    Obx(() {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120.w,
                            child: MainButton(
                                onTap: () async {
                                  controller.selectedGender.value = "male";
                                },
                                buttonText: "ছেলে",
                                buttonColor:
                                    controller.selectedGender.value != "male"
                                        ? AppColors.inActiveButtonTextColor
                                        : AppColors.mainColor),
                          ),
                          Gap(30.w),
                          SizedBox(
                            width: 120.w,
                            child: MainButton(
                                onTap: () async {
                                  controller.selectedGender.value = "female";
                                },
                                buttonText: "মেয়ে",
                                buttonColor:
                                    controller.selectedGender.value != "female"
                                        ? AppColors.inActiveButtonTextColor
                                        : AppColors.mainColor),
                          ),
                        ],
                      );
                    }),
                    Gap(25.w),
                    Form(
                      key: _formKey,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          children: [
                            MainInputFiled(
                              // textEditingController: TextEditingController,
                              hints: "নাম লিখুন",
                              onChanged: (v) {
                                data.addAll({"name": v});
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "আপনার নাম লিখুন";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Gap(25.w),
                            if (accountCreateBy == "email")
                              MainInputFiled(
                                hints: "ইমেইল লিখুন",
                                readOnly: true,
                                textEditingController: TextEditingController(
                                    text: controller.firebaseApi.googleSignIn
                                        .currentUser!.email),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (v) {
                                  data.addAll({"email": v});
                                },
                              ),
                            if (accountCreateBy == "phone")
                              MainInputFiled(
                                hints: "ইমেইল লিখুন",
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (v) {
                                  data.addAll({"email": v});
                                },
                              ),
                            Gap(25.w),
                            if (accountCreateBy == "email")
                              MainInputFiled(
                                textEditingController:
                                    TextEditingController(text: ""),
                                hints: "ফোন নম্বর লিখুন",
                                readOnly: false,
                                keyboardType: TextInputType.phone,
                                onChanged: (v) {
                                  data.addAll({"phone": v});
                                },
                              ),
                            if (accountCreateBy == "phone")
                              MainInputFiled(
                                textEditingController: TextEditingController(
                                    text: FirebaseAuth
                                        .instance.currentUser!.phoneNumber!),
                                hints: "ফোন নম্বর লিখুন",
                                readOnly: true,
                                keyboardType: TextInputType.phone,
                                onChanged: (v) {
                                  data.addAll({"phone": v});
                                },
                              ),
                            Gap(25.w),
                            MainDropdownPicker(
                              onChanged: (v) {
                                data.addAll({"occupation": v});
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "আপনার পেশা সিলেক্ট করুন";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Gap(25.w),
                            MainDropdownPicker(
                              onChanged: (v) {
                                data.addAll({"district": v});
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "আপনার জেলা সিলেক্ট করুন";
                                } else {
                                  return null;
                                }
                              },
                              labelText: "জেলা সিলেক্ট করুন",
                              options: district,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(25.w),
                    SizedBox(
                        width: 240.w,
                        child: MainButton(
                            onTap: () async {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                data.addAll({
                                  "gender": controller.selectedGender.value,
                                  "login_by": accountCreateBy
                                });
                                print(data);

                                EasyLoading.show();

                                var res;
                                var imageUrl = "";


                                imageUrl= controller.pickedImagePath.value;

                                if(imageUrl==""){
                                 if( FirebaseApi.userModel==null){
                                   imageUrl= controller.firebaseApi.googleSignIn
                                       .currentUser!.photoUrl ??
                                       "";
                                 }else{
                                   imageUrl=FirebaseApi.userModel!.profilePhoto??"";
                                 }
                                }

                                  res = await FirebaseApi().createUser(
                                      data,
                                      imageUrl);


                                if (res) {
                                  Get.offAll(() => HomePage());
                                } else {
                                  Get.snackbar(
                                      "Error", "Failed to create account");
                                }
                                EasyLoading.dismiss();
                              }
                            },
                            buttonText: "সেভ করুন")),
                    Gap(25.w),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    MainAppBar(
                      appBarText: "প্রোফাইল আপডেট",
                    ),
                    Gap(20.w),
                    ProfileImageWidget(controller: controller),
                    Gap(15.w),
                    MainButton(
                        onTap: () async {
                          controller.pickedImagePath.value =
                              await CommonMethods().pickImage();
                        },
                        icon: FontAwesomeIcons.cameraRetro,
                        isIcon: true,
                        buttonText: "ছবি আপলোড"),
                    Gap(25.w),
                    Obx(() {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120.w,
                            child: MainButton(
                                onTap: () async {
                                  controller.selectedGender.value = "male";
                                },
                                buttonText: "ছেলে",
                                buttonColor:
                                    controller.selectedGender.value != "male"
                                        ? AppColors.inActiveButtonTextColor
                                        : AppColors.mainColor),
                          ),
                          Gap(30.w),
                          SizedBox(
                            width: 120.w,
                            child: MainButton(
                                onTap: () async {
                                  controller.selectedGender.value = "female";
                                },
                                buttonText: "মেয়ে",
                                buttonColor:
                                    controller.selectedGender.value != "female"
                                        ? AppColors.inActiveButtonTextColor
                                        : AppColors.mainColor),
                          ),
                        ],
                      );
                    }),
                    Gap(25.w),
                    Form(
                      key: _formKey,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          children: [
                            MainInputFiled(
                              textEditingController: TextEditingController(
                                  text: FirebaseApi.userModel!.name ?? ""),
                              hints: "নাম লিখুন",
                              onChanged: (v) {
                                data.addAll({"name": v});
                              },
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
                              hints: "ইমেইল লিখুন",
                              readOnly:
                                  FirebaseApi.userModel!.loginBy == "email",
                              textEditingController: TextEditingController(
                                  text: FirebaseApi.userModel!.email ?? ""),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (v) {
                                data.addAll({"email": v});
                              },
                            ),
                            Gap(25.w),
                            MainInputFiled(
                              textEditingController: TextEditingController(
                                  text: FirebaseApi.userModel!.phone ?? ""),
                              hints: "ফোন নম্বর লিখুন",
                              readOnly:
                                  FirebaseApi.userModel!.loginBy == "phone",
                              keyboardType: TextInputType.phone,
                              onChanged: (v) {
                                data.addAll({"phone": v});
                              },
                            ),
                            Gap(25.w),
                            MainDropdownPicker(
                              onChanged: (v) {
                                data.addAll({"occupation": v});
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "আপনার পেশা সিলেক্ট করুন";
                                } else {
                                  return null;
                                }
                              },
                              initialValue:
                                  FirebaseApi.userModel!.occupation ?? "",
                            ),
                            Gap(25.w),
                            MainDropdownPicker(
                              onChanged: (v) {
                                data.addAll({"district": v});
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "আপনার জেলা সিলেক্ট করুন";
                                } else {
                                  return null;
                                }
                              },
                              labelText: "জেলা সিলেক্ট করুন",
                              options: district,
                              initialValue:
                                  FirebaseApi.userModel!.district ?? "",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(25.w),
                    SizedBox(
                        width: 240.w,
                        child: MainButton(
                            onTap: () async {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                data.addAll({
                                  "gender": controller.selectedGender.value,
                                  "login_by":
                                      FirebaseApi.userModel!.loginBy ?? "email"
                                });
                                print(data);

                                EasyLoading.show();

                                var res;
                                var isEmail = controller
                                        .firebaseApi.googleSignIn.currentUser !=
                                    null;

                                print("isEmail");
                                print(isEmail);

                                var imageUrl = "";


                                imageUrl= controller.pickedImagePath.value;

                                if(imageUrl==""){
                                  if( FirebaseApi.userModel==null){
                                    imageUrl= controller.firebaseApi.googleSignIn
                                        .currentUser!.photoUrl ??
                                        "";
                                  }else{
                                    imageUrl=FirebaseApi.userModel!.profilePhoto??"";
                                  }
                                }

                                res = await FirebaseApi().createUser(data, imageUrl);

                                await FirebaseApi().getUser(FirebaseApi.UserId);

                                if (res) {
                                  Get.offAll(() => HomePage());
                                } else {
                                  Get.snackbar(
                                      "Error", "Failed to create account");
                                }
                                EasyLoading.dismiss();
                              }
                            },
                            buttonText: "সেভ করুন")),
                    Gap(25.w),
                  ],
                ),
              ),
      ),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.controller,
  });

  final CreateProfileLogic controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset("asset/icons/photo_border.svg",
            height: 160.w, width: 160.w, semanticsLabel: 'Logo'),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Obx(() {
                if (controller.firebaseApi.googleSignIn.currentUser != null &&
                    controller.pickedImagePath.value == "" &&
                    controller.firebaseApi.googleSignIn.currentUser!.photoUrl !=
                        null &&
                    FirebaseApi.userModel == null) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(10000),
                      child: CachedNetworkImage(
                        imageUrl: controller.firebaseApi.googleSignIn
                                .currentUser!.photoUrl ??
                            "",
                        height: 115.w,
                        width: 115.w,
                      ));
                }

                if (controller.pickedImagePath.value == "") {
                  return Image.asset(
                    controller.selectedGender.value == "male"
                        ? "asset/images/male.png"
                        : "asset/images/female.png",
                    height: 140.w,
                    width: 140.w,
                  );
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10000),
                  child: FirebaseApi().isLink(controller.pickedImagePath.value)
                      ? CachedNetworkImage(
                          imageUrl: controller.pickedImagePath.value,
                          height: 115.w,
                          width: 115.w,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(controller.pickedImagePath.value),
                          height: 115.w,
                          width: 115.w,
                          fit: BoxFit.cover,
                        ),
                );
              })),
        ),
      ],
    );
  }
}

List<String> district = [
  "ব্রাহ্মণবাড়িয়া",
  "চাঁদপুর",
  "কুমিল্লা",
  "ফেনী",
  "লক্ষ্মীপুর",
  "নোয়াখালী",
  "চট্টগ্রাম",
  "কক্সবাজার",
  "খাগড়াছড়ি",
  "রাঙ্গামাটি",
  "বান্দরবান",
  "ঢাকা",
  "গাজীপুর",
  "নারায়ণগঞ্জ",
  "মানিকগঞ্জ",
  "মুন্সীগঞ্জ",
  "রাজবাড়ী",
  "ফরিদপুর",
  "মাদারীপুর",
  "গোপালগঞ্জ",
  "টাঙ্গাইল",
  "শরীয়তপুর",
  "কিশোরগঞ্জ",
  "নরসিংদী",
  "খুলনা",
  "বাগেরহাট",
  "ঝালকাঠি",
  "পিরোজপুর",
  "বরগুনা",
  "পটুয়াখালী",
  "ভোলা",
  "বরিশাল",
  "ঝিনাইদহ",
  "মাগুরা",
  "নড়াইল",
  "কুষ্টিয়া",
  "মেহেরপুর",
  "রাজশাহী",
  "নাটোর",
  "চাঁপাইনবাবগঞ্জ",
  "পাবনা",
  "সিরাজগঞ্জ",
  "বগুড়া",
  "জয়পুরহাট",
  "নওগাঁ",
  "রংপুর",
  "দিনাজপুর",
  "লালমনিরহাট",
  "কুড়িগ্রাম",
  "পঞ্চগড়",
  "ঠাকুরগাঁও",
  "নীলফামারী",
  "সিলেট",
  "সুনামগঞ্জ",
  "হবিগঞ্জ",
];
