import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:pigplan_mobile/model/modon_last_info_model.dart';
import 'package:pigplan_mobile/model/record/eungdon_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:flutter/material.dart';
import 'package:pigplan_mobile/model/record/mating_record_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:pigplan_mobile/model/record/poyou_jadon_died_model.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/record/poyou_jadon_died_detail.dart';

import '../dashboard.dart';
import 'mating_record_detail.dart';

class PoyouJadonDied extends StatefulWidget {
  const PoyouJadonDied({Key? key}) : super(key: key);

  @override
  _PoyouJadonDied createState() => _PoyouJadonDied();
}

class _PoyouJadonDied extends State<PoyouJadonDied> {

  final formKey = GlobalKey<FormState>();

  late final int pigNo;
  late final int sancha;
  late final int seq;
  late final String wkDt = "";
  late int pouDusu = 0;

  TextEditingController controller = TextEditingController();
  TextEditingController bigoController = TextEditingController();

  // 폐사두수 암,수
  TextEditingController femaleController = TextEditingController(text: "0");
  TextEditingController maleController = TextEditingController(text: "0");

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;

  late List<PoyouJadonDiedModel> lists = [];

  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];

  // 폐사원인
  late List<ComboListModel> diedList = [];

  // 분만틀
  late List<ComboListModel> farrowingList = [];

  ComboListModel? diedValue;

  // 폐사장소
  ComboListModel? diedLocationValue;
  // 선택된 분만틀 값
  ComboListModel? selectedFarrowingValue;

  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;

  // 분만틀 값
  String _selectedFarrowingValue = "";

  // 날짜 셋팅
  DateTime today = DateTime.now();

  // 교배일
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // 날짜 셋팅1
  DateTime selectedFromDate = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;
      });
    }
    method();
    FocusScope.of(context).unfocus();
  }

  // 날짜 셋팅2
  DateTime selectedToDate = DateTime.now();
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
      });
    }
    method();
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      method();
    });
  }

  method() async {

    lists = await getList();
    gbList = await Util().getFarmCodeList('','G');
    lcList = await Util().getLocation('080004');
    edList = await Util().getEungdon();

    // 폐사원인
    diedList = await Util().getCodeListFromUrl('/common/comboPeasaReason.json');

    setState(() {
      const SingleChildScrollView();

      // 폐사원인 0번째 선택
      diedValue = diedList[0];
    });
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
          onTap: (){
        FocusScope.of(context).unfocus();
      },
      child:  Scaffold(
      appBar: AppBar(
        title: const Text('피그플랜'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Dashboard()
              )
          ),
        ),
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
            SizedBox(
              width: 350,
              child: ButtonBar(children: [
                Container(
                  child: const Text(
                    '모돈검색',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Signatra',
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                ),
                Visibility(
                  // visible: dropdownSearchVisible,
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      key: const ValueKey('modon'),
                      width: 250,
                      height: 50,
                      child: DropdownSearch(
                        // mode: Mode.MENU,
                        showSearchBox: true,
                        scrollbarProps: ScrollbarProps(
                          isAlwaysShown: true,
                          thickness: 4,
                        ),
                        dropdownSearchDecoration: const InputDecoration(
                          // labelText: '모돈 검색',
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          // border: OutlineInputBorder(),
                        ),
                        // isFilteredOnline: true,
                        onFind: (String? filter) => getModonList(filter),
                        itemAsString: (ModonDropboxModel? m) =>
                            m!.farmPigNo.toString(),
                        onChanged: (ModonDropboxModel? value) => setState(() {
                          _searchValue = value!.farmPigNo.toString();
                          _pigNo = value.pigNo;
                          _seq = value.seq;
                          _wkGubun = value.wkGubun;
                          _targetWkDt = value.lastWkDt;
                          _sancha = value.sancha;

                          getLastModonInfo();
                          // 선택 모돈으로 list 조회
                          getList();

                        }),
                      ),
                    ),
                  ),
                ),

              ]
              ),
            ),

            ExpansionTile(
              // key: formKey,
              initiallyExpanded: true,
              title: const Text(
                '포유자돈폐사기록 등록',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,

                ),
              ),
              children: [
                /*
                SizedBox(
                    width: 350,
                    child: ButtonBar(
                        children: [

                          Container(
                            child: const Text('모돈선택',
                              style: TextStyle(fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 130.0),
                          ),
                          SizedBox(
                            key: const ValueKey('modon'),
                            width: 130,
                            height: 35,
                            child:  DropdownSearch(
                              // mode: Mode.MENU,
                              showSearchBox: true,
                              scrollbarProps: ScrollbarProps(
                                isAlwaysShown: true,
                                thickness: 4,
                              ),
                              // isFilteredOnline: true,
                              onFind: (String? filter) => getModonList(filter),
                              itemAsString: (ModonDropboxModel? m) => m!.farmPigNo.toString(),
                              onChanged: (ModonDropboxModel? value) => setState(() {
                                _searchValue = value!.farmPigNo.toString();
                                _pigNo = value.pigNo;
                                _seq = value.seq;
                                _wkGubun = value.wkGubun;
                                _targetWkDt = value.lastWkDt;
                                _sancha = value.sancha;

                                getLastModonInfo();
                                // Util().getModonList(value);
                              }),
                            ),
                          ),
                        ]
                    )
                ),
                */

                SizedBox(
                    width: 320,
                    child: Row(
                      children: [
                        Container(
                          child: const Text('폐사일',
                            style: TextStyle(fontSize: 16,
                              fontFamily: 'Signatra',
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 60.0),
                        ),
                        ButtonTheme(
                          child: RaisedButton(onPressed: () => _selectDate(context),
                            child: Text("${selectedDate.toLocal()}"
                                .split(" ")[0]
                                .toString()),
                          ),
                          buttonColor: Colors.grey,
                          height: 30,
                        ),
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text('포유두수 : $pouDusu '),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
                SizedBox(
                    width: 350,
                    child: ButtonBar(
                        children: [
                          Container(
                            child: const Text('폐사두수',
                              style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                            ),
                            padding: const EdgeInsets.only(right: 55.0),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: femaleController,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                  labelText: "암",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  )
                              ),
                              onTap: () {
                                if(femaleController.text == '0') {
                                  femaleController.text = '';
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: maleController,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                  labelText: "수",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  )
                              ),
                              onTap: () {
                                if(maleController.text == '0') {
                                  maleController.text = '';
                                }
                              },
                            ),
                          ),
                        ]
                    )
                ),
                SizedBox(
                    width: 350,
                    child: ButtonBar(
                      children: [
                        Container(
                          child: const Text('폐사원인',
                            style: TextStyle(fontSize: 16,
                              fontFamily: 'Signatra',
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 130.0),
                        ),
                        SizedBox(
                          key: const ValueKey('gyobaelc'),
                          width: 130,
                          child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            hint: const Text('선택'),
                            value: diedValue,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (ComboListModel? newValue) {
                              setState(() {
                                diedValue = newValue!;
                              });
                            },
                            items: diedList.map((ComboListModel item) {
                              return DropdownMenuItem<ComboListModel>(
                                child: Text(item.cname),
                                value: item,
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    )
                ),
                SizedBox(
                    width: 350,
                    child: ButtonBar(
                      children: [
                        Container(
                          child: const Text('폐사장소',
                            style: TextStyle(fontSize: 16,
                              fontFamily: 'Signatra',
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 40.0),
                        ),
                        SizedBox(
                          width: 130,
                          child: DropdownButton(
                            isDense: true,
                            isExpanded: true,
                            hint: const Text('선택'),
                            value: diedLocationValue,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (ComboListModel? newValue) async {
                              setState(() {
                                diedLocationValue = newValue!;
                                // 장소 변경시, 분만틀 조회

                                // farrowingList = await Util().getFarmFarrowing(diedLocationValue!.code.toString());
                                // print(farrowingList.length);
                              });

                            },
                            items: lcList.map((ComboListModel item) {
                              return DropdownMenuItem<ComboListModel>(
                                child: Text(item.cname),
                                value: item,
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: DropdownButton<ComboListModel>(
                            isDense: true,
                            isExpanded: true,
                            hint: const Text('선택'),
                            value: selectedFarrowingValue,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (ComboListModel? newValue) {
                              setState(() {
                                selectedFarrowingValue = newValue!;
                              });
                            },
                            items: farrowingList.map((ComboListModel item) {
                              return DropdownMenuItem<ComboListModel>(
                                child: Text(item.cname),
                                value: item,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    key: const ValueKey('bigo'),
                    controller: bigoController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        labelText: "비고",
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
                SizedBox(
                  width: 100,
                  child: RaisedButton(
                    child: const Text('저장', style: TextStyle(fontSize: 20),),
                    onPressed: () async {

                      if(_searchValue.isEmpty) {
                        _showDialog(context,"모돈을 선택해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      if(int.parse(femaleController.text)+int.parse(maleController.text) == 0) {
                        _showDialog(context,"폐사두수를 입력해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      if(int.parse(femaleController.text)+int.parse(maleController.text) > 25) {
                        _showDialog(context," 폐사두수 25두 이상 입력할 수 없습니다.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      if(int.parse(femaleController.text)+int.parse(maleController.text) > pouDusu) {
                        _showDialog(context,"폐사두수가 포유두수보다 많습니다.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      /*
                      if(femaleController.text.isEmpty || femaleController.text == "0") {
                        _showDialog(context,"폐사두수 (암)을 입력해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      if(maleController.text.isEmpty || maleController.text == "0") {
                        _showDialog(context,"폐사두수 (수)를 입력해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }
                      */

                      if(diedValue == null) {
                        _showDialog(context,"폐사원인을 선택해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      setInsert(bigoController.text, diedValue!, selectedFarrowingValue, selectedDate);
                    },
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
                  DataColumn(label: Text('폐사일')),
                  DataColumn(label: Text('폐사두수(암/수)')),
                  DataColumn(label: Text('폐사원인')),
                  DataColumn(label: Text('비고')),
                  DataColumn(label: Text('기록')),
                  DataColumn(label: Text('수정일')),
                  DataColumn(label: Text('수정자')),
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
                                  PoyouJadonDiedDetail(
                                      farmNo: element.farmNo,
                                      pigNo: element.pigNo,
                                      farmPigNo: element.farmPigNo,
                                      sancha: element.sancha.toString(),
                                      igakNo: element.igakNo ?? "",
                                      sagoGubunNm: element.sagoGubunNm ?? "",
                                      seq: element.seq,
                                      wkgubun: element.wkGubun,
                                      locCd: '',
                                      pbigo: element.bigo,
                                      wkPersonCd: '',
                                      pouDusu: pouDusu,
                                      trSeq: element.trSeq,
                                  ),
                            ));
                      }),
                      DataCell(Text(element.igakNo.toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PoyouJadonDiedDetail(
                                            farmNo: element.farmNo,
                                            pigNo: element.pigNo,
                                            farmPigNo: element.farmPigNo,
                                            sancha: element.sancha.toString(),
                                            igakNo: element.igakNo ?? "",
                                            sagoGubunNm: element.sagoGubunNm ?? "",
                                            seq: element.seq,
                                            wkgubun: element.wkGubun,
                                            locCd: '',
                                            pbigo: element.bigo,
                                            wkPersonCd: '',
                                            pouDusu: pouDusu,
                                            trSeq: element.trSeq,
                                        ),
                                    settings: RouteSettings(arguments: element)
                                ));
                          }),
                      DataCell(Text((element.sancha).toString())),
                      DataCell(Text(element.wkDt)),
                      DataCell(Text(element.dusu.toString())),
                      DataCell(
                         FutureBuilder(
                            future: getCodeList(element.subGubunCd, ''),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.toString());
                              } else {
                                return const Text('');
                              }
                            },
                        ),
                      ),
                      DataCell(Text(element.bigo)),
                      DataCell(Text(element.euBunYn)),
                      DataCell(Text(element.logUptDt)),
                      DataCell(Text(element.logUptId)),
                    ],
                  )),
                ).toList(),
              ),
            ),
          ]
        ),
      ),
    );
  }

  // 조회
  Future<List<PoyouJadonDiedModel>> getList() async {
    List<PoyouJadonDiedModel> datas = List<PoyouJadonDiedModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/pmd/inputmd/pjadongDiedList.json";

    var parameters = {
      'searchFarmPigNo': _searchResult,
      'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
      'searchModonItem': "md",
      'searchSort': "TG.LOG_INS_DT DESC,FARM_PIG_NO DESC",
      'searchDtBacisItem': 'updt',
    };
    print('parameters');
    print(parameters);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          'cookie': session_id,
        },
        body: parameters
    );

    // print("교배기록 조회 :: " + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];

      //print(response.body);

      for (int i = 0; i < data.length; i++) {
        datas.add(PoyouJadonDiedModel.fromJson(data[i]));
      }

      // 모돈 선택시 기록이 있는 모돈 list에 추가
      setState(() {
        lists = datas;
      });

      return datas;
    } else {
      throw Exception('error');
    }

  }

  //모돈 리스트 조회
  Future<List<ModonDropboxModel>> getModonList(pigNo) async {

    late List<ModonDropboxModel> modonList = List<ModonDropboxModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    String url = _baseUrl + "/common/combogridModonList.json";

    var parameters = json.encode({
      'searchPigNo': pigNo,
      'searchFarmPigNo': pigNo,
      'dieSearch': 'N',
      'searchType': '4',
      'dateFormat': 'yyyy-MM-dd',
      'orderby': 'NEXT_DT',
    });

    url += "?searchPigNo="+pigNo+"&searchFarmPigNo="+pigNo+"&dieSearch=N&searchType=4&orderby=NEXT_DT"
        "&searchStatus='010002','010003','010004','010005','010006','010007'";

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
      String value = "";

      for (int i = 0; i < data.length; i++) {
        modonList.add(ModonDropboxModel.fromJson(data[i]));
      }
      return modonList;
    } else {
      throw Exception('error');
    }
  }

  setInsert(String bigo, ComboListModel? selectedSago,
    ComboListModel? selectedLocation, DateTime selectedDate) async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = '/pigplan/pmd/inputmd/updateOrStorePjadongDied.json';

    var msg = "";
    bool result = true;

    // 분만틀 없을 경우
    /*
    if(selectedFarrowingValue ==  null) {
      _selectedFarrowingValue = "";
    } else {
      _selectedFarrowingValue = selectedFarrowingValue!.code.toString();
    }
    */

    /*
    if(selectedGbValue == null) {
      _selectedGbValue = "";
    } else {
      _selectedGbValue = selectedGbValue!.code.toString();
    }

    if(selectedCbEd1Value == null) {
      _selectedCbEd1Value = "";
    } else {
      if(selectedCbEd1Value!.code.toString() == '995001') {
        _selectedCbEd1Value = "A";
      } else {
        _selectedCbEd1Value = "N";
      }
    }
    if(selectedCbEd2Value == null) {
      _selectedCbEd2Value = "";
    } else {
      if(selectedCbEd2Value!.code.toString() == '995001') {
        _selectedCbEd2Value = "A";
      } else {
        _selectedCbEd2Value = "N";
      }
    }
    if(selectedCbEd3Value == null) {
      _selectedCbEd3Value = "";
    } else {
      if(selectedCbEd3Value!.code.toString() == '995001') {
        _selectedCbEd3Value = "A";
      } else {
        _selectedCbEd3Value = "N";
      }
    }*/

    final parameter = json.encode({
      'bigo': bigo,
      'dusu': femaleController.text,  // 암
      'dusuSu': maleController.text,  // 수
      'fwNo': "",
      'iuFlag': "I",
      'locCd': diedLocationValue!.code.toString(),  // 폐사장소
      'pigNo': _pigNo,
      'popSearchOrder': "NEXT_DT",
      'popSearchStatusCode': "",
      'sancha': _sancha,
      'subGubunCd': "032006",
      'targetWkDt': "",
      'topIgakNo': "",
      'topPigNo': _pigNo,
      'trSeq': "0",
      'wkDt': selectedDate.toLocal().toString().split(" ")[0],
      'wkGubun': _wkGubun,
    });

    print(parameter);
    print(_baseUrl + url);

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    print("header cookie값 :: " + session_id);

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameter);

    print(response.body);

    result = jsonDecode(response.body)['result'];
    msg = jsonDecode(response.body)['msg'];

    if (response.statusCode == 200 && result == true ) {
      // 저장 성공시, 초기화
      reset();
      method();
      lists = await getList();
      _showDialog(context, "저장 되었습니다.");
      return "sucess";
    } else if(result == false) {
      _showDialog(context, msg);
    } else {
      throw Exception('error');
      return "false";
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
        )
    );
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
      String rs = "";
      for(int i=0; i<data.length; i++) {

        if(data[i]['code'] == code) {
          rs = data[i]['cname'];
          return rs;
        }

      }
      return rs;
    } else {
      throw Exception('error');
    }
  }

  Future<String> getLastModonInfo() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = _baseUrl + "/pigplan/pmd/inputmd/selectMdLastAndJobInfo.json";
    var parameters = json.encode({
      'pigNo': _pigNo.toString(),
      'seq': _seq.toString(),
      'wkDt': wkDt,
      'sancha': _sancha.toString(),
      'target': 'euwr',
      'iuFlag': 'U',
      'statusCd': ''
    });

    // url += "?pigNo="+pigNo.toString();

    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        }, body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      /*
      _silsan = data['buman']['silsan'];
      _wkDt = data['buman']['wkDt'];
      _pou = data['dusu']['euinPouDusu'];
      _lastWk = data['last']['wkDt'];
      _wkDtP = data['last']['wkDtP'];
      _statusCd = data['last']['statusCd'];
      _statusCdP = data['buman']['statusCdP'];

      elapsedDay = int.parse(today.difference(DateTime.parse(_wkDtP)).inDays.toString());
      */

      pouDusu = data['dusu']['pouDusuSum'];

      print(data['dusu']['pouDusuSum']);

      setState(() {});
      return data['wkvw']['statusCd'];
    } else {
      throw Exception('error');
    }
  }

  // 초기화
  reset() {
    femaleController.text = "0";
    maleController.text = "0";

    diedValue = null;

    selectedFarrowingValue = null;
    diedLocationValue = null;

    bigoController.text = "";

    setState(() { });
  }


}
