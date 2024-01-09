import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/model/TransactionModel.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainAppBar(appBarText: "ট্রানস্যাকশন হিস্টোরি"),
            Gap(20.w),
            Expanded(
              child: StreamBuilder<List<TransactionModel>>(
                  stream: FirebaseApi().getTransactionsByUserIdStream(),
                  builder: (context, snapshot) {

                    print(snapshot.data);

                    if (snapshot.hasData) {
                      print("snapshot.data!.length");
                      print(snapshot.data!.length);
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          TransactionModel data= snapshot.data![index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.w),
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10.w)),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.w),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          data.status=="completed"?(data.adminProfImage??""): (data.screenshot??""),
                                          height: 149.w,
                                          width: 149.w,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      Gap(5.w),
                                      Text(
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        data.title??"",

                                        style: TextStyle(
                                            color: AppColors.whiteColor,

                                            fontSize: 18.w,
                                            fontWeight: FontWeight.w800),
                                      )
                                    ],
                                  ),
                                ),
                                Gap(8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data.status??"",
                                          style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 14.w,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        IconButton(onPressed: (){

                                          Get.defaultDialog(
                                            title: "তথ্য",
                                            content: Text(data.message??"",
                                            style: TextStyle(
                                              color: AppColors.mainColor,
                                              fontSize: 14.w
                                            ),
                                            )
                                          );

                                        }, icon: Icon(Icons.info_outline, color: AppColors.whiteColor,))
                                      ],
                                    ),
                                    Gap(25.w),
                                    _info(infoText: data.transactionId??""),
                                    Gap(8.w),
                                    _info(infoText: data.offerNumber??""),
                                    Gap(8.w),
                                    _info(infoText: "মূল্য: ${data.price!.toStringAsFixed(0)} টাকা"),
                                    Gap(8.w),
                                    Builder(
                                      builder: (context) {
                                        String formattedDate = DateFormat('MM/dd/yyyy').format(data.confirmDateTime!);

                                        return _info(infoText: formattedDate);
                                      }
                                    ),
                                    Gap(8.w),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }

  Row _info({infoText}) {
    return Row(
      children: [
        Container(
          height: 10.w,
          width: 10.w,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10000),
          ),
        ),
        Gap(6.w),
        Text(
          infoText,
          style: TextStyle(color: AppColors.offWhiteColor.withOpacity(0.7)),
        ),
      ],
    );
  }
}
