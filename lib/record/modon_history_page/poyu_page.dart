import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/model/modon_history/poyu_record_model.dart';

class PoyuListPage extends StatefulWidget {

  final int pigNo;

  const PoyuListPage({
    Key? key,
    required this.pigNo,
  }) : super(key: key);

  @override
  _PoyuListPage createState() => _PoyuListPage(pigNo);
}

class _PoyuListPage extends State<PoyuListPage> with AutomaticKeepAliveClientMixin<PoyuListPage> {

  late List<PoyuRecordModel> poyuLists = List<PoyuRecordModel>.empty(growable: true);
  final int pigNo;

  _PoyuListPage(this.pigNo);

  @override
  void initState() {
    super.initState();
    setState(() {
      getPoyuList(pigNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            sortAscending: true,
            headingRowHeight: 30,
            dataRowHeight: 30,
            // 컬럼 헤더 색상
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey.shade50),
            columns: const <DataColumn>[
              DataColumn(label: Text('산차')),
              DataColumn(label: Text('구분')),
              DataColumn(label: Text('일자')),
              DataColumn(label: Text('두수(암)')),
              DataColumn(label: Text('두수(수)')),
              DataColumn(label: Text('원인')),
              DataColumn(label: Text('기록')),
              DataColumn(label: Text('비고')),
            ],
            rows: poyuLists
                .map(
              ((element) => DataRow(
                cells: [
                  DataCell(Text(element.sancha.toString())),
                  DataCell(Text(element.gubunCd)),
                  DataCell(Text(element.wkDt)),
                  DataCell(Text(element.dusu.toString())),
                  DataCell(Text(element.dusuSu.toString())),
                  DataCell(Text(element.subGubunCd)),
                  DataCell(Text(element.euBunYn)),
                  DataCell(Text(element.bigo)),
                ],
              )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  String _baseUrl = "http://192.168.3.46:8080";
// 포유자돈
  Future<List<PoyuRecordModel>> getPoyuList(int pigNo) async {

    //List<SanchaRecordModel> list = List<SanchaRecordModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/sharing/common/mdYangjaHistoryList.json";
    var parameters = json.encode({
      'lang': 'ko',
      'singleOneSelect':'Y',
      'sowBoar':'S',
      'searchSort':'JT.SANCHA DESC,JT.WK_DT DESC,JT.LOG_INS_DT DESC',
      'pigNo':pigNo
    });

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
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
        poyuLists.add(PoyuRecordModel.fromJson(data[i]));
      }

      //print("산차기록");
      print(data);
      setState(() { });

      return poyuLists;
    } else {
      throw Exception('error');
    }
  }

  @override
  bool get wantKeepAlive => true;

}