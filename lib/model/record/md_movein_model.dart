import 'package:flutter/material.dart';
import 'dart:convert';

class MdMoveinModel {

  List<MdMoveinModel> welcomeFromJson(String str) => List<MdMoveinModel>.from(json.decode(str).map((x) => MdMoveinModel.fromJson(x)));

  String welcomeToJson(List<MdMoveinModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  late String farmPigNo = "";
  late int farmNo = 0;
  late int seq = 0;
  late int pigNo = 0;
  late String? igakNo = "";
  late int ck = 0;
  late String pumjongCd = "";
  late String birthDt = "";
  late String inDt = "";
  late String lastWkDt= "";
  late String buyComCd = "";
  late String hyultongNo= "";
  late String familyCd = "";
  late String statusCd= "";
  late String rfidNo = "";
  late String buyComNm = "";
  late String logUptDt = "";
  late String logUptId = "";
  late int inSancha = 0;
  late int inGyobaeCnt = 0;
  late String bigo = "";

  MdMoveinModel({
    required this.farmPigNo,
    required this.farmNo,
    required this.seq,
    required this.pigNo,
    required this.igakNo,
    required this.ck,
    required this.pumjongCd,
    required this.birthDt,
    required this.inDt,
    required this.lastWkDt,
    required this.buyComCd,
    required this.hyultongNo,
    required this.familyCd,
    required this.statusCd,
    required this.rfidNo,
    required this.buyComNm,
    required this.logUptDt,
    required this.logUptId,
    required this.inSancha,
    required this.inGyobaeCnt,
    required this.bigo,
  });

  factory MdMoveinModel.fromJson(Map<String, dynamic> json) => MdMoveinModel(
    farmPigNo: json['farmPigNo'] ?? "",
    farmNo: json['farmNo'] ?? 0,
    seq: json['seq'] ?? 0,
    pigNo: json['pigNo'] ?? 0,
    igakNo: json['igakNo'] ?? "",
    pumjongCd: json['pumjongCd'] ?? "",
    ck: json['ck'] ?? 0,
    birthDt: json['birthDt'] ?? "",
    inDt: json['inDt'] ?? "",
    lastWkDt: json['lastWkDt'] ?? "",
    buyComCd: json['buyComCd'] ?? "",
    hyultongNo: json['hyultongNo'] ?? "",
    familyCd: json['familyCd'] ?? "",
    statusCd: json['statusCd'] ?? "",
    rfidNo: json['rfidNo'] ?? "",
    buyComNm: json['buyComNm'] ?? "",
    logUptDt: json['logUptDt'] ?? "",
    logUptId: json['logUptId'] ?? "",
    inSancha: json['inSancha'] ?? 0,
    inGyobaeCnt: json['inGyobaeCnt'] ?? 0,
      bigo: json['bigo'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmPigNo": farmPigNo,
    "farmNo": farmNo,
    "pigNo": pigNo,
    "igakNo": igakNo,
    "pumjongCd": pumjongCd,
    "ck": ck,
    "birthDt": birthDt,
    "inDt": inDt,
    "lastWkDt": lastWkDt,
    "buyComCd": buyComCd,
    "hyultongNo": hyultongNo,
    "familyCd": familyCd,
    "statusCd": statusCd,
    "rfidNo": rfidNo,
    "buyComNm": buyComNm,
    "logUptDt": logUptDt,
    "logUptId": logUptId,
    "inSancha": inSancha,
    "inGyobaeCnt": inGyobaeCnt,
    "bigo": bigo,
  };

}


