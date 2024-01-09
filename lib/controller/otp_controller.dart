import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_panda/pages/auth_pages/create_profile_page.dart';
import 'package:package_panda/pages/home_page.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:package_panda/repository/firebase_api.dart';

class OtpPageLogic extends GetxController {
  final pinController = TextEditingController();
  var verificationId = Get.arguments;
  var auth = FirebaseAuth.instance;

  verifyOtp() async {
    if (verificationId == null) {
      showErrorMessage("Please Send OTP");
      return;
    }

    EasyLoading.show();
    var smsCode = pinController.text;
    if (smsCode.isNotEmpty) {
      // Create a PhoneAuthCredential with the code
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      try {
        // Sign the user in (or link) with the credential
        var user = await auth.signInWithCredential(credential);

        print("user");
        print(user);
        // loginSuccessRoute(user);

        if (user.user != null) {
          bool res =await FirebaseApi().isUserExist(user.user!.uid);
          print("res=============isUserExist");
          print(res);
          print(res);
          if (res == true) {
            Get.to(() => HomePage());
          } else {
            Get.to(() => CreateProfilePage(
                  accountCreateBy: "phone",
                ));
          }
        } else {}
      } on FirebaseAuthException catch (e) {
        EasyLoading.dismiss();
        showErrorMessage(e.message.toString());
      }
    } else {
      showErrorMessage("Please enter OTP");
    }
    EasyLoading.dismiss();
  }
}
