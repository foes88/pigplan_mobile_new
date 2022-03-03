import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/model/mypage/notice_model.dart';
import 'package:pigplan_mobile/page/my_page.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  _Notice createState() => _Notice();
}

class _Notice extends State<Notice> {

  late List<NoticeModel> lists = [];

  // 날짜 셋팅
  DateTime startDt =
  DateTime(DateTime.now().year-1, DateTime.now().month, DateTime.now().day);
  DateTime endDt = DateTime.now();


  @override
  void initState() {
    super.initState();

    setState(() {
      method();
    });
  }

  method() async {
    lists = await getList();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('피그플랜'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyPage()
                )
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortAscending: true,
            headingRowHeight: 30,
            dataRowHeight: 30,
            columns: const [
              DataColumn(label: Text('제목',)),
              DataColumn(label: Text('등록일',)),
            ],
            rows: lists.map(
              ((element) => DataRow(
                cells: [
                  DataCell(Text(element.title.toString())),
                  DataCell(Text(element.contents.toString())),
                ],
              )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  Future<List<NoticeModel>> getList() async {
    List<NoticeModel> data = List<NoticeModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/farmsys/qa/getNoticeInfoList.json";

    var parameters = {
      'startDt': startDt.toLocal().toString().split(" ")[0],
      'endDt': endDt.toLocal().toString().split(" ")[0],
      'userYn': 'Y',
      'dataFormat': 'yyyy-MM-dd',
      'callSystemTarget': 'mgn',
      'noticeGbn': '',
    };

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          'cookie': session_id,
        },
        body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];

      print(data[1]);
      print(data[2]);

      for (int i = 0; i < data.length; i++) {
        data.add(NoticeModel.fromJson(data[i]));
      }
      return data;
    } else {
      throw Exception('error');
    }

  }

}
