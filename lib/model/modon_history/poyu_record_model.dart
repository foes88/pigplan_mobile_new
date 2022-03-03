import 'dart:convert';

class PoyuRecordModel {

  List<PoyuRecordModel> welcomeFromJson(String str) => List<PoyuRecordModel>.from(json.decode(str).map((x) => PoyuRecordModel.fromJson(x)));

  String welcomeToJson(List<PoyuRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  PoyuRecordModel({
    required this.sancha,
    required this.gubunCd,
    required this.wkDt,
    required this.dusu,
    required this.dusuSu,
    required this.subGubunCd,
    required this.euBunYn,
    required this.bigo,
  });

  int sancha;
  String gubunCd;
  String wkDt;
  int dusu;
  int dusuSu;
  String subGubunCd;
  String euBunYn;
  String bigo;

  factory PoyuRecordModel.fromJson(Map<String, dynamic> json) => PoyuRecordModel(
    sancha: json["sancha"]?? "",
    gubunCd: json["gubunCd"],
    wkDt: json["wkDt"],
    dusu: json["dusu"],
    dusuSu: json["dusuSu"],
    subGubunCd: json["subGubunCd"]??"",
    euBunYn: json["euBunYn"]??"",
    bigo: json["bigo"]??"",
  );

  Map<String, dynamic> toJson() => {
    "sancha": sancha,
    "dusu": dusu,
    "bigo": bigo,
    "gubunCd": gubunCd,
    "dusuSu": dusuSu,
    "subGubunCd": subGubunCd,
    "euBunYn": euBunYn,
  };
}