import 'package:flutter/material.dart';
import 'dart:convert';

class NoticeModel {

  List<NoticeModel> welcomeFromJson(String str) => List<NoticeModel>.from(json.decode(str).map((x) => NoticeModel.fromJson(x)));

  String welcomeToJson(List<NoticeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final String title;
  late final String contents;
  late final String company;
  late final String companyNm;
  late final String startDt;
  late final String endDt;
  late final String logUptDt;
  late final String logInsDt;
  late final String noticeGbn;
  late final String noticeGbnNm;

  NoticeModel({
    required this.title, required this.contents, required this.company, required this.companyNm,
    required this.startDt, required this.endDt, required this.logUptDt,required this.logInsDt,
    required this.noticeGbn, required this.noticeGbnNm,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
      title: json['TITLE'] ?? "",
      contents: json['CONTENTS'] ?? "",
      company: json['COMPANY'] ?? "",
      companyNm: json['companyNm'] ?? "",
      startDt: json['startDt'] ?? "",
      endDt: json['endDt'] ?? "",
      logUptDt: json['LOGUPTDT'] ?? "",
      logInsDt: json['lOGINSDT'] ?? "",
      noticeGbn: json['noticeGbn'] ?? "",
      noticeGbnNm: json['noticeGbnNm'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "contents": contents,
    "company": company,
    "companyNm": companyNm,
    "startDt": startDt,
    "endDt": endDt,
    "logUptDt": logUptDt,
    "logInsDt": logInsDt,
    "noticeGbn": noticeGbn,
    "noticeGbnNm": noticeGbnNm,

  };

}
