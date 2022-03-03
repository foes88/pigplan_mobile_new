import 'package:flutter/material.dart';
import 'dart:convert';

class MdDiedSellModel {

  List<MdDiedSellModel> welcomeFromJson(String str) => List<MdDiedSellModel>.from(json.decode(str).map((x) => MdDiedSellModel.fromJson(x)));

  String welcomeToJson(List<MdDiedSellModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  late String farmPigNo = "";
  late int farmNo = 0;
  late int seq = 0;
  late int pigNo = 0;
  late String? igakNo = "";
  late String pumjongCd = "";
  late String pumjongNm = "";
  late String outGubunCd = "";
  late String outReasonCd = "";
  late String outReasonDetail = "";
  late String saleComCd = "";
  late String salePrice = "";
  late String outKg = "";
  late int ck = 0;
  late String saleComNm = "";
  late String etcTradeYn = "";
  late String logUptDt = "";
  late String logUptId = "";
  late String youtFarmPigNo = "";
  late String wkDt = "";
  late String? sagoGubunNm = "";
  late String wkGubun = "";
  late String bigo = "";
  late int sancha = 0;

  MdDiedSellModel({
    required this.farmPigNo,
    required this.seq,
    required this.pigNo,
    required this.igakNo,
    required this.pumjongCd,
    required this.pumjongNm,
    required this.outGubunCd,
    required this.outReasonCd,
    required this.outReasonDetail,
    required this.saleComCd,
    required this.salePrice,
    required this.outKg,
    required this.ck,
    required this.saleComNm,
    required this.etcTradeYn,
    required this.logUptDt,
    required this.logUptId,
    required this.youtFarmPigNo,
    required this.wkDt,
    required this.sagoGubunNm,
    required this.wkGubun,
    required this.farmNo,
    required this.sancha,
    required this.bigo,

  });

  factory MdDiedSellModel.fromJson(Map<String, dynamic> json) => MdDiedSellModel(
    farmPigNo: json['farmPigNo'] ?? "",
    seq: json['seq'] ?? 0,
    pigNo: json['pigNo'] ?? 0,
    igakNo: json['igakNo'] ?? "",
    pumjongCd: json['pumjongCd'] ?? "",
    pumjongNm: json['pumjongNm'] ?? "",
    outGubunCd: json['outGubunCd'] ?? "",
    outReasonCd: json['outReasonCd'] ?? "",
    outReasonDetail: json['outReasonDetail'] ?? "",
    saleComCd: json['saleComCd'] ?? "",
    salePrice: json['salePrice'] ?? "",
    outKg: json['outKg'] ?? "",
    ck: json['ck'] ?? 0,
    saleComNm: json['saleComNm'] ?? "",
    etcTradeYn: json['etcTradeYn'] ?? "",
    logUptDt: json['logUptDt'] ?? "",
    logUptId: json['logUptId'] ?? "",
    youtFarmPigNo: json['youtFarmPigNo'] ?? "",
    wkDt: json['wkDt'] ?? "",
    sagoGubunNm: json['sagoGubunNm'] ?? "",
    wkGubun: json['wkGubun'] ?? "",
    farmNo: json['farmNo'] ?? 0 ,
    sancha: json['sancha'] ?? 0,
    bigo: json['bigo'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmPigNo": farmPigNo,
    "seq": seq,
    "pigNo": pigNo,
    "igakNo": igakNo,
    "pumjongCd": pumjongCd,
    "pumjongNm": pumjongNm,
    "outGubunCd": outGubunCd,
    "outReasonCd": outReasonCd,
    "outReasonDetail": outReasonDetail,
    "saleComCd": saleComCd,
    "salePrice": salePrice,
    "outKg": outKg,
    "ck": ck,
    "saleComNm": saleComNm,
    "etcTradeYn": etcTradeYn,
    "logUptDt": logUptDt,
    "logUptId": logUptId,
    "youtFarmPigNo": youtFarmPigNo,
    "wkDt": wkDt,
    "sagoGubunNm": sagoGubunNm,
    "wkGubun": wkGubun,
    "farmNo": farmNo,
    "sancha": sancha,
    "bigo": bigo,
  };

}
