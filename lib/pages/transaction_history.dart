import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_panda/common_function/main_appbar.dart';
import 'package:package_panda/common_widget/MainDropdownPicker.dart';
import 'package:package_panda/controller/home_page_controller.dart';
import 'package:package_panda/model/TransactionModel.dart';
import 'package:package_panda/repository/firebase_api.dart';
import 'package:package_panda/utilities/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TimeLinePage extends StatelessWidget {
  TimeLinePage({super.key});

  RxString selectedMarketType = MarketType.all.name.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainAppBar(appBarText: "Timeline"),
            Gap(20.w),
            Container(
              height: 50.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: MainDropdownPicker(
                labelText: "Select Market",

                options: [
                  "All",
                  "Crypto",
                  "Forex",
                  "Metal",
                  "Stocks",
                ],
                onChanged: (v) {
                  if (v == "Crypto") {
                    selectedMarketType.value =
                        MarketType.crypto.name;
                  } else if (v == "Forex") {
                    selectedMarketType.value =
                        MarketType.forex.name;
                  } else if (v == "Metal") {
                    selectedMarketType.value =
                        MarketType.metal.name;
                  } else if (v == "Stocks") {
                    selectedMarketType.value =
                        MarketType.stock.name;
                  } else {
                    selectedMarketType.value =
                        MarketType.all.name;
                  }
                },
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Select Market";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Gap(20.w),
            Expanded(
              child: Obx(() {
                selectedMarketType.value;
                return StreamBuilder<List<PostModel>>(
                    stream: FirebaseApi().getTransactionsByUserIdStream(
                      marketType: selectedMarketType.value == "all"
                          ? null
                          : selectedMarketType.value,
                    ),
                    builder: (context, snapshot) {
                      print(snapshot.error.toString());
                      if (snapshot.hasData) {
                        print("snapshot.data!.length");
                        print(snapshot.data!.length);
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            PostModel data = snapshot.data![index];
                            return PostWidget(data: data,);
                          },
                        );
                      }
                      return Container();
                    });
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


class PostWidget extends StatelessWidget {
  PostWidget({super.key, required this.data});

  final PostModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 15.w, vertical: 10.w),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.mainColor,

              width: 2.w
          ),
          borderRadius: BorderRadius.circular(10.w)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Gap(5.w),
          Text(
            softWrap: true,
            overflow: TextOverflow.clip,
            data.postTitle ?? "",

            style: TextStyle(


                fontSize: 18.w,
                fontWeight: FontWeight.w800),
          ),
          Linkify(

            onOpen: (link) async {
              if (!await launchUrl(Uri.parse(link.url))) {
                throw Exception('Could not launch ${link.url}');
              }
            },
            text: data.postDescription ?? "",
            style: TextStyle(color: Colors.black),
            linkStyle: TextStyle(color: Colors.blue),
          ),

          Gap(5.w),
          if(data.screenshot != "")
            ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: CachedNetworkImage(
                imageUrl: data.screenshot ?? "",

                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
              ),
            ),

          Row(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () async {
                    await FirebaseApi()
                        .giveLike(data.id, data.like);
                  }, icon: Icon(Icons.thumb_up)),
                  Gap(5.w),
                  Text(data.like.toString())
                ],
              ),
              Gap(20.w),
              Row(
                children: [
                  IconButton(onPressed: () async {
                    await FirebaseApi()
                        .giveDisLike(data.id, data.dislike);
                  }, icon: Icon(Icons.thumb_down)),
                  Gap(5.w),
                  Text(data.dislike.toString())
                ],
              ),

            ],
          )

        ],
      ),
    );
  }
}

