import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_panda/model/UserModel.dart';

class TransactionModel {
  String? transactionId;
  double? packageRate;
  dynamic duration;
  double? discount;
  String? screenshot;
  String? packageType;
  String? message;
  String? title;
  double? earnings;
  double? revenue;
  DateTime? dateTime;
  String? userId;
  String? sim;
  double? price;
  double? commission;
  String? phoneNumber;
  String? offerNumber;
  String? id;
  String? status;
  String? workingBy;
  String? workingUid;
  UserModel? orderConfirmBy;
  UserModel? userObj;
  DateTime? confirmDateTime;
  String? adminProfImage;

  TransactionModel({
    this.transactionId,
    this.userObj,
    this.adminProfImage,
    this.workingUid,
    this.workingBy,
    this.orderConfirmBy,
    this.packageRate,
    this.duration,
    this.discount,
    this.screenshot,
    this.packageType,
    this.message,
    this.title,
    this.earnings,
    this.revenue,
    this.dateTime,
    this.userId,
    this.sim,
    this.price,
    this.commission,
    this.phoneNumber,
    this.offerNumber,
    this.id,
    this.status,
    this.confirmDateTime,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    transactionId: json["transaction_id"],
    adminProfImage: json["admin_prof_image"],
    workingBy: json["working_by"],
    userObj:json["user_obj"]==null?null :UserModel.fromJson(json["user_obj"]),
    workingUid: json["working_uid"],
    packageRate: (json["package_rate"] as num).toDouble(),
    duration: json["duration"],
    orderConfirmBy: json["orderConfirmBy"]==null?null :UserModel.fromJson(json["orderConfirmBy"]), // Add this line
    discount: (json["discount"] as num).toDouble(),
    screenshot: json["screenshot"],
    packageType: json["package_type"],
    message: json["message"],
    title: json["title"],
    earnings: (json["earnings"] as num).toDouble(),
    revenue: (json["revenue"] as num).toDouble(),
    dateTime: (json["date_time"] as Timestamp).toDate(),
    userId: json["user_id"],
    sim: json["sim"],
    price: (json["price"] as num).toDouble(),
    commission: (json["commission"] as num).toDouble(),
    phoneNumber: json["phone_number"],
    offerNumber: json["offer_number"].toString(),
    id: json["id"],
    status: json["status"],
    confirmDateTime: (json["confirm_date_time"] as Timestamp).toDate(),
  );

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "orderConfirmBy": orderConfirmBy?.toJson(),
    "package_rate": packageRate,
    "admin_prof_image": adminProfImage,
    "duration": duration,
    "user_obj": userObj,
    "working_uid": workingUid,
    "working_by": workingBy,
    "discount": discount,
    "screenshot": screenshot,
    "package_type": packageType,
    "message": message,
    "title": title,
    "earnings": earnings,
    "revenue": revenue,
    "date_time": dateTime,
    "user_id": userId,
    "sim": sim,
    "price": price,
    "commission": commission,
    "phone_number": phoneNumber,
    "offer_number": offerNumber,
    "id": id,
    "status": status,
    "confirm_date_time": confirmDateTime,
  };
}