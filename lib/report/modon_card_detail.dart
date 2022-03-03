import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:pigplan_mobile/model/report/modon_card_detail_info.dart';

class ModonCardDetail extends StatefulWidget {
  final int pigNo;

  const ModonCardDetail({
    Key? key,
    required this.pigNo,
  }) : super(key: key);

  @override
  _ModonCardDetail createState() => _ModonCardDetail(
        pigNo,
  );
}

class _ModonCardDetail extends State<ModonCardDetail> with TickerProviderStateMixin {
  late int pigNo;

  _ModonCardDetail(
    this.pigNo,
  );

  final formKey = GlobalKey<FormState>();

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  String _farmPigNo = "";
  String _igakNo = "";
  String _pumjong = "";
  String _birthDt = "";
  String _inDt = "";
  String _sancha = "";
  String _status = "";
  int _choDt = 0;
  int _san = 0;

  int _psy = 0;
  int _lsy = 0;

  String _chongsan = "";

  String _mila = "";
  String _sasan = "";
  String _silsan = "";
  String _eudusu = "";
  String _avgzaegui = "";
  String _bunmangigan = "";
  String _pouil = "";
  String _imsinil = "";

  int _pigNo = 0;
  late List<ModonCardDetailInfoModel> modonDetailInfo = List<ModonCardDetailInfoModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();

    _pigNo = pigNo;
    // _showDialog(context, _pigNo.toString());

