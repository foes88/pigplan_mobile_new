import 'package:flutter/material.dart';
import 'dart:convert';

class LoginModel {

  List<LoginModel> welcomeFromJson(String str) => List<LoginModel>.from(json.decode(str).map((x) => LoginModel.fromJson(x)));

  String welcomeToJson(List<LoginModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final String farmNm;
  late final String farmNo;
  late final bool success;

  LoginModel(
      {required this.farmNm, required this.farmNo, required this.success}
      );

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    farmNm: json['farmNm'] ?? "",
    farmNo: json['farmNo'] ?? "",
    success: json['success'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "farmNm": farmNm,
    "farmNo": farmNo,
    "success": success,
  };

}
