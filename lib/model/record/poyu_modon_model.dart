import 'package:flutter/material.dart';
import 'dart:convert';

class PoyuModonModel {

  List<PoyuModonModel> welcomeFromJson(String str) => List<PoyuModonModel>.from(json.decode(str).map((x) => PoyuModonModel.fromJson(x)));

  String welcomeToJson(List<PoyuModonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  late String? farmPigNo = "";
  late int seq = 0;
  late int pigNo = 0;
  late String? igakNo = "";
  late int sancha = 0;
  late int chongsan = 0;
  late int silsan = 0; // int
  late int peasa = 0;
  late int inDusu = 0;
  late int euDusu = 0;
  late int pouDusu = 0;
  late String wkGubun = "";
  late String birthDt = "";
  late String bunmanDt = "";
  late String lastWkDt = "";

  PoyuModonModel({
    required this.farmPigNo,
    required this.seq,
    required this.pigNo,
    required this.igakNo,
    required this.sancha,
    required this.chongsan,
    required this.silsan,
    required this.peasa,
    required this.inDusu,
    required this.euDusu,
    required this.pouDusu,
    required this.wkGubun,
    required this.birthDt,
    required this.bunmanDt,
    required this.lastWkDt,
  });

  factory PoyuModonModel.fromJson(Map<String, dynamic> json) => PoyuModonModel(
    farmPigNo: json['farmPigNo'] ?? "",
    seq: json['seq'] ?? 0,
    pigNo: json['pigNo'] ?? 0,
    igakNo: json['igakNo'] ?? "",
    sancha: json['sancha'] ?? 0,
    chongsan: json['chongsan'] ?? 0,
    silsan: json['silsan'] ?? 0,
    peasa: json['peasa'] ?? 0,
    inDusu: json['inDusu'] ?? 0,
    euDusu: json['euDusu'] ?? 0,
    pouDusu: json['pouDusu'] ?? 0,
    wkGubun: json['wkGubun'] ?? "",
    birthDt: json['birthDt'] ?? "",
    bunmanDt: json['bunmanDt'] ?? "",
    lastWkDt: json['lastWkDt'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmPigNo": farmPigNo,
    "seq": seq,
    "pigNo": pigNo,
    "igakNo": igakNo,
    "sancha": sancha,
    "chongsan": chongsan,
    "silsan": silsan,
    "peasa": peasa,
    "inDusu": inDusu,
    "euDusu": euDusu,
    "pouDusu": pouDusu,
    "wkGubun": wkGubun,
    "birthDt": birthDt,
    "bunmanDt": bunmanDt,
    "lastWkDt": lastWkDt,
  };

}