    setState(() {
      method();
    });
  }

  method() async {

    await getModonCardDetail();

    setState(() {
      const SingleChildScrollView();
    });
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
        ),
        body: ListView(
          controller: sccontroller,
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Center(
              child: Text("모돈 정보"
                  ,style: TextStyle(
                    color: Colors.black,

                  )
              ),
            ),
            SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    border: TableBorder.all(
                        color: Colors.blueGrey,
                        style: BorderStyle.solid,
                        width: 2,
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    children: [
                      TableRow(children: [
                        Column(children: const [
                          Text('개체번호', style: TextStyle(fontSize: 16.0, ))
                        ]),
                        Column(children: [
                          Text(_farmPigNo, style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('이각번호', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          Text(_igakNo, style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('품종', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          Text(_pumjong, style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('출생일', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          Text(_birthDt, style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('전입일', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          Text(_inDt, style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('초교배일령', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          Text(_choDt.toString(), style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('현재상태', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          Text(_status, style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('현재산차', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          Text(_sancha, style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('분만예정일', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          Text('값', style: TextStyle(fontSize: 16.0))
                        ]),
                      ]),
                    ],
                  ),
                ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),

            const Center(
              child: Text("모돈 생산성적"
                  ,style: TextStyle(
                    color: Colors.black,

                  )
              ),
            ),

            SizedBox(
              width: 300,
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  border: TableBorder.all(
                      color: Colors.blueGrey,
                      style: BorderStyle.solid,
                      width: 2,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5))),
                  children: [
                    TableRow(children: [
                      Column(children: const [
                        Text('PSY', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_psy.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('LSY', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_lsy.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),

                    TableRow(children: [
                      Column(children: const [
                        Text('총산', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_chongsan.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),

                    TableRow(children: [
                      Column(children: const [
                        Text('미라', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_mila.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),

                    TableRow(children: [
                      Column(children: const [
                        Text('사산', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_sasan.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),

                    TableRow(children: [
                      Column(children: const [
                        Text('실산', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_silsan.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),

                    TableRow(children: [
                      Column(children: const [
                        Text('이유두수', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_eudusu.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),

                    TableRow(children: [
                      Column(children: const [
                        Text('재귀일', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_avgzaegui, style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('임신시간', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_imsinil, style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('포유기간', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_pouil.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),

                    ]),
                  ],
                ),
              ),
            ),

            const Padding(padding: EdgeInsets.only(top: 10)),

            const Center(
              child: Text("모돈 상세정보"
                  ,style: TextStyle(
                    color: Colors.black,

                  ),
              ),
            ),

            SizedBox(
              width: 300,
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  border: TableBorder.all(
                      color: Colors.blueGrey,
                      style: BorderStyle.solid,
                      width: 2,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5))),
                  children: [
                    for(var data in modonDetailInfo)
                    TableRow(children: [
                      Column(children: const [
                        Text('산차', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_psy.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('재귀', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_lsy.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('교배', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_chongsan.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('웅돈1', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_mila.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('웅돈2', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_sasan.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('웅돈3', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_silsan.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('분만일', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_eudusu.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('이유일', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_avgzaegui, style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('임신시간', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_imsinil, style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('포유기간', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_pouil.toString(), style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('총산', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('사산', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('미라', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('', style: TextStyle(fontSize: 16.0))
                      ]),
                    ]),

                  ],
                ),
              ),
            ),


            /*
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    sortAscending: true,
                    headingRowHeight: 30,
                    dataRowHeight: 30,
                    // 컬럼 헤더 색상
                    headingRowColor: MaterialStateColor.resolveWith((states) =>
                    Colors.blueGrey.shade50),
                    columns: const <DataColumn>[
                      DataColumn(label: Text('산차')),
                      DataColumn(label: Text('교배횟수')),
                      DataColumn(label: Text('재귀')),
                      DataColumn(label: Text('분만일')),
                      DataColumn(label: Text('이유일')),
                      DataColumn(label: Text('임신기간')),
                      DataColumn(label: Text('포유기간')),
                      DataColumn(label: Text('총산')),
                      DataColumn(label: Text('사산')),
                      DataColumn(label: Text('미라')),
                    ],
                    rows: modonDetailInfo
                        .map(
                      ((element) =>
                          DataRow(
                            cells: [
                              DataCell(Text(element.san.toString())),
                              DataCell(Text(element.gyobaeCnt.toString())),
                              DataCell(Text(element.zae.toString())),
                              DataCell(Text(element.bunDt.toString())),
                              DataCell(Text(element.euDt.toString())),
                              DataCell(Text(element.imsinil.toString())),
                              DataCell(Text(element.pouil.toString())),
                              DataCell(Text(element.chongsan.toString())),
                              DataCell(Text(element.sasan.toString())),
                              DataCell(Text(element.mila.toString())),
                            ],
                          )
                      ),
                    ).toList(),
                  ),
                ),
              ),
            */

          ],
        ),
      ),
    );
  }

  // 모돈카드 상세정보
  getModonCardDetail() async {

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    const String _baseUrl = "http://192.168.3.46:8080/";
    String url = 'mobile/selectModonCardList.json';

    var parameters = {
      'pigNo': _pigNo,
      'lang': 'ko',
      'schFarmPigNo': _pigNo,
    };
    url = _baseUrl + url + "?pigNo="+_pigNo.toString()+'&lang=ko&dateFormat=yyyy-MM-dd&schFarmPigNo='+_pigNo.toString();

    print(url);

    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        // body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var data1 = jsonDecode(response.body)['rows1'];
      var data2 = jsonDecode(response.body)['rows2'];
      var data3 = jsonDecode(response.body)['rows3'];

      print(data);

      if(data1.length < 1 || data1 == null) {
        _showDialog(context,"조회된 정보가 없습니다.");
      }
print(data);
      print(data1);
      print(data2);
      print(data3);


      _farmPigNo = data1['FARM_PIG_NO'] ?? "";
      _igakNo = data1['IGAK_NO'] ?? "";
      _pumjong = data1['PUMJONG'] ?? "";
      _birthDt = data1['BIRTH_DT'] ?? "";
      _inDt = data1['IN_DT'] ?? "";
      _status = data1['STATUS'] ?? "";
      _sancha = data1['SANCHA'] ?? "";
      _choDt = data1['CHO_DT'] ?? 0;

      _psy = data2['PSY'] ?? 0;
      _lsy = data2['LSY'] ?? 0;
      _chongsan = data2['CHONGSAN'] ?? "0";
      _mila = data2['MILA'] ?? "0";
      _sasan = data2['CHONGSAN' ]?? "0";
      _silsan = data2['SILSAN'] ?? "0";
      _eudusu = data2['EUDUSU'] ?? "0";
      _avgzaegui = data2['AVG_ZAEGUI'] ?? "0";
      _bunmangigan = data2['BUNMANGIGAN'] ?? "0";
      _pouil = data2['POUIL'] ?? "0";
      _imsinil = data2['IMSINIL'] ?? "0";

      if(data3.length > 0) {
        for (int i = 0; i < data3.length; i++) {
          print(data3[i]);
          modonDetailInfo.add(ModonCardDetailInfoModel.fromJson(data3[i]));
        }
      }

      setState(() {});

    } else {
      throw Exception('error');
    }
  }


  void scrollUp() {
    const double start = 0;
    sccontroller.jumpTo(start);
  }

  _showDialog(context, String text) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text(''),
              content: Text(text),
              actions: <Widget>[
                FlatButton(
                  child: const Text('확인'),
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                )
              ],
            ));
  }

  // 초기화
  reset() {}
}
