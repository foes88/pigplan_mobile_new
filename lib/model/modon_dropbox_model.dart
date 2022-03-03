import 'package:flutter/material.dart';
import 'dart:convert';

class ModonDropboxModel {

  List<ModonDropboxModel> welcomeFromJson(String str) => List<ModonDropboxModel>.from(json.decode(str).map((x) => ModonDropboxModel.fromJson(x)));

  String welcomeToJson(List<ModonDropboxModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final int farmNo;
  late int pigNo = 0;
  late String? farmPigNo = "";
  late String? igakNo = "";
  late int seq  = 0;
  late String wkGubun = "";
  late String targetWkDt = "";
  late String wkDt = "";
  late String lastWkDt = "";
  late int sancha = 0;
  late int ilryung = 0;
  late String wkGubunStatus = "";

  ModonDropboxModel({
    required this.farmNo,
    required this.pigNo,
    required this.farmPigNo,
    required this.igakNo,
    required this.seq,
    required this.wkGubun,
    required this.targetWkDt,
    required this.wkDt,
    required this.lastWkDt,
    required this.sancha,
    required this.ilryung,
    required this.wkGubunStatus,
  });

  factory ModonDropboxModel.fromJson(Map<String, dynamic> json) => ModonDropboxModel(
    farmNo: json['farmNo'] ?? "",
    pigNo: json['pigNo'],
    farmPigNo: json['farmPigNo'] ?? "",
    igakNo: json['igakNo'] ?? "",
    seq: json['seq'] ?? 0,
    wkGubun: json['wkGubun'] ?? "",
    targetWkDt: json['targetWkDt'] ?? "",
      wkDt: json['wkDt'] ?? "",
      lastWkDt: json['lastWkDt'] ?? "",
      sancha: json['sancha'] ?? 0,
      ilryung: json['ilryung'] ?? 0,
      wkGubunStatus: json['wkGubunStatus'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "pigNo": pigNo,
    "farmPigNo": farmPigNo,
    "igakNo": igakNo,
    "seq": seq,
    "wkGubun": wkGubun,
    "targetWkDt": targetWkDt,
    "wkDt": wkDt,
    "lastWkDt": lastWkDt,
    "sancha": sancha,
    "ilryung": ilryung,
    "wkGubunStatus": wkGubunStatus,
  };

}
