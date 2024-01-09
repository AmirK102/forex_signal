import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:package_panda/utilities/app_colors.dart';

class OrderPageButton extends StatelessWidget {
  const OrderPageButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.isCopy = false,

    this.buttonColor = AppColors.mainColor,
  });

  final VoidCallback onTap;
  final String buttonText;
  final bool isCopy;

  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.w),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: buttonColor, width: 1.w),
            boxShadow: [
              BoxShadow(
                  offset: Offset(-1, 4),
                  color: AppColors.shadowColor,
                  blurRadius: 4)
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:isCopy? MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
          children: [

            Expanded(
              child: Center(
                child: Text(
                  buttonText,
              
                  style: TextStyle(
              
                      color: buttonColor,
                      fontSize: 18.w,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (isCopy) Gap(10.w),
            if (isCopy) Container(
              padding: EdgeInsets.symmetric(horizontal:  6.w,vertical: 6.w) ,
                decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(10.w)  ,
                  border: Border.all(
                    color: buttonColor,
                    width: 0.7.w
                  )
                ),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.copy,color: buttonColor,size: 14.w,),
                    Gap(3.w),
                    Text("copy",
                    style: TextStyle(
                      color: buttonColor,
                      fontSize: 15.w
                    ),
                    )
                  ],
                )),

          ],
        ),
      ),
    );
  }
}
