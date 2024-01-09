// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? email;
  String? phone;
  String? name;
  String? loginBy;
  String? occupation;
  String? district;
  String? gender;
  String? uid;
  DateTime? createdAt;
  DateTime? lastOpenApp;
  String? profilePhoto;

  UserModel({
    this.email,
    this.phone,
    this.name,
    this.loginBy,
    this.occupation,
    this.district,
    this.gender,
    this.uid,
    this.createdAt,
    this.lastOpenApp,
    this.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    phone: json["phone"],
    name: json["name"],
    loginBy: json["login_by"],
    occupation: json["occupation"],
    district: json["district"],
    gender: json["gender"],
    uid: json["uid"],
    createdAt: json["created_at"] == null ? null : (json["created_at"] as Timestamp).toDate(),
    lastOpenApp: json["last_open_app"] == null ? null : (json["last_open_app"] as Timestamp).toDate(),
    profilePhoto: json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "phone": phone,
    "name": name,
    "login_by": loginBy,
    "occupation": occupation,
    "district": district,
    "gender": gender,
    "uid": uid,
    "created_at": createdAt,
    "last_open_app": lastOpenApp,
    "profile_photo": profilePhoto,
  };
}
