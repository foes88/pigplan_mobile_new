import 'dart:convert';

class EyuRecordModel {

  List<EyuRecordModel> welcomeFromJson(String str) => List<EyuRecordModel>.from(json.decode(str).map((x) => EyuRecordModel.fromJson(x)));

  String welcomeToJson(List<EyuRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  EyuRecordModel({
    required this.sancha,
    required this.wkDt,
    required this.dusu,
    required this.totalDusu,
    required this.eudusu,
    required this.eudusuSu,
    required this.jeapou,
    required this.suckle,
    required this.suckleSu,
    required this.ilryung,
    required this.totalKg,
    required this.bigo,
  });

  int sancha;
  String wkDt;
  int dusu;
  int totalDusu;
  int eudusu;
  int eudusuSu;
  int jeapou;
  int suckle;
  int suckleSu;
  int ilryung;
  double totalKg;
  String bigo;

  factory EyuRecordModel.fromJson(Map<String, dynamic> json) => EyuRecordModel(
    sancha: json["sancha"]?? 0,
    wkDt: json["wkDt"],
    dusu: json["dusu"]?? 0,
    totalDusu: json["totalDusu"],
    eudusu: json["eudusu"],
    eudusuSu: json["eudusuSu"],
    jeapou: json["jeapou"],
    suckle: json["suckle"],
    suckleSu: json["suckleSu"],
    ilryung: json["ilryung"],
    totalKg: json["totalKg"]??0.toDouble(),
    bigo: json["bigo"]??"",
  );

  Map<String, dynamic> toJson() => {
    "sancha": sancha,
    "wkDt": wkDt,
    "dusu": dusu,
    "totalDusu": totalDusu,
    "eudusu": eudusu,
    "eudusuSu": eudusuSu,
    "jeapou": jeapou,
    "suckle": suckle,
    "suckleSu": suckleSu,
    "ilryung": ilryung,
    "totalKg": totalKg,
    "bigo": bigo,
  };
}
