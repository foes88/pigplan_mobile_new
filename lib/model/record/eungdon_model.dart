import 'package:flutter/material.dart';
import 'dart:convert';

class EungdonModel {
  List<EungdonModel> welcomeFromJson(String str) => List<EungdonModel>.from(
      json.decode(str).map((x) => EungdonModel.fromJson(x)));

  String welcomeToJson(List<EungdonModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final int farmNo;
  late final int pigNo;
  late final String farmPigNo;
  late final String igakNo;
  late final String pumjongCd;
  late final String pumjongName;
  late final String dieYn;
  late final String outGubunCd;
  late final String outReasonCd;
  late final String logUptDt;
  late final String logUptId;

  EungdonModel({
    required this.farmNo,
    required this.pigNo,
    required this.farmPigNo,
    required this.igakNo,
    required this.pumjongCd,
    required this.pumjongName,
    required this.dieYn,
    required this.outGubunCd,
    required this.outReasonCd,
    required this.logUptDt,
    required this.logUptId,
  });

  factory EungdonModel.fromJson(Map<String, dynamic> json) => EungdonModel(
    farmNo: json['farmNo'] ?? 0,
    pigNo: json['pigNo'] ?? 0,
    farmPigNo: json['farmPigNo'] ?? "",
    igakNo: json['igakNo'] ?? "",
    pumjongCd: json['pumjongCd'] ?? "",
    pumjongName: json['pumjongName'] ?? "",
    dieYn: json['dieYn'] ?? "",
    outGubunCd: json['outGubunCd'] ?? "",
    outReasonCd: json['outReasonCd'] ?? "",
    logUptDt: json['logUptDt'] ?? "",
    logUptId: json['logUptId'] ?? "",
    );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "pigNo": pigNo,
    "farmPigNo": farmPigNo,
    "igakNo": igakNo,
    "pumjongCd": pumjongCd,
    "pumjongName": pumjongName,
    "dieYn": dieYn,
    "outGubunCd": outGubunCd,
    "outReasonCd": outReasonCd,
    "logUptDt": logUptDt,
    "logUptId":logUptId ,
  };


}
