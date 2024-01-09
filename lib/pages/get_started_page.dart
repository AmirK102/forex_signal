import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/pages/auth_pages/login_page.dart';
import 'package:package_panda/pages/home_page.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';

class GetStarted extends StatelessWidget {
   GetStarted({super.key});

  initData() async {
    loading=true;
    var res=   await FirebaseApi().checkLogin();
    if(res!=true){
      await FirebaseApi().checkLogin(isPhone: true);
    }
    EasyLoading.dismiss();
    if(loading==false)
      Get.offAll(() => HomePage());
    loading=false;
  }

  var loading=false;

  @override
  Widget build(BuildContext context) {
    initData();
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.mainColor,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(25.w),
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(5.w)),
                    child: Image.asset(
                      "asset/images/logo.png",
                      height: 80.w,
                      width: 80.w,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  Gap(5.w),
                  Text(
                    "Package Panda",
                    style:
                        TextStyle(color: AppColors.whiteColor, fontSize: 24.w),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "টক স্মার্ট, সেভ স্মার্টার",
                    style:
                        TextStyle(color: AppColors.whiteColor, fontSize: 32.w),
                  ),
                  Text(
                    "বেশি কথা! খরচ কম!",
                    style:
                        TextStyle(color: AppColors.whiteColor, fontSize: 28.w),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {

                  if(loading==true)
                  EasyLoading.show(status: "হোমপেজ লোডিং হচ্ছে",maskType: EasyLoadingMaskType.black);
                  else{
                    Get.offAll(() => HomePage());
                  }

                  loading=false;

                },
                child: Container(
                  color: AppColors.mainColorMedium,
                  padding: EdgeInsets.all(20.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "এবার শুরু করা যাক",
                        style: TextStyle(
                            color: AppColors.whiteColor, fontSize: 20.w),
                      ),
                      Gap(10.w),
                      FaIcon(
                        FontAwesomeIcons.circleArrowRight,
                        color: AppColors.whiteColor,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
