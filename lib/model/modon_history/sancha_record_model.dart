import 'dart:convert';

class SanchaRecordModel {

  List<SanchaRecordModel> welcomeFromJson(String str) => List<SanchaRecordModel>.from(json.decode(str).map((x) => SanchaRecordModel.fromJson(x)));

  String welcomeToJson(List<SanchaRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  SanchaRecordModel({
    required this.gSancha,
    required this.gyeDt,
    required this.gyeDt2,
    required this.sagoDt,
    required this.bunDt,
    required this.chongsan,
    required this.silsan,
    required this.euDt,
    required this.euDusu,
    required this.daeriYn,
  });

  String? gSancha = "";
  String? gyeDt = "";
  String? gyeDt2 = "";
  String? sagoDt = "";
  String? bunDt = "";
  int chongsan = 0;
  int silsan = 0;
  String euDt = "";
  String euDusu = "";
  String daeriYn = "";

  factory SanchaRecordModel.fromJson(Map<String, dynamic> json) => SanchaRecordModel(
    gSancha: json["gSancha"]?? "",
    gyeDt: json["gyeDt"]?? "",
    gyeDt2: json["gyeDt2"]?? "",
    sagoDt: json["sagoDt"]?? "",
    bunDt: json["bunDt"]?? "",
    chongsan: json["chongsan"]?? 0,
    silsan: json["silsan"]?? 0,
    euDt: json["euDt"]?? "",
    euDusu: json["euDusu"]?? "",
    daeriYn: json["daeriYn"]?? "",
  );

  Map<String, dynamic> toJson() => {
    //"gSancha": gSancha,
    "gyeDt": gyeDt,
    "gyeDt2": gyeDt2,
    "sagoDt": sagoDt,
    "bunDt": bunDt,
    "chongsan": chongsan,
    "silsan": silsan,
    "euDt": euDt,
    "euDusu": euDusu,
    "daeriYn": daeriYn,
  };
}
