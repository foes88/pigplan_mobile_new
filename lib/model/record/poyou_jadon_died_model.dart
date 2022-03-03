import 'package:flutter/material.dart';
import 'dart:convert';

class PoyouJadonDiedModel {

  List<PoyouJadonDiedModel> welcomeFromJson(String str) => List<PoyouJadonDiedModel>.from(json.decode(str).map((x) => PoyouJadonDiedModel.fromJson(x)));

  String welcomeToJson(List<PoyouJadonDiedModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final int farmNo;
  late final String farmPigNo;
  late int sancha = 0;
  late String pumjongNm;
  late String? igakNo = "";
  late String wkDt = "";        // 폐사일
  late String wkGubun = "";
  late String locNm = "";
  late final int pigNo;
  late int seq = 0;
  late String? sagoGubunNm = "";
  late String bigo = "";
  late int dusu = 0;        // 폐사두수
  late String subGubunCd = "";  // 폐사원인
  late String euBunYn = "";     // 기록
  late String logUptDt = "";
  late String logUptId = "";
  late int trSeq = 0;

  PoyouJadonDiedModel({
    required this.farmNo,
    required this.farmPigNo,
    required this.sancha,
    required this.pumjongNm,
    required this.igakNo,
    required this.wkDt,
    required this.wkGubun,
    required this.locNm,
    required this.pigNo,
    required this.seq,
    required this.sagoGubunNm,
    required this.bigo,
    required this.dusu,
    required this.subGubunCd,
    required this.euBunYn,
    required this.logUptDt,
    required this.logUptId,
    required this.trSeq,
  });

  factory PoyouJadonDiedModel.fromJson(Map<String, dynamic> json) => PoyouJadonDiedModel(
    farmNo: json['farmNo'],
    farmPigNo: json['farmPigNo'],
    sancha: json['sancha'] ?? "",
    pumjongNm: json['pumjongNm'] ?? "",
    igakNo: json['igakNo'] ?? "",
    wkDt: json['wkDt'] ?? "",
    wkGubun: json['wkGubun'] ?? "",
    locNm: json['locNm'] ?? "",
    pigNo: json['pigNo'] ?? "",
    seq: json['seq'] ?? 0,
    sagoGubunNm: json['sagoGubunNm'] ?? "",
    bigo: json['bigo'] ?? "",
    dusu: json['dusu'] ?? "",
    subGubunCd: json['subGubunCd'] ?? "",
    euBunYn: json['euBunYn'] ?? "",
    logUptDt : json['logUptDt'] ?? "",
    logUptId : json['logUptId'] ?? "",
    trSeq: json['trSeq'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "farmPigNo": farmPigNo,
    "sancha": sancha,
    "pumjongNm": pumjongNm,
    "igakNo": igakNo,
    "wkDt": wkDt,
    "wkGubun": wkGubun,
    "locNm": locNm,
    "pigNo": pigNo,
    "seq": seq,
    "sagoGubunNm": sagoGubunNm,
    "bigo": bigo,
    "dusu": dusu,
    "subGubunCd": subGubunCd,
    "euBunYn": euBunYn,
    "logUptDt": logUptDt,
    "logUptId": logUptId,
    "trSeq": trSeq,
  };

}
