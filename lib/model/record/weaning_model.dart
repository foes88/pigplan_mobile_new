import 'package:flutter/material.dart';
import 'dart:convert';

class WeaningModel {

  List<WeaningModel> welcomeFromJson(String str) => List<WeaningModel>.from(json.decode(str).map((x) => WeaningModel.fromJson(x)));

  String welcomeToJson(List<WeaningModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  late int farmNo = 0;
  late String farmPigNo = "";
  late int pigNo = 0;
  late String? igakNo = "";
  late String wkDt = "";
  late int seq = 0;
  late int sancha = 0;
  late String? san = "";
  late String bigo = "";
  late int totalDusu = 0;
  late int eudusu = 0;
  late int euDusuSu = 0;
  late int ilryung = 0;
  late double totalKg = 0;
  late int maxSeq = 0;
  late String logUptDt = "";
  late String logUptId = "";
  late String wkGubun = "";
  late String euBunYn = "";
  late String autoGb = "";
  late String wkGubunStatus = "";

  WeaningModel({
    required this.farmNo,
    required this.farmPigNo,
    required this.pigNo,
    required this.igakNo,
    required this.wkDt,
    required this.seq,
    required this.sancha,
    required this.san,
    required this.bigo,
    required this.totalDusu,
    required this.eudusu,
    required this.euDusuSu,
    required this.ilryung,
    required this.totalKg,
    required this.maxSeq,
    required this.logUptDt,
    required this.logUptId,
    required this.wkGubun,
    required this.euBunYn,
    required this.autoGb,
    required this.wkGubunStatus,
  });

  factory WeaningModel.fromJson(Map<String, dynamic> json) => WeaningModel(
    farmNo:json['farmNo'] ?? 0,
    farmPigNo:json['farmPigNo'] ?? "",
    pigNo:json['pigNo'] ?? 0,
    igakNo:json['igakNo'] ?? "",
    wkDt:json['wkDt'] ?? "",
    seq:json['seq'] ?? 0,
    sancha:json['sancha'] ?? 0,
    san:json['san'] ?? "",
    bigo:json['bigo'] ?? "",
    totalDusu: json['totalDusu'] ?? 0,
    eudusu: json['eudusu'] ?? 0,
    euDusuSu: json['euDusuSu'] ?? 0,
    ilryung: json['ilryung'] ?? 0,
    totalKg: json['totalKg'] ?? 0,
    maxSeq: json['maxSeq'] ?? 0,
    logUptDt:json['logUptDt'] ?? "",
    logUptId:json['logUptId'] ?? "",
    wkGubun: json['wkGubun'] ?? "",
    euBunYn: json['euBunYn'] ?? "",
    autoGb: json['autoGb'] ?? "",
    wkGubunStatus: json['wkGubunStatus'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "farmPigNo": farmPigNo,
    "pigNo": pigNo,
    "igakNo": igakNo,
    "wkDt": wkDt,
    "seq": seq,
    "sancha": sancha,
    "san": san,
    "bigo": bigo,
    "totalDusu": totalDusu,
    "eudusu": eudusu,
    "eudusuSu": euDusuSu,
    "ilryung": ilryung,
    "totalKg": totalKg,
    "maxSeq": maxSeq,
    "logUptDt": logUptDt,
    "logUptId": logUptId,
    "wkGubun": wkGubun,
    "euBunYn": euBunYn,
    "autoGb": autoGb,
    "wkGubunStatus": wkGubunStatus,
  };

}
