import 'package:flutter/material.dart';
import 'dart:convert';

class UdMoveinModel {

  List<UdMoveinModel> welcomeFromJson(String str) => List<UdMoveinModel>.from(json.decode(str).map((x) => UdMoveinModel.fromJson(x)));

  String welcomeToJson(List<UdMoveinModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  late String farmPigNo = "";
  late int farmNo = 0;
  late int pigNo = 0;
  late String igakNo = "";
  late String inDt = "";
  late String jasanDt = "";
  late String gubunCd = "";
  late String buyComCd = "";
  late String buyComName = "";
  late int inKg = 0;
  late String hyultongNo = "";
  late String unPigNo = "";
  late String moPigNo = "";
  late String unHyulNo = "";
  late String moHyulNo = "";
  late String rfidNo = "";
  late String pss = "";
  late String familyCd = "";
  late String bigo = "";
  late String dieYn = "";
  late String birthDt = "";
  late String pumjongCd = "";
  late String outGubunCd = "";
  late String outReasonCd = "";
  late String udStatusNm = "";
  late String boarAge = "";
  late String outDate = "";
  late String outDt = "";
  late String logUptDt = "";
  late String logUptId = "";
  late int gyobaeUseCnt = 0;


  UdMoveinModel({
    required this.farmPigNo,
    required this.farmNo,
    required this.pigNo,
    required this.igakNo,
    required this.inDt,
    required this.jasanDt,
    required this.gubunCd,
    required this.buyComCd,
    required this.buyComName,
    required this.inKg,
    required this.hyultongNo,
    required this.unPigNo,
    required this.moPigNo,
    required this.unHyulNo,
    required this.moHyulNo,
    required this.rfidNo,
    required this.pss,
    required this.familyCd,
    required this.bigo,
    required this.dieYn,
    required this.birthDt,
    required this.pumjongCd,
    required this.outGubunCd,
    required this.outReasonCd,
    required this.udStatusNm,
    required this.boarAge,
    required this.outDate,
    required this.outDt,
    required this.logUptDt,
    required this.logUptId,
    required this.gyobaeUseCnt,
  });

  factory UdMoveinModel.fromJson(Map<String, dynamic> json) => UdMoveinModel(
    farmPigNo: json['farmPigNo'] ?? "",
    farmNo: json['farmNo'] ?? 0,
    pigNo: json['pigNo'] ?? 0,
    igakNo: json['igakNo'] ?? "",
    inDt: json['inDt'] ?? "",
    jasanDt: json['jasanDt'] ?? "",
    gubunCd: json['gubunCd'] ?? "",
    buyComCd: json['buyComCd'] ?? "",
    buyComName: json['buyComName'] ?? "",
    inKg: json['inKg'] ?? 0,
    hyultongNo: json['hyultongNo'] ?? "",
    unPigNo: json['unPigNo'] ?? "",
    moPigNo: json['moPigNo'] ?? "",
    unHyulNo: json['unHyulNo'] ?? "",
    moHyulNo: json['moHyulNo'] ?? "",
    rfidNo: json['rfidNo'] ?? "",
    pss: json['pss'] ?? "",
    familyCd: json['familyCd'] ?? "",
    bigo: json['bigo'] ?? "",
    dieYn: json['dieYn'] ?? "",
    birthDt: json['birthDt'] ?? "",
    pumjongCd: json['pumjongCd'] ?? "",
    outGubunCd: json['outGubunCd'] ?? "",
    outReasonCd: json['outReasonCd'] ?? "",
    udStatusNm: json['udStatusNm'] ?? "",
    boarAge: json['boarAge'] ?? "",
    outDate: json['outDate'] ?? "",
    outDt: json['outDt'] ?? "",
    logUptDt: json['logUptDt'] ?? "",
    logUptId: json['logUptId'] ?? "",
    gyobaeUseCnt: json['gyobaeUseCnt'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "farmPigNo": farmPigNo,
    "farmNo": farmNo,
    "pigNo": pigNo,
    "igakNo": igakNo,
    "inDt": inDt,
    "jasanDt": jasanDt,
    "gubunCd": gubunCd,
    "buyComCd": buyComCd,
    "buyComName": buyComName,
    "inKg": inKg,
    "hyultongNo": hyultongNo,
    "unPigNo": unPigNo,
    "moPigNo": moPigNo,
    "unHyulNo": unHyulNo,
    "moHyulNo": moHyulNo,
    "rfidNo": rfidNo,
    "pss": pss,
    "familyCd": familyCd,
    "bigo": bigo,
    "dieYn": dieYn,
    "birthDt": birthDt,
    "pumjongCd": pumjongCd,
    "outGubunCd": outGubunCd,
    "outReasonCd": outReasonCd,
    "udStatusNm": udStatusNm,
    "boarAge": boarAge,
    "outDate": outDate,
    "outDt": outDt,
    "logUptDt": logUptDt,
    "logUptId": logUptId,
    "gyobaeUseCnt": gyobaeUseCnt,
  };

}


