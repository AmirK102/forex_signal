// To parse this JSON data, do
//
//     final signalModel = signalModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SignalModel signalModelFromJson(String str) => SignalModel.fromJson(json.decode(str));

String signalModelToJson(SignalModel data) => json.encode(data.toJson());

class SignalModel {
  String? id;
  String? pair;
  String? openEntru;
  String? stopLoss;
  String? tp1;
  String? tp2;
  String? tp3;
  DateTime? dateTime;
  String? status;
  String? market;
  String? action;
  bool? isComplete;
  bool? isTp1Complete;
  bool? isTp2Complete;
  bool? isTp3Complete;
  bool? isSlComplete;

  SignalModel({
    this.id,
    this.pair,
    this.openEntru,
    this.stopLoss,
    this.tp1,
    this.tp2,
    this.tp3,
    this.dateTime,
    this.status,
    this.market,
    this.action,
    this.isComplete,
    this.isTp1Complete,
    this.isTp2Complete,
    this.isTp3Complete,
    this.isSlComplete,
  });

  factory SignalModel.fromJson(Map<String, dynamic> json) => SignalModel(
    id: json["id"],
    pair: json["pair"],
    openEntru: json["open_entru"],
    stopLoss: json["stop_loss"],
    tp1: json["tp1"],
    tp2: json["tp2"],
    tp3: json["tp3"],
    dateTime: json["date_time"] == null ? null : (json["date_time"] as Timestamp).toDate(),
    status: json["status"],
    market: json["market"],
    action: json["action"],
    isComplete: json["isComplete"],
    isTp1Complete: json["isTp1Complete"],
    isTp2Complete: json["isTp2Complete"],
    isTp3Complete: json["isTp3Complete"],
    isSlComplete: json["isSlComplete"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pair": pair,
    "open_entru": openEntru,
    "stop_loss": stopLoss,
    "tp1": tp1,
    "tp2": tp2,
    "tp3": tp3,
    "date_time": dateTime,
    "status": status,
    "market": market,
    "action": action,
    "isComplete": isComplete,
    "isTp1Complete": isTp1Complete,
    "isTp2Complete": isTp2Complete,
    "isTp3Complete": isTp3Complete,
    "isSlComplete": isSlComplete,
  };
}
