import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_session/flutter_session.dart';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/common/modon_history.dart';
import 'package:flutter/material.dart';
import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/model/modon_history/vaccien_record_model.dart';

class VaccienListPage extends StatefulWidget {

  final int pigNo;

  const VaccienListPage({
    Key? key,
    required this.pigNo,
  }) : super(key: key);

  @override
  _VaccienListPage createState() => _VaccienListPage(pigNo);
}

class _VaccienListPage extends State<VaccienListPage> with AutomaticKeepAliveClientMixin<VaccienListPage>{

  late List<VaccienRecordModel> vaccienLists = List<VaccienRecordModel>.empty(growable: true);
  final int pigNo;

  _VaccienListPage(this.pigNo);

  @override
  void initState() {
    super.initState();
    setState(() {
      getVaccienRecord(pigNo);
    });

    //개발, 운영 설정파일
    dotenv.load(fileName: "assets/.env");
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
            DataColumn(label: Text('구분')),
            DataColumn(label: Text('치료일자')),
            DataColumn(label: Text('치료방법')),
            DataColumn(label: Text('백신명')),
            DataColumn(label: Text('사용량')),
          ],
          rows: vaccienLists
              .map(
            ((element) => DataRow(
              cells: [
                DataCell(Text(element.san)),
                DataCell(Text(element.wkName)),
                DataCell(Text(element.healDt)),
                DataCell(
                    FutureBuilder(
                      future: getCodeList('300001', '30'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString());
                        } else {
                          return const Text('');
                        }
                      },
                    )
                ),
                DataCell(Text(element.articleNm)),
                DataCell(Text(element.useVolume.toString())),
              ],
            )),
          ).toList(),
        ),
      ),
    );

  }

  final String _baseUrl = dotenv.env['PIGPLAN_URL'] ?? 'Url not found';
  //String _baseUrl = "http://192.168.3.46:8080";
// 산차기록
  Future<List<VaccienRecordModel>> getVaccienRecord(int pigNo) async {
    print("url :: " + _baseUrl);
    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/sharing/common/mdVaccinHistoryList.json";
    var parameters = json.encode({
      'lang': 'ko',
      'singleOneSelect':'Y',
      'sowBoar':'S',
      'searchSort':'SANCHA DESC,GYOBAE_CNT DESC,HEAL_DT DESC',
      'pigNo': pigNo
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
        vaccienLists.add(VaccienRecordModel.fromJson(data[i]));
      }

      setState(() { });

      return vaccienLists;
    } else {
      throw Exception('error');
    }
  }

  @override
  bool get wantKeepAlive => true;

}

getCodeList(String code, String pcode) async {

  if(code.isEmpty) {
    return "";
  }

  // RequestBody로 받아줘서 body로 넘기는게 가능
  String url = "http://192.168.3.46:8080/common/getCodes.json";

  var parameters = json.encode({
    'lang': 'ko',
  });

  // ModelAttribute로 받아줘서 url뒤로 넘김
  url += "?type=johap&code="+code+"&pcode="+pcode;

  print(url);

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
    String test = "";
    for(int i=0; i<data.length; i++) {

      if(data[i]['code'] == code) {
        test = data[i]['cname'];
        return test;
      }

    }
    return test;
  } else {
    throw Exception('error');
  }
}
