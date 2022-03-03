import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/model/modon_history/location_record_model.dart';

class LocationListPage extends StatefulWidget {

  final int pigNo;

  const LocationListPage({
    Key? key,
    required this.pigNo,
  }) : super(key: key);
  @override
  _LocationListPage createState() => _LocationListPage(pigNo);
}

class _LocationListPage extends State<LocationListPage> with AutomaticKeepAliveClientMixin<LocationListPage> {

  late List<LocationRecordModel> locationLists = List<LocationRecordModel>.empty(growable: true);
  final int pigNo;

  _LocationListPage(this.pigNo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortAscending: true,
          headingRowHeight: 30,
          dataRowHeight: 30,
          // 컬럼 헤더 색상
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey.shade50),
          columns: const <DataColumn>[
            DataColumn(label: Text('산차')),
            DataColumn(label: Text('이동일')),
            DataColumn(label: Text('돈사종류')),
            DataColumn(label: Text('돈사')),
            DataColumn(label: Text('돈방')),
            DataColumn(label: Text('분만틀')),
          ],
          rows: locationLists
              .map(
            ((element) => DataRow(
              cells: [
                DataCell(Text((element.san).toString())),
                DataCell(Text((element.moveDt).toString())),
                DataCell(Text((element.donsaGubunNm).toString())),
                DataCell(Text((element.donsaNm).toString())),
                DataCell(Text((element.locNm).toString())),
                DataCell(Text((element.fwNm).toString())),
              ],
            )),
          ).toList(),
        ),
      ),
    );

  }

  String _baseUrl = "http://192.168.3.46:8080";
// 산차기록
  Future<List<LocationRecordModel>> getPoyuList(int pigNo) async {

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/sharing/common/mdLocHistoryList.json";
    var parameters = json.encode({
      'lang': 'ko',
      'singleOneSelect':' Y',
      'sowBoar': 'S',
      'searchSort': 'SANCHA DESC,GYOBAE_CNT DESC,MOVE_DT DESC',
      'pigNo': pigNo,
    });

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameters
    );

    var statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(response.body);

      for (int i = 0; i < data.length; i++) {
        locationLists.add(LocationRecordModel.fromJson(data[i]));
      }

      setState(() { });

      return locationLists;
    } else {
      throw Exception('error');
    }
  }

  @override
  bool get wantKeepAlive => true;

}