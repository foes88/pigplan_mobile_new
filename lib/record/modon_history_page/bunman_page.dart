import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/model/modon_history/bunman_record_model.dart';

class BunmanListPage extends StatefulWidget {

  final int pigNo;

  const BunmanListPage({
    Key? key,
    required this.pigNo,
  }) : super(key: key);

  @override
  _BunmanListPage createState() => _BunmanListPage(pigNo);
}

class _BunmanListPage extends State<BunmanListPage> with AutomaticKeepAliveClientMixin<BunmanListPage>{

  late List<BunmanRecordModel> bunmanLists = List<BunmanRecordModel>.empty(growable: true);

  final int pigNo;

  _BunmanListPage(this.pigNo);

  @override
  void initState() {
    super.initState();
    getBunmanList(pigNo);
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
            DataColumn(label: Text('산차')),
            DataColumn(label: Text('교배일')),
            DataColumn(label: Text('분만일')),
            DataColumn(label: Text('총산')),
            DataColumn(label: Text('미라')),
            DataColumn(label: Text('사산')),
            DataColumn(label: Text('실산')),
            DataColumn(label: Text('포유개시')),
            DataColumn(label: Text('생시도태')),
            DataColumn(label: Text('양자(전입/전출)')),
            DataColumn(label: Text('평균체중')),
            DataColumn(label: Text('총체중')),
            DataColumn(label: Text('분만장소')),
          ],
          rows: bunmanLists
              .map(
            ((element) => DataRow(
              cells: [
                DataCell(Text((element.sancha).toString())),
                DataCell(Text((element.gdt).toString())),
                DataCell(Text((element.wkDt).toString())),
                DataCell(Text((element.chonsan).toString())),
                DataCell(Text((element.mila).toString())),
                DataCell(Text((element.sasan).toString())),
                DataCell(Text(element.silsan.toString())),
                DataCell(Text(element.pogae.toString())),
                DataCell(Text(element.dotae.toString())),
                DataCell(Text(element.junSum.toString())),
                DataCell(Text(element.avgKg.toString())),
                DataCell(Text(element.saengsiKg.toString())),
                DataCell(Text(element.locNm.toString())),
              ],
            )),
          ).toList(),
        ),
      ),
    );

  }

  String _baseUrl = "http://192.168.3.46:8080";
// 산차기록
  Future<List<BunmanRecordModel>> getBunmanList(int pigNo) async {

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = "/pigplan/pmd/inputmd/selectBunmanList.json";

    var parameters = json.encode({
      'lang': 'ko',
      'searchPigNo': pigNo,
    });
    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?searchPigNo="+pigNo.toString();

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

      for (int i = 0; i < data["rows"].length; i++) {
        bunmanLists.add(BunmanRecordModel.fromJson(data['rows'][i]));
      }

      setState(() { });

      return bunmanLists;
    } else {
      throw Exception('error');
    }
  }

  @override
  bool get wantKeepAlive => true;

}