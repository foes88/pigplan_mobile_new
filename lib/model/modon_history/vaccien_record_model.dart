import 'dart:convert';

class VaccienRecordModel {

  List<VaccienRecordModel> welcomeFromJson(String str) => List<VaccienRecordModel>.from(json.decode(str).map((x) => VaccienRecordModel.fromJson(x)));

  String welcomeToJson(List<VaccienRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  VaccienRecordModel({
    required this.san,
    required this.wkName,
    required this.healDt,
    required this.healMethodCd,
    required this.articleNm,
    required this.useVolume,
    required this.gubun,
  });

  String san;
  String wkName;
  String healDt;
  String healMethodCd;
  String articleNm;
  int useVolume;
  String gubun;

  factory VaccienRecordModel.fromJson(Map<String, dynamic> json) => VaccienRecordModel(
    san: json["san"]??"",
    wkName: json["wkName"]??"",
    healDt: json["healDt"]??"",
    healMethodCd: json["healMethodCd"]??"",
    articleNm: json["articleNm"]??"",
    useVolume: json["useVolume"]??0,
      gubun: json["gubun"]??"",
  );

  Map<String, dynamic> toJson() => {
    "san": san,
    "wkName": wkName,
    "healDt": healDt,
    "healMethodCd": healMethodCd,
    "articleNm": articleNm,
    "useVolume": useVolume,
    "gubun": gubun,
  };
}
