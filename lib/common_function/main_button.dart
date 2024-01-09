import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:package_panda/utilities/app_colors.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.isIcon = false,
    this.icon = FontAwesomeIcons.circleArrowRight,
    this.buttonColor = AppColors.mainColor,
  });

  final VoidCallback onTap;
  final String buttonText;
  final bool isIcon;
  final IconData icon;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.w),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(15.w),
            border: Border.all(color: buttonColor, width: 5.w),
            boxShadow: [
              BoxShadow(
                  offset: Offset(-1, 4),
                  color: AppColors.shadowColor,
                  blurRadius: 4)
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isIcon) FaIcon(icon,color: buttonColor,),
            if (isIcon) Gap(10.w),
            Center(
              child: Text(
                buttonText,

                style: TextStyle(

                    color: buttonColor,
                    fontSize: 18.w,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MainButtonSmall extends StatelessWidget {
  const MainButtonSmall({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.isIcon = false,
    this.icon = FontAwesomeIcons.circleArrowRight,
    this.buttonColor = AppColors.mainColor,
  });

  final VoidCallback onTap;
  final String buttonText;
  final bool isIcon;
  final IconData icon;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(15.w),
            border: Border.all(color: buttonColor, width: 2.w),
            boxShadow: [
              BoxShadow(
                  offset: Offset(-1, 4),
                  color: AppColors.shadowColor,
                  blurRadius: 4)
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isIcon) FaIcon(icon,color: buttonColor,),
            if (isIcon) Gap(10.w),
            Center(
              child: Text(
                buttonText,

                style: TextStyle(

                    color: buttonColor,
                    fontSize: 16.w,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
