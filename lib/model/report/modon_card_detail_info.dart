import 'package:flutter/material.dart';
import 'dart:convert';

class ModonCardDetailInfoModel {

  List<ModonCardDetailInfoModel> welcomeFromJson(String str) => List<ModonCardDetailInfoModel>.from(
      json.decode(str).map((x) => ModonCardDetailInfoModel.fromJson(x)));

  String welcomeToJson(List<ModonCardDetailInfoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late String wkDt = "";
  late int san = 0;
  late int gyobaeCnt = 0;
  late int zae = 0;
  late String bunDt = "";
  late String euDt = "";
  late int imsinil = 0;
  late int pouil = 0;
  late int chongsan = 0;
  late int sasan = 0;
  late int mila = 0;

  ModonCardDetailInfoModel({
    required this.wkDt,
    required this.san,
    required this.gyobaeCnt,
    required this.zae,
    required this.bunDt,
    required this.euDt,
    required this.imsinil,
    required this.pouil,
    required this.chongsan,
    required this.sasan,
    required this.mila,

  });

  factory ModonCardDetailInfoModel.fromJson(Map<String, dynamic> json) => ModonCardDetailInfoModel(
    wkDt: json['WK_DT'] ?? "-",
    san: json['SAN'] ?? 0,
    gyobaeCnt: json['GYOBAE_CNT'] ?? 0,
    zae: json['ZAE'] ?? 0,
    bunDt: json['BUN_DT'] ?? "-",
    euDt: json['EU_DT'] ?? "-",
    imsinil: json['IMSINIL'] ?? 0,
    pouil: json['POUIL'] ?? 0,
    chongsan: json['CHONGSAN'] ?? 0,
    sasan: json['SASAN'] ?? 0,
    mila: json['MILA'] ?? 0,

  );

  Map<String, dynamic> toJson() => {
    "wkDt": wkDt,
    "san": san,
    "gyobaeCnt": gyobaeCnt,
    "zae": zae,
    "bunDt": bunDt,
    "euDt": euDt,
    "imsinil": imsinil,
    "pouil": pouil,
    "chongsan": chongsan,
    "sasan": sasan,
    "mila": mila,

  };

}
