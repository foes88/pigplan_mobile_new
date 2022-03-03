import 'package:flutter/material.dart';
import 'dart:convert';

class MenuModel {

  List<MenuModel> welcomeFromJson(String str) => List<MenuModel>.from(json.decode(str).map((x) => MenuModel.fromJson(x)));

  String welcomeToJson(List<MenuModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  late final String name;
  late final String image;

  MenuModel({
    required this.name, required this.image,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    name: json['name'] ?? "",
    image: json['image'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
  };

}
