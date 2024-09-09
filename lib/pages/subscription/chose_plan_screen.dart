import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_panda/pages/subscription/payment_submit.dart';

class SubscriptionScreen extends StatelessWidget {
  final Color themeColor = Color(0xFF66B2B2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Plan', style: TextStyle(color: Colors.white)),
        backgroundColor: themeColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SubscriptionCard(
                title: '1 Month Plan',
                price: '\$9.99',
                discunt: 'Billed Monthly',
                themeColor: themeColor,
                gradient: LinearGradient(
                  colors: [Color(0xFF66B2B2), Color(0xFF559999)],
                ),
              ),
              SizedBox(height: 16),
              SubscriptionCard(
                title: '6 Month Plan',
                price: '\$49.99',
                discunt: 'Save 15%',
                themeColor: themeColor,
                gradient: LinearGradient(
                  colors: [Color(0xFF66B2B2), Color(0xFF77CCCC)],
                ),
              ),
              SizedBox(height: 16),
              SubscriptionCard(
                title: '12 Month Plan',
                price: '\$89.99',
                discunt: 'Best Value - Save 25%',
                themeColor: themeColor,
                gradient: LinearGradient(
                  colors: [Color(0xFF66B2B2), Color(0xFF88E0E0)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String discunt;
  final Color themeColor;
  final Gradient gradient;

  const SubscriptionCard({
    Key? key,
    required this.title,
    required this.price,
    required this.discunt,
    required this.themeColor,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              discunt,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
               Get.to(()=> TransactionPage(packageName:title, packagePrice: price, discount: discunt,));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Text(
                'Subscribe Now',
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


