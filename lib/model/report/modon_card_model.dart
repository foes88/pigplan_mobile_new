import 'package:flutter/material.dart';
import 'dart:convert';

class ModonCardModel {

  List<ModonCardModel> welcomeFromJson(String str) => List<ModonCardModel>.from(
      json.decode(str).map((x) => ModonCardModel.fromJson(x)));

  String welcomeToJson(List<ModonCardModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late String farmPigNo = "";
  late int pigNo = 0;
  late String? igakNo = "";
  late String wkDt = "";
  late int seq = 0;
  late int sancha = 0;
  late String pumjongCd = "";
  late String statusCd = "";
  late int chogyobaeDt = 0;
  late String lastWkDt = "";

  ModonCardModel({
    required this.farmPigNo,
    required this.pigNo,
    required this.igakNo,
    required this.wkDt,
    required this.seq,
    required this.sancha,
    required this.pumjongCd,
    required this.statusCd,
    required this.chogyobaeDt,
    required this.lastWkDt,
  });

  factory ModonCardModel.fromJson(Map<String, dynamic> json) => ModonCardModel(
    farmPigNo: json['farmPigNo'] ?? "",
    pigNo: json['pigNo'] ?? 0,
    igakNo: json['igakNo'] ?? "",
    wkDt: json['wkDt'] ?? "",
    seq: json['seq'] ?? 0,
    sancha: json['sancha'] ?? 0,
    pumjongCd: json['pumjongCd'] ?? "",
    statusCd: json['statusCd'] ?? "",
    chogyobaeDt: json['chogyobaeDt'] ?? 0,
    lastWkDt: json['lastWkDt'] ?? "",

  );

  Map<String, dynamic> toJson() => {
    "farmPigNo": farmPigNo,
    "pigNo": pigNo,
    "igakNo": igakNo,
    "wkDt": wkDt,
    "seq": seq,
    "sancha": sancha,
    "pumjongCd": pumjongCd,
    "statusCd": statusCd,
    "chogyobaeDt": chogyobaeDt,
    "lastWkDt": lastWkDt,

  };

}
