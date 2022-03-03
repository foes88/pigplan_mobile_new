import 'package:flutter/material.dart';
import 'package:pigplan_mobile/model/record/mating_record_model.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/model/record/pregnancy_accident_record_model.dart';
import 'package:xml2json/xml2json.dart';

Future<String> restApiGetXml(url) async {

  // const String _baseUrl = "http://10.0.2.2:8080/";

  final Xml2Json xml2Json = Xml2Json();
  final response = await http.get(Uri.parse(url));
  print(url);
  var jsonString = "";
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    xml2Json.parse(response.body);
    // print("json value " + xml2Json.toParker());

    jsonString = xml2Json.toParker();

    print(jsonString);

    return jsonString;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    return jsonDecode(jsonString);
  }
}



