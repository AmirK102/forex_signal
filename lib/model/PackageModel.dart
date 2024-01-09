// To parse this JSON data, do
//
//     final packageModel = packageModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PackageModel packageModelFromJson(String str) => PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
  String? transactionId;
  String? description;
  double? packageRate;
  dynamic duration;
  double? discount;
  String? packageType;
  String? title;
  double? revenue;
  double? earnings;
  DateTime? dateTime;
  double? price;
  String? sim;
  double? commission;
  String? phoneNumber;
  String? id;
  String? status;
  bool? hotDeal;

  PackageModel({
    this.transactionId,
    this.hotDeal,
    this.description,
    this.packageRate,
    this.duration,
    this.discount,
    this.packageType,
    this.title,
    this.revenue,
    this.earnings,
    this.dateTime,
    this.price,
    this.sim,
    this.commission,
    this.phoneNumber,
    this.id,
    this.status,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    transactionId: json["transaction_id"],
    description: json["description"],
    hotDeal: json["hot_deal"],
    packageRate: json["package_rate"]?.toDouble(),
    duration: json["duration"],
    discount: json["discount"]?.toDouble(),
    packageType: json["package_type"],
    title: json["title"],
    revenue: json["revenue"]?.toDouble(),
    earnings: json["earnings"]?.toDouble(),
    dateTime: json["date_time"] == null ? null : (json["date_time"] as Timestamp).toDate(),
    price: json["price"]?.toDouble(),
    sim: json["sim"],
    commission: json["commission"]?.toDouble(),
    phoneNumber: json["phone_number"],
    id: json["id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "package_rate": packageRate,
    "hot_deal": hotDeal,
    "duration": duration,
    "description": description,
    "discount": discount,
    "package_type": packageType,
    "title": title,
    "revenue": revenue,
    "earnings": earnings,
    "date_time": dateTime,
    "price": price,
    "sim": sim,
    "commission": commission,
    "phone_number": phoneNumber,
    "id": id,
    "status": status,
  };
}

