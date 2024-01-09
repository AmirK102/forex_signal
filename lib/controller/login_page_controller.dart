import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_panda/controller/otp_controller.dart';
import 'package:package_panda/pages/auth_pages/otp_page.dart';
import 'package:package_panda/pages/order_page.dart';
import 'package:pinput/pinput.dart';

class LoginPageLogic extends GetxController {
  var verificationId = null;
  var countryCode = "+880";
  var auth = FirebaseAuth.instance;

  TextEditingController phoneNumberController = TextEditingController();

  Future<void> phoneAuth() async {
    verificationId = null;

    // var phoneNumber = countryCode + phoneNumberController.text;
    var phoneNumber = convertToInternationalFormat(phoneNumberController.text);

    print("phoneNumber====================");
    print(phoneNumber);
    print(phoneNumberController.text);

    if (phoneNumber == null) {
      EasyLoading.dismiss();
      showErrorMessage("মোবাইল নম্বর সঠিক নয়");

      return;
    }

    if (phoneNumberController.text.isEmpty) {
      showErrorMessage("মোবাইল নম্বর লিখুন");
      return;
    }

    if (kIsWeb) {
      /*final confirmationResult =
      await auth.signInWithPhoneNumber(phoneNumber);
      final smsCode = await getSmsCodeFromUser(context);

      if (smsCode != null) {
        await confirmationResult.confirm(smsCode);
      }*/
    } else {
      await auth.verifyPhoneNumber(
        timeout: Duration(minutes: 1),
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          try {
            // Sign the user in (or link) with the credential
            var user = await auth.signInWithCredential(phoneAuthCredential);
            var otpPageController = Get.put(OtpPageLogic());

            otpPageController.pinController
                .setText(phoneAuthCredential.smsCode!);

            //  await loginSuccessRoute(user);
          } on FirebaseAuthException catch (e) {
            EasyLoading.dismiss();
            showErrorMessage(e.message.toString());
          }
        },
        verificationFailed: (e) {
          EasyLoading.dismiss();
          showErrorMessage(e.message.toString());
        },
        codeSent: (String verificationId, int? resendToken) async {
          this.verificationId = verificationId;
          print("this.verificationId==========================");
          print(this.verificationId);
          Get.to(() => OtpSubmitPage(), arguments: verificationId);
          EasyLoading.dismiss();
          /*     if (otpWeight.value == 50.w) {
            otpWeight.value = 120.w;
          } else {
            otpWeight.value = 50.w;
          }
          startOtpTimer();*/
        },
        codeAutoRetrievalTimeout: (e) {
          // showErrorMessage("Code Auto Retrieval Timeout");
          EasyLoading.dismiss();
        },
      );
    }
  }

  String? convertToInternationalFormat(String phoneNumber) {
    // Remove any non-numeric characters
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedNumber.startsWith('880')) {
      cleanedNumber = cleanedNumber.replaceFirst("880", "");
    } else if (cleanedNumber.startsWith('0')) {
      cleanedNumber = cleanedNumber.replaceFirst("0", "");
    } else if (!cleanedNumber.startsWith('0') && cleanedNumber.length == 10) {
    } else {
      return null;
    }

    // Ensure the number has the correct length (10 digits)
    if (cleanedNumber.length != 10) {
      return null;
    }

    String formattedNumber = '+880${cleanedNumber}';

    return formattedNumber;
  }
}
