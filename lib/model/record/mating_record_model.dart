import 'package:flutter/material.dart';
import 'dart:convert';

class MatingRecordModel {

  List<MatingRecordModel> welcomeFromJson(String str) => List<MatingRecordModel>.from(json.decode(str).map((x) => MatingRecordModel.fromJson(x)));

  String welcomeToJson(List<MatingRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final int farmNo;
  late final String farmPigNo;
  late String? sancha = "";
  late String pumjongNm;
  late String? igakNo = "";
  late String wkDt = "";
  late String wkGubun = "";
  late String ungdonPigNo1 = "";
  late String ungdonPigNo2 = "";
  late String ungdonPigNo3 = "";
  late String ufarmPigNo1 = "";
  late String ufarmPigNo2 = "";
  late String ufarmPigNo3 = "";
  late String method1 = "";
  late String method2 = "";
  late String method3 = "";
  late int locCd = 0;
  late String locNm = "";
  late final int pigNo;
  late int seq = 0;
  late String? sagoGubunNm = "";
  late String bigo = "";
  late String wkPersonCd = "";

  MatingRecordModel({
    required this.farmNo,
    required this.farmPigNo,
    required this.sancha,
    required this.pumjongNm,
    required this.igakNo,
    required this.wkDt,
    required this.wkGubun,
    required this.ungdonPigNo1,
    required this.ungdonPigNo2,
    required this.ungdonPigNo3,
    required this.ufarmPigNo1,
    required this.ufarmPigNo2,
    required this.ufarmPigNo3,
    required this.method1,
    required this.method2,
    required this.method3,
    required this.locNm,
    required this.locCd,
    required this.pigNo,
    required this.seq,
    required this.sagoGubunNm,
    required this.bigo,
    required this.wkPersonCd,
  });

  factory MatingRecordModel.fromJson(Map<String, dynamic> json) => MatingRecordModel(
      farmNo: json['farmNo'],
      farmPigNo: json['farmPigNo'],
      sancha: json['sancha'] ?? "",
      pumjongNm: json['pumjongNm'] ?? "",
      igakNo: json['igakNo'] ?? "",
      wkDt: json['wkDt'] ?? "",
      wkGubun: json['wkGubun'] ?? "",
      ungdonPigNo1: json['ungdonPigNo1'] ?? "",
      ungdonPigNo2: json['ungdonPigNo2'] ?? "",
      ungdonPigNo3: json['ungdonPigNo3'] ?? "",
      ufarmPigNo1: json['ufarmPigNo1'] ?? "",
      ufarmPigNo2: json['ufarmPigNo2'] ?? "",
      ufarmPigNo3: json['ufarmPigNo3'] ?? "",
      method1: json['method1'] ?? "",
      method2: json['method2'] ?? "",
      method3: json['method3'] ?? "",
      locNm: json['locNm'] ?? "",
      locCd: json['locCd'] ?? 0,
      pigNo: json['pigNo'] ?? "",
      seq: json['seq'] ?? 0,
      sagoGubunNm: json['sagoGubunNm'] ?? "",
      bigo: json['bigo'] ?? "",
      wkPersonCd: json['wkPersonCd'] ?? "",
    );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "farmPigNo": farmPigNo,
    "sancha": sancha,
    "pumjongNm": pumjongNm,
    "igakNo": igakNo,
    "wkDt": wkDt,
    "wkGubun": wkGubun,
    "ungdonPigNo1": ungdonPigNo1,
    "ungdonPigNo2": ungdonPigNo2,
    "ungdonPigNo3": ungdonPigNo3,
    "ufarmPigNo1": ufarmPigNo1,
    "ufarmPigNo2": ufarmPigNo2,
    "ufarmPigNo3": ufarmPigNo3,
    "method1": method1,
    "method2": method2,
    "method3": method3,
    "locNm": locNm,
    "locCd": locCd,
    "pigNo": pigNo,
    "seq": seq,
    "sagoGubunNm": sagoGubunNm,
    "bigo": bigo,
    "wkPersonCd": wkPersonCd,
  };

}
