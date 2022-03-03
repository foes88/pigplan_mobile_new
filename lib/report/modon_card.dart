import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/model/report/modon_card_model.dart';

import 'modon_card_detail.dart';

class ModonCard extends StatefulWidget {
  const ModonCard({Key? key}) : super(key: key);

  @override
  _ModonCard createState() => _ModonCard();
}

class _ModonCard extends State<ModonCard> {
  final formKey = GlobalKey<FormState>();

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late String _searchResult = "";

  late List<ModonCardModel> lists = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      method();
    });
  }

  method() async {

    lists = await getList();

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
          title: const Text('PigPlan'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: scrollUp,
          isExtended: true,
          tooltip: "top",
          backgroundColor: Colors.lightBlueAccent,
          mini: true,
          child: const Icon(Icons.arrow_upward),
        ),
        body: ListView(
          controller: sccontroller,
          children: <Widget>[
            ExpansionTile(
              backgroundColor: Colors.white,
              title: const Text(
                '검색',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              children: [
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.center,
                    onChanged: (value) async {
                      setState(() {
                        _searchResult = value;
                      });
                      method();
                    },
                    decoration: const InputDecoration(
                        hintText: '검색',
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        )
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortAscending: true,
                headingRowHeight: 30,
                dataRowHeight: 30,
                columns: const <DataColumn>[
                  DataColumn(label: Text('모돈번호',)),
                  DataColumn(label: Text('이각번호')),
                  DataColumn(label: Text('산차')),
                  // DataColumn(label: Text('품종')),
                  DataColumn(label: Text('초교배 일령')),
                  // DataColumn(label: Text('현재상태')),
                  DataColumn(label: Text('최종작업일')),
                ],
                rows: lists
                    .map(
                  ((element) => DataRow(
                    cells: [
                      DataCell(Text(element.farmPigNo), onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ModonCardDetail(
                                    pigNo: element.pigNo,

                                  ),
                              /*settings: RouteSettings(
                                              arguments: element)*/
                            ));
                      }),
                      DataCell(Text(element.igakNo.toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ModonCardDetail(
                                          pigNo: element.pigNo,
                                        ),
                                    settings: RouteSettings(
                                        arguments: element)));
                          }),
                      DataCell(Text((element.sancha).toString())),
                      /*
                      DataCell(
                          FutureBuilder(future: getCodeSysList(element.pumjongCd.toString(), '02'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data.toString());
                            } else {
                              return const Text('');
                            }
                          },
                        )
                      ),
                      */
                      DataCell(Text(element.chogyobaeDt.toString())),
                      // DataCell(Text(element.statusCd.toString())),
                      DataCell(Text(element.lastWkDt)),

                    ],
                  )),
                ).toList(),
              ),
            ),



          ],
        ),
      ),
    );
  }

  // 리스트 조회
  Future<List<ModonCardModel>> getList() async {

    List<ModonCardModel> list = List<ModonCardModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/pmd/jobrpt_dd/modonList.json";

    var parameters = {
      'schFarmPigNo': _searchResult,
      'schSsancha': 0,
      'schEsancha': 10,
      'cbSort': "FARM_PIG_NO DESC,SANCHA ASC",
      'lang': 'ko',
      'dateFormat': 'yyyy-MM-dd',
    };

    url += '?schFarmPigNo='+_searchResult + '&schSsancha=0&schEsancha=10&cbSort=CHOGYOBAE_DT DESC NULLS LAST,SANCHA ASC&lang=ko&dateFormat=yyyy-MM-dd';

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    final response = await http.get(Uri.parse(_baseUrl + url),
        headers: {
          'cookie': session_id,
        },
        // body: parameters
    );

    // print("모돈 카드 조회 :: " + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];
      print(response.body);
      for (int i = 0; i < data.length; i++) {
        list.add(ModonCardModel.fromJson(data[i]));
      }
      return list;
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
