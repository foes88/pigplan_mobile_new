import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/common/modon_history.dart';
import 'package:pigplan_mobile/model/modon_history/eyu_record_model.dart';
import 'package:pigplan_mobile/record/modon_history_page/sancha_page.dart';

class EyuListPage extends StatefulWidget {

  final int pigNo;

  const EyuListPage({
    Key? key,
    required this.pigNo,
  }) : super(key: key);

  @override
  _EyuListPage createState() => _EyuListPage(pigNo);
}

class _EyuListPage extends State<EyuListPage> with AutomaticKeepAliveClientMixin<EyuListPage>{

  late List<EyuRecordModel> eyuLists = List<EyuRecordModel>.empty(growable: true);
  final int pigNo;

  _EyuListPage(this.pigNo);

  @override
  void initState() {
    super.initState();
    setState(() {
      getEyuList(pigNo);
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
            DataColumn(label: Text('산차')),
            DataColumn(label: Text('이유일자')),
            DataColumn(label: Text('이유두수(암/수)')),
            DataColumn(label: Text('이유일령')),
            DataColumn(label: Text('총체중')),
            DataColumn(label: Text('재포유(암/수)')),
            DataColumn(label: Text('비고')),
          ],
          rows: eyuLists
              .map(
            ((element) => DataRow(
              cells: [
                DataCell(Text((element.sancha).toString())),
                DataCell(Text((element.wkDt).toString())),
                DataCell(Text((element.wkDt).toString())),
                DataCell(Text((element.ilryung).toString())),
                DataCell(Text((element.totalKg).toString())),
                DataCell(Text((element.jeapou).toString())),
                DataCell(Text(element.bigo.toString())),
              ],
            )),
          ).toList(),
        ),
      ),
    );

  }

  String _baseUrl = "http://192.168.3.46:8080";
// 산차기록
  Future<List<EyuRecordModel>> getEyuList(int pigNo) async {

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/pigplan/pmd/inputmd/weaningList.json";

    var parameters = json.encode({
      'lang': 'ko',
      'pigNo': pigNo,
      'singleOneSelect': 'Y',
    });
    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?pigNo="+pigNo.toString()+"&singleOneSelect=history";

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

    print("이유기록");
    print(statusCode);

    if (statusCode == 200) {
      var data = jsonDecode(response.body);


      print("이유기록");
      print(data);
      for (int i = 0; i < data["rows"].length; i++) {
        eyuLists.add(EyuRecordModel.fromJson(data["rows"][i]));
      }

      setState(() { });

      return eyuLists;
    } else {
      throw Exception('error');
    }
  }

  @override
  bool get wantKeepAlive => true;

}