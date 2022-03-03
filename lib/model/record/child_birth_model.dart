import 'package:flutter/material.dart';
import 'dart:convert';

class ChildBirthModel {

  List<ChildBirthModel> welcomeFromJson(String str) => List<ChildBirthModel>.from(json.decode(str).map((x) => ChildBirthModel.fromJson(x)));

  String welcomeToJson(List<ChildBirthModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  late int farmNo = 0;
  late String farmPigNo = "";
  late int pigNo = 0;
  late String? igakNo = "";
  late String wkDt = "";
  late String wkDtP = "";
  late String gdt = "";
  late int passDt = 0;
  late String? bDt = "";
  late int seq = 0;
  late int trSeq = 0;
  late int sancha = 0;
  late String? san = "";
  late int locCd = 0;
  late String locNm = "";
  late String bigo = "";
  late String? bunmanGubunCd = "";
  late int chongSan = 0;
  late int silsan = 0;
  late int silsanAm = 0;
  late int silsanSu = 0;
  late int mila = 0;
  late int sasan = 0;
  late double saengsiKg  = 0;
  late int cm = 0;
  late int gh = 0;
  late int sh = 0;
  late int cs = 0;
  late int tj = 0;
  late int ab = 0;
  late int sk = 0;
  late int kj = 0;
  late int gt = 0;
  late int yinPigNo = 0;
  late int youtFarmPigNo = 0;
  late int youtSeq = 0;
  late int pogae = 0;
  late double avgKg = 0;
  late int junip = 0;
  late int junipDusu = 0;
  late int junipDusuSu = 0;
  late int junchul = 0;
  late int junchulDusu = 0;
  late int junchulDusuSu = 0;
  late int ck = 0;
  late int dusu = 0;
  late String subGubunCd = "";
  late String euBunYn = "";
  late String logUptDt = "";
  late String logUptId = "";
  late String sagoGubunNm = "";
  late String wkGubun = "";

  ChildBirthModel({
    required this.farmNo,
    required this.farmPigNo,
    required this.pigNo,
    required this.igakNo,
    required this.wkDt,
    required this.wkDtP,
    required this.gdt,
    required this.passDt,
    required this.bDt,
    required this.seq,
    required this.trSeq,
    required this.sancha,
    required this.san,
    required this.locCd,
    required this.locNm,
    required this.bigo,
    required this.bunmanGubunCd,
    required this.chongSan,
    required this.silsan,
    required this.silsanAm,
    required this.silsanSu,
    required this.mila,
    required this.sasan,
    required this.saengsiKg,
    required this.cm,
    required this.gh,
    required this.sh,
    required this.cs,
    required this.tj,
    required this.ab,
    required this.sk,
    required this.kj,
    required this.gt,
    required this.yinPigNo,
    required this.youtFarmPigNo,
    required this.youtSeq,
    required this.pogae,
    required this.avgKg,
    required this.junip,
    required this.junipDusu,
    required this.junipDusuSu,
    required this.junchul,
    required this.junchulDusu,
    required this.junchulDusuSu,
    required this.ck,
    required this.dusu,
    required this.subGubunCd,
    required this.euBunYn,
    required this.logUptDt,
    required this.logUptId,
    required this.sagoGubunNm,
    required this.wkGubun,
  });

  factory ChildBirthModel.fromJson(Map<String, dynamic> json) => ChildBirthModel(
    farmNo:json['farmNo'] ?? 0,
    farmPigNo:json['farmPigNo'] ?? "",
    pigNo:json['pigNo'] ?? 0,
    igakNo:json['igakNo'] ?? "",
    wkDt:json['wkDt'] ?? "",
    wkDtP:json['wkDtP'] ?? "",
    gdt: json['gdt'] ?? "",
    passDt:json['passDt'] ?? "",
    bDt:json['bDt'] ?? "",
    seq:json['seq'] ?? 0,
    trSeq:json['trSeq'] ?? 0,
    sancha:json['sancha'] ?? 0,
    san:json['san'] ?? "",
    locCd:json['locCd'] ?? 0,
    locNm:json['locNm'] ?? "",
    bigo:json['bigo'] ?? "",
    bunmanGubunCd:json['bunmanGubunCd'] ?? "",
    chongSan:json['chongSan'] ?? 0,
    silsan:json['silsan'] ?? 0,
    silsanAm:json['silsanAm'] ?? 0,
    silsanSu:json['silsanSu'] ?? 0,
    mila:json['mila'] ?? 0,
    sasan:json['sasan'] ?? 0,
    saengsiKg:json['saengsiKg'] ?? 0,
    cm:json['cm'] ?? 0,
    gh:json['gh'] ?? 0,
    sh:json['sh'] ?? 0,
    cs:json['cs'] ?? 0,
    tj:json['tj'] ?? 0,
    ab:json['ab'] ?? 0,
    sk:json['sk'] ?? 0,
    kj:json['kj'] ?? 0,
    gt:json['gt'] ?? 0,
    yinPigNo:json['yinPigNo'] ?? 0,
    youtFarmPigNo:json['youtFarmPigNo'] ?? 0,
    youtSeq:json['youtSeq'] ?? 0,
    pogae:json['pogae'] ?? 0,
    avgKg:json['avgKg'] ?? 0,
    junip:json['junip'] ?? 0,
    junipDusu:json['junipDusu'] ?? 0,
    junipDusuSu:json['junipDusuSu'] ?? 0,
    junchul:json['junchul'] ?? 0,
    junchulDusu:json['junchulDusu'] ?? 0,
    junchulDusuSu:json['junchulDusuSu'] ?? 0,
    ck:json['ck'] ?? 0,
    dusu:json['dusu'] ?? 0,
    subGubunCd:json['subGubunCd'] ?? "",
    euBunYn:json['euBunYn'] ?? "",
    logUptDt:json['logUptDt'] ?? "",
    logUptId:json['logUptId'] ?? "",
    sagoGubunNm: json['sagoGubunNm'] ?? "",
    wkGubun: json['wkGubun'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmNo": farmNo,
    "farmPigNo": farmPigNo,
    "pigNo": pigNo,
    "igakNo": igakNo,
    "wkDt": wkDt,
    "wkDtP": wkDtP,
    "gdt": gdt,
    "passDt": passDt,
    "bDt": bDt,
    "seq": seq,
    "trSeq": trSeq,
    "sancha": sancha,
    "san": san,
    "locCd": locCd,
    "locNm": locNm,
    "bigo": bigo,
    "bunmanGubunCd": bunmanGubunCd,
    "chongSan": chongSan,
    "silsan": silsan,
    "silsanAm": silsanAm,
    "silsanSu": silsanSu,
    "mila": mila,
    "sasan": sasan,
    "saengsiKg": saengsiKg,
    "cm": cm,
    "gh": gh,
    "sh": sh,
    "cs": cs,
    "tj": tj,
    "ab": ab,
    "sk": sk,
    "kj": kj,
    "gt": gt,
    "yinPigNo": yinPigNo,
    "youtFarmPigNo": youtFarmPigNo,
    "youtSeq": youtSeq,
    "pogae": pogae,
    "avgKg": avgKg,
    "junip": junip,
    "junipDusu": junipDusu,
    "junipDusuSu": junipDusuSu,
    "junchul": junchul,
    "junchulDusu": junchulDusu,
    "junchulDusuSu": junchulDusuSu,
    "ck": ck,
    "dusu": dusu,
    "subGubunCd": subGubunCd,
    "euBunYn": euBunYn,
    "logUptDt": logUptDt,
    "logUptId": logUptId,
    "sagoGubunNm": sagoGubunNm,
    "wkGubun": wkGubun,
  };

}
