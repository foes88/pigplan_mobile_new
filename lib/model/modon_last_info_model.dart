import 'package:flutter/material.dart';
import 'dart:convert';

class modonLastInfoModel {

  List<modonLastInfoModel> welcomeFromJson(String str) => List<modonLastInfoModel>.from(json.decode(str).map((x) => modonLastInfoModel.fromJson(x)));

  String welcomeToJson(List<modonLastInfoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late int farmNo = 0;
  late final String farmPigNo;
  late String? sancha = "";
  late final int pigNo;
  late String? igakNo = "";
  late String? dieOutYn = "";
  late String statusNmE = "";

  modonLastInfoModel({
    required this.farmNo, required this.farmPigNo, required this.sancha, required this.igakNo,
    required this.pigNo, required this.dieOutYn, required this.statusNmE,
  });

  factory modonLastInfoModel.fromJson(Map<String, dynamic> json) => modonLastInfoModel(
    farmNo: json['farmNo'] ?? 0,
    farmPigNo: json['farmPigNo'],
    sancha: json['sancha'] ?? "",
    igakNo: json['igakNo'] ?? "",
    pigNo: json['pigNo'],
    dieOutYn: json['dieOutYn'] ?? "",
    statusNmE: json['statusNmE'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "farmPigNo": farmPigNo,
    "sancha": sancha,
    "igakNo": igakNo,
    "pigNo": pigNo,
    "dieOutYn": dieOutYn,
    "statusNmE": statusNmE,
  };

}

