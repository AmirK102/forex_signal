import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_panda/utilities/app_colors.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({
    super.key, required this.appBarText,
  });

  final String appBarText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: FaIcon(FontAwesomeIcons.arrowLeft)),
          Text(
            appBarText ,
            style: TextStyle(
                color: AppColors.mainColor,
                fontSize: 20.w,
                fontWeight: FontWeight.w700),
          ),
          Gap(20.w),


        ],
      ),
    );
  }
}