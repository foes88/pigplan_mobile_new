import 'package:flutter/material.dart';
import 'dart:convert';

class PregnancyAccidentRecordModel {

  List<PregnancyAccidentRecordModel> welcomeFromJson(String str) => List<PregnancyAccidentRecordModel>.from(json.decode(str).map((x) => PregnancyAccidentRecordModel.fromJson(x)));

  String welcomeToJson(List<PregnancyAccidentRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final int farmNo;
  late final String farmPigNo;
  late String sancha = "";
  late final int pigNo;
  late String? igakNo = "";
  late String? pumjongNm = "";
  late String? locNm = "";
  late String? wkGubunNm = "";
  late String? sagoGubunNm = "";
  late String? wkDt = "";
  late String? wkDtP = "";
  late String? wkGubun = "";
  late int? seq = 0;
  late String? sagoGubunCd = "";
  late String? dieOutYn = "";
  late String? bigo = "";
  late String? targetWkDt = "";
  late String? passDt = "";

  PregnancyAccidentRecordModel({
    required this.farmNo, required this.farmPigNo, required this.sancha, required this.igakNo,
    required this.pigNo, required this.pumjongNm, required this.locNm, required this.wkGubunNm,
    required this.sagoGubunNm, required this.wkDt, required this.wkDtP, required this.seq, required this.wkGubun,
    required this.sagoGubunCd, required this.dieOutYn, required this.bigo, required this.targetWkDt, required this.passDt,
  });

  factory PregnancyAccidentRecordModel.fromJson(Map<String, dynamic> json) => PregnancyAccidentRecordModel(
    farmNo: json['farmNo'],
    farmPigNo: json['farmPigNo'],
    sancha: json['sancha'] ?? "",
    igakNo: json['igakNo'] ?? "",
    pigNo: json['pigNo'],
    // null 체크
    pumjongNm: json['pumjongNm'] ?? "",
    locNm: json['locNm'] ?? "",
    wkGubunNm: json['wkGubunNm'] ?? "",
    sagoGubunNm: json['sagoGubunNm'] ?? "",
    wkDt: json['wkDt'] ?? "",
    wkDtP: json['wkDtP'] ?? "",
    wkGubun: json['wkGubun'] ?? "",
    seq: json['seq'] ?? 0,
    sagoGubunCd: json['sagoGubunCd'] ?? "",
    dieOutYn: json['dieOutYn'] ?? "",
    bigo: json['bigo'] ?? "",
    targetWkDt: json['targetWkDt'] ?? "",
      passDt: json['passDt'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "farmPigNo": farmPigNo,
    "sancha": sancha,
    "igakNo": igakNo,
    "pigNo": pigNo,
    "pumjongNm": pumjongNm,
    "locNm": locNm,
    "wkGubunNm": wkGubunNm,
    "sagoGubunNm": sagoGubunNm,
    "wkDt": wkDt,
    "wkDtP": wkDtP,
    "wkGubun": wkGubun,
    "seq": seq,
    "sagoGubunCd": sagoGubunCd,
    "dieOutYn": dieOutYn,
    "bigo": bigo,
    "targetWkDt": targetWkDt,
    "passDt": passDt,
  };

}

