import 'dart:convert';

class ModonHistoryModel {

  List<ModonHistoryModel> welcomeFromJson(String str) => List<ModonHistoryModel>.from(json.decode(str).map((x) => ModonHistoryModel.fromJson(x)));

  String welcomeToJson(List<ModonHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  ModonHistoryModel({
    required this.gSancha,
    required this.gyeDt,
    required this.gyeDt2,
    required this.bunDt,
    required this.chongsan,
    required this.silsan,
    required this.euDt,
    required this.euDusu,
    required this.daeriYn,
    required this.sancha,
    required this.gdt,
    required this.wkdt,
    required this.mila,
    required this.sasan,
    required this.pogae,
    required this.dotae,
    required this.junSum,
    required this.avgKg,
    required this.saengsiKg,
    required this.locNm,
    required this.dusu,
    required this.ilryung,
    required this.totalKg,
    required this.jeapou,
    required this.bigo,
    required this.gubunCd,
    required this.dusuSu,
    required this.subGubunCd,
    required this.euBunYn,
    required this.san,
    required this.wkName,
    required this.healDt,
    required this.healMethodCd,
    required this.articleNm,
    required this.useVolume,
    required this.moveDt,
    required this.donsaGubunNm,
    required this.donsaNm,
    required this.fwNm,
  });

  String gSancha;
  String gyeDt;
  String gyeDt2;
  String bunDt;
  int chongsan;
  int silsan;
  String euDt;
  String euDusu;
  String daeriYn;
  int sancha;
  String gdt;
  String wkdt;
  int mila;
  int sasan;
  int pogae;
  int dotae;
  String junSum;
  double avgKg;
  double saengsiKg;
  String locNm;
  String dusu;
  int ilryung;
  double totalKg;
  String jeapou;
  String bigo;
  String gubunCd;
  int dusuSu;
  String subGubunCd;
  String euBunYn;
  String san;
  String wkName;
  String healDt;
  String healMethodCd;
  String articleNm;
  double useVolume;
  String moveDt;
  String donsaGubunNm;
  String donsaNm;
  String fwNm;

  factory ModonHistoryModel.fromJson(Map<String, dynamic> json) => ModonHistoryModel(
    gSancha: json["gSancha"]?? "",
    gyeDt: json["gyeDt"]?? "",
    gyeDt2: json["gyeDt2"]?? "",
    bunDt: json["bunDt"]?? "",
    chongsan: json["chongsan"]?? "",
    silsan: json["silsan"]?? "",
    euDt: json["euDt"]?? "",
    euDusu: json["euDusu"]?? "",
    daeriYn: json["daeriYn"]?? "",
    sancha: json["sancha"]?? "",
    gdt: json["gdt"]?? "",
    wkdt: json["wkdt"]?? "",
    mila: json["mila"],
    sasan: json["sasan"],
    pogae: json["pogae"],
    dotae: json["dotae"],
    junSum: json["junSum"],
    avgKg: json["avgKg"]??0.toDouble(),
    saengsiKg: json["saengsiKg"]??0.toDouble(),
    locNm: json["locNm"],
    dusu: json["dusu"],
    ilryung: json["ilryung"],
    totalKg: json["totalKg"]??0.toDouble(),
    jeapou: json["jeapou"],
    bigo: json["bigo"],
    gubunCd: json["gubunCd"],
    dusuSu: json["dusuSu"],
    subGubunCd: json["subGubunCd"],
    euBunYn: json["euBunYn"],
    san: json["san"],
    wkName: json["wkName"],
    healDt: json["healDt"],
    healMethodCd: json["healMethodCd"],
    articleNm: json["articleNm"],
    useVolume: json["useVolume"]??0.toDouble(),
    moveDt: json["moveDt"],
    donsaGubunNm: json["donsaGubunNm"],
    donsaNm: json["donsaNm"],
    fwNm: json["fwNm"],
  );

  Map<String, dynamic> toJson() => {
    //"gSancha": gSancha,
    "gyeDt": gyeDt,
    "gyeDt2": gyeDt2,
    "bunDt": bunDt,
    "chongsan": chongsan,
    "silsan": silsan,
    "euDt": euDt,
    "euDusu": euDusu,
    "daeriYn": daeriYn,
    "sancha": sancha,
    "gdt": gdt,
    "wkdt": wkdt,
    "mila": mila,
    "sasan": sasan,
    "pogae": pogae,
    "dotae": dotae,
    "junSum": junSum,
    "avgKg": avgKg,
    "saengsiKg": saengsiKg,
    "locNm": locNm,
    "dusu": dusu,
    "ilryung": ilryung,
    "totalKg": totalKg,
    "jeapou": jeapou,
    "bigo": bigo,
    "gubunCd": gubunCd,
    "dusuSu": dusuSu,
    "subGubunCd": subGubunCd,
    "euBunYn": euBunYn,
    "san": san,
    "wkName": wkName,
    "healDt": healDt,
    "healMethodCd": healMethodCd,
    "articleNm": articleNm,
    "useVolume": useVolume,
    "moveDt": moveDt,
    "donsaGubunNm": donsaGubunNm,
    "donsaNm": donsaNm,
    "fwNm": fwNm,
  };
}
