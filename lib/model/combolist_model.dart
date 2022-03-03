import 'package:flutter/material.dart';
import 'dart:convert';

class ComboListModel {

  List<ComboListModel> welcomeFromJson(String str) => List<ComboListModel>.from(
      json.decode(str).map((x) => ComboListModel.fromJson(x)));

  String welcomeToJson(List<ComboListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late String code = "";
  late String cname = "";
  late String pcode = "";
  late String cvalue = "";

  ComboListModel({
    required this.code,
    required this.cname,
    required this.pcode,
    required this.cvalue,
  });

  factory ComboListModel.fromJson(Map<String, dynamic> json) => ComboListModel(
    code: json['code'] ?? "",
    cname: json['cname'] ?? "",
    pcode: json['pcode'] ?? "",
    cvalue: json['cvalue'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "cname": cname,
    "pcode": pcode,
    "cvalue": cvalue,
  };

}
