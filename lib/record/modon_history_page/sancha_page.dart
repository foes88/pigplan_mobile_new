import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/model/modon_history/sancha_record_model.dart';

class SanchaListPage extends StatefulWidget {

  final int pigNo;

  const SanchaListPage({
    Key? key,
    required this.pigNo,
}) : super(key: key);

  @override
  _SanchaListPage createState() => _SanchaListPage(pigNo);
}

class _SanchaListPage extends State<SanchaListPage> with AutomaticKeepAliveClientMixin<SanchaListPage>{

  late List<SanchaRecordModel> sanchaLists = [];
  final int pigNo;

  _SanchaListPage(this.pigNo);

  @override
  void initState() {
    super.initState();
    setState(() {
      getSanchaRecord(pigNo);
    });
  }

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
                DataColumn(label: Text('교배산차',),),
                DataColumn(label: Text('교배일')),
                DataColumn(label: Text('사고일')),
                DataColumn(label: Text('분만일')),
                DataColumn(label: Text('총산')),
                DataColumn(label: Text('실산')),
                DataColumn(label: Text('이유일')),
                DataColumn(label: Text('이유두수(이유/부분)')),
                DataColumn(label: Text('재포유')),
              ],
              rows: sanchaLists
                  .map(
                ((element) => DataRow(
                  cells: [
                    DataCell(Text((element.gSancha).toString())),
                    DataCell(Text((element.gyeDt).toString())),
                    DataCell(Text((element.sagoDt).toString())),
                    DataCell(Text((element.bunDt).toString())),
                    DataCell(Text((element.chongsan).toString())),
                    DataCell(Text(element.silsan.toString())),
                    DataCell(Text(element.euDt)),
                    DataCell(Text(element.euDusu)),
                    DataCell(Text(element.daeriYn)),
                  ],
                )),
              ).toList(),
            ),
          ),
    );

  }

  final String _baseUrl = "http://192.168.3.46:8080";
  // 산차기록
  Future<List<SanchaRecordModel>> getSanchaRecord(int pigNo) async {

    List<SanchaRecordModel> list = List<SanchaRecordModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = "/sharing/common/mdSanchaWriteHistoryList.json";
    var parameters = json.encode({
      'pigNo': pigNo,
      'dateFormat': 'yyyy-MM-dd',
      'lang': 'ko',
      'searchSort': 'SANCHA ASC,GYOBAE_CNT ASC',
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
        list.add(SanchaRecordModel.fromJson(data[i]));
      }

      //print("산차기록");
      sanchaLists = list;

      return sanchaLists;
    } else {
      throw Exception('error');
    }
  }

  @override
  bool get wantKeepAlive => true;

}

