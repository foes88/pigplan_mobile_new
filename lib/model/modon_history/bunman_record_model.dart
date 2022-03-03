import 'dart:convert';

class BunmanRecordModel {

  List<BunmanRecordModel> welcomeFromJson(String str) => List<BunmanRecordModel>.from(json.decode(str).map((x) => BunmanRecordModel.fromJson(x)));

  String welcomeToJson(List<BunmanRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  BunmanRecordModel({
    required this.sancha,
    required this.gdt,
    required this.wkDt,
    required this.mila,
    required this.sasan,
    required this.silsan,
    required this.pogae,
    required this.dotae,
    required this.junSum,
    required this.avgKg,
    required this.saengsiKg,
    required this.locNm,
    required this.chonsan,
  });

  int sancha;
  String gdt;
  String wkDt;
  int mila;
  int sasan;
  int silsan;
  int pogae;
  int dotae;
  int junSum;
  double avgKg;
  double saengsiKg;
  String locNm;
  int chonsan;

  factory BunmanRecordModel.fromJson(Map<String, dynamic> json) => BunmanRecordModel(
    sancha: json["sancha"]?? 0,
    gdt: json["gdt"]?? "",
    wkDt: json["wkDt"]?? "",
    mila: json["mila"],
    sasan: json["sasan"],
    silsan: json["silsan"],
    pogae: json["pogae"],
    dotae: json["dotae"],
    junSum: json["junSum"],
    avgKg: json["avgKg"]??0.toDouble(),
    saengsiKg: json["saengsiKg"]??0.toDouble(),
    locNm: json["locNm"]??"",
    chonsan: json["chonsan"],
  );

  Map<String, dynamic> toJson() => {
    "sancha": sancha,
    "gdt": gdt,
    "wkDt": wkDt,
    "mila": mila,
    "sasan": sasan,
    "silsan": silsan,
    "pogae": pogae,
    "dotae": dotae,
    "junSum": junSum,
    "avgKg": avgKg,
    "saengsiKg": saengsiKg,
    "locNm": locNm,
    "chonsan": chonsan,
  };
}
