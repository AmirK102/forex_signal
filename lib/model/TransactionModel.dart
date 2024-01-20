// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PostModel transactionModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String transactionModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  String? id;
  String? postTitle;
  DateTime? dateTime;
  String? postDescription;
  String? market;
  String? screenshot;
  int? like;
  int? dislike;

  PostModel({
    this.id,
    this.postTitle,
    this.dateTime,
    this.postDescription,
    this.market,
    this.like,
    this.dislike,
    this.screenshot,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"],
    postTitle: json["post_title"],

    dateTime: json["date_time"] == null ? null : (json["date_time"] as Timestamp).toDate(),
    postDescription: json["post_description"],
    market: json["market"],
    like: json["like"],
    dislike: json["dislike"],
    screenshot: json["screenshot"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "post_title": postTitle,
    "date_time": dateTime,
    "post_description": postDescription,
    "market": market,
    "like": like,
    "dislike": dislike,
    "screenshot": screenshot,
  };
}
