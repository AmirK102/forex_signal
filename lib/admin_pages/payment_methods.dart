import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_function/main_button.dart';
import 'package:package_panda/common_widget/MainInputFiled.dart';
import 'package:package_panda/model/PaymentMethod.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainAppBar(appBarText: "Change payment Methods"),
            MainButton(
              onTap: () {
                _showConfirmationBottomSheet(context,null);
              },
              buttonText: "Add Payment Methods",
              icon: FontAwesomeIcons.plus,
              isIcon: true,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: StreamBuilder<List<PaymentMethod>>(
                    stream: FirebaseApi().getPaymentMethodsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,

                            itemBuilder: (context, index) {
                          PaymentMethod data= snapshot.data![index];
                          return paymentNumber(paymentMethod: data);
                        });
                      } else {
                        return Container(
                          child: Text(
                            "No Method available",
                            style: TextStyle(color: AppColors.mainColor),
                          ),
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class paymentNumber extends StatelessWidget {
   paymentNumber({
    super.key, required this.paymentMethod,
  });
  final PaymentMethod paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: paymentMethod.phone,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text: ' (${paymentMethod.type})',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                _showConfirmationBottomSheet(context,paymentMethod);
              },
              icon: FaIcon(FontAwesomeIcons.penToSquare),
              color: AppColors.mainColor,
              highlightColor: Colors.blueAccent),
          IconButton(
              onPressed: () {
                FirebaseApi().deletePaymentMethod(id: paymentMethod.id);
              },
              icon: FaIcon(
                FontAwesomeIcons.trash,
              ),
              color: AppColors.airtelColor,
              highlightColor: Colors.blueAccent)
        ],
      ),
    );
  }
}

void _showConfirmationBottomSheet(BuildContext context,PaymentMethod? data) {

  var phoneNumber=TextEditingController(text: data?.phone??"");
  var methodName=TextEditingController(text: data?.type??"");

  Get.bottomSheet(Container(
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.w), topRight: Radius.circular(10.w)),
    ),
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Are you sure?',
          style: TextStyle(
            fontSize: 18.w,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.w),
        MainInputFiled(
          hints: "phone number",
          textEditingController: phoneNumber,
        ),
        SizedBox(height: 16.w),
        MainInputFiled(
          hints: "Method name",
          textEditingController: methodName,
        ),
        SizedBox(height: 16.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Handle 'Yes' button click

                if(data==null){
                  EasyLoading.show();
                await  FirebaseApi().createPaymentMethod(phoneNumber.text, methodName.text);
                  EasyLoading.dismiss();
                }else{
                  EasyLoading.show();
                  await  FirebaseApi().updatePaymentMethod(phone: phoneNumber.text,type:  methodName.text,id:data.id );
                  EasyLoading.dismiss();

                }

                Navigator.pop(context); // Close the bottom sheet
                // Add your logic for 'Yes'
              },
              child: Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle 'No' button click
                Navigator.pop(context); // Close the bottom sheet
                // Add your logic for 'No'
              },
              child: Text('No'),
            ),
          ],
        ),
      ],
    ),
  ));
}


