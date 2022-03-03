import 'dart:convert';

class LocationRecordModel {

  List<LocationRecordModel> welcomeFromJson(String str) => List<LocationRecordModel>.from(json.decode(str).map((x) => LocationRecordModel.fromJson(x)));

  String welcomeToJson(List<LocationRecordModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  LocationRecordModel({
    required this.san,
    required this.moveDt,
    required this.donsaGubunNm,
    required this.donsaNm,
    required this.locNm,
    required this.fwNm,
  });

  String locNm;
  String san;
  String moveDt;
  String donsaGubunNm;
  String donsaNm;
  String fwNm;

  factory LocationRecordModel.fromJson(Map<String, dynamic> json) => LocationRecordModel(
    locNm: json["locNm"],
    san: json["san"],
    moveDt: json["moveDt"],
    donsaGubunNm: json["donsaGubunNm"],
    donsaNm: json["donsaNm"],
    fwNm: json["fwNm"],
  );

  Map<String, dynamic> toJson() => {
    "locNm": locNm,
    "san": san,
    "moveDt": moveDt,
    "donsaGubunNm": donsaGubunNm,
    "donsaNm": donsaNm,
    "fwNm": fwNm,
  };
}
