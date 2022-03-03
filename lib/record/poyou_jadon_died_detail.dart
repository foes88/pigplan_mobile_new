import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/common/modon_history.dart';
import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/home/daily_report.dart';
import 'package:pigplan_mobile/home/grade_graph.dart';
import 'package:pigplan_mobile/home/iot_page.dart';
import 'package:pigplan_mobile/home/pig_info.dart';
import 'package:pigplan_mobile/home/quick_menu.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:pigplan_mobile/model/modon_last_info_model.dart';
import 'package:pigplan_mobile/model/record/eungdon_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:pigplan_mobile/model/modon_history/bunman_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/eyu_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/location_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/poyu_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/sancha_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/vaccien_record_model.dart';
import 'package:pigplan_mobile/model/record/poyou_jadon_died_model.dart';
import 'package:pigplan_mobile/model/record/pregnancy_accident_record_model.dart';
import 'package:pigplan_mobile/record/modon_history_page/bunman_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/eyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/location_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/poyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/sancha_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/vaccien_page.dart';
import 'package:pigplan_mobile/record/poyou_jadon_died.dart';

class PoyouJadonDiedDetail extends StatefulWidget {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final String sancha;
  final String igakNo;
  final String sagoGubunNm;
  final int seq;
  final String wkPersonCd;
  final String locCd;
  final String wkgubun;
  final String pbigo;
  final int pouDusu;
  final int trSeq;

  const PoyouJadonDiedDetail({
    Key? key,
    required this.farmNo,
    required this.pigNo,
    required this.farmPigNo,
    required this.sancha,
    required this.igakNo,
    required this.sagoGubunNm,
    required this.seq,
    required this.wkPersonCd,
    required this.locCd,
    required this.wkgubun,
    required this.pbigo,
    required this.pouDusu,
    required this.trSeq,
  }) : super(key: key);

  @override
  _PoyouJadonDiedDetail createState() => _PoyouJadonDiedDetail(
      farmNo, pigNo, farmPigNo, sancha, igakNo, sagoGubunNm, seq, wkPersonCd,
      locCd, wkgubun, pbigo, pouDusu, trSeq,
  );
}

class _PoyouJadonDiedDetail extends State<PoyouJadonDiedDetail> with TickerProviderStateMixin {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final String sancha;
  final String igakNo;
  final String sagoGubunNm;
  final int seq;
  final String wkPersonCd;
  final String locCd;
  final String wkgubun;
  final String pbigo;
  final int pouDusu;
  final int trSeq;

  _PoyouJadonDiedDetail(
      this.farmNo, this.pigNo, this.farmPigNo, this.sancha, this.igakNo, this.sagoGubunNm, this.seq, this.wkPersonCd,
      this.locCd, this.wkgubun, this.pbigo, this.pouDusu, this.trSeq,
    );

  late List<ComboListModel> sagogbn = List<ComboListModel>.empty(growable: true);
  late List<ComboListModel> sagolists = List<ComboListModel>.empty(growable: true);

  late List<PregnancyAccidentRecordModel> lists = [];

  // 모돈 기록리스트 각 항목별
  late List<SanchaRecordModel> sanchaLists = List<SanchaRecordModel>.empty(growable: true);
  late List<BunmanRecordModel> bunmanLists =  List<BunmanRecordModel>.empty(growable: true);
  late List<EyuRecordModel> eyuLists = List<EyuRecordModel>.empty(growable: true);
  late List<PoyuRecordModel> poyuLists = List<PoyuRecordModel>.empty(growable: true);
  late List<VaccienRecordModel> vaccienLists = List<VaccienRecordModel>.empty(growable: true);
  late List<LocationRecordModel> locationRecordLists = List<LocationRecordModel>.empty(growable: true);

  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];

  late List<ComboListModel> edGbnList = [];

  // 폐사원인
  late List<ComboListModel> diedList = [];

  // 분만틀
  late List<ComboListModel> farrowingList = [];

  ComboListModel? selectedLocation;
  ComboListModel? selectedSago;

  late TabController _tabController;
  late TabController _tabController2;

  ComboListModel? diedValue;
  // 폐사장소
  ComboListModel? diedLocationValue;
  // 선택된 분만틀 값
  ComboListModel? selectedFarrowingValue;

  // 폐사두수 암,수
  TextEditingController femaleController = TextEditingController(text: "0");
  TextEditingController maleController = TextEditingController(text: "0");

  TextEditingController bigoController = TextEditingController(text: '');

  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;
  late String wkDt = "";
  late String _san = "";
  late String _statusCd = "";
  late String _statusName = "";

  // 분만틀 값
  String _selectedFarrowingValue = "";

  // 비고
  String bigo = "";

  // 경과일 = 이전작업일 - 사고일
  late int elapsedDay = 0;
  // 날짜 셋팅
  DateTime today = DateTime.now();

  // 날짜 셋팅
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
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

    _wkGubun = wkgubun;
    bigo = pbigo;
    _tabController = TabController(length: 6, vsync: this);
    _tabController2 = TabController(length: 6, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        if(_tabController.index == 1) {
          //Trigger your request
        }
      }
    });

    // 필요 정보 호출(개체정보, 사고구분, 장소)
    setState(() {
      method();
    });
  }

  method() async {

    sagogbn = await getSagoGbn();
    gbList = await Util().getFarmCodeList('','G');
    lcList = await Util().getLocation('080004');
    edList = await Util().getEungdon();

    // 폐사원인
    diedList = await Util().getCodeListFromUrl('/common/comboPeasaReason.json');

    await getOneModonInfo();

    var result = await Util().getLastModonInfo(pigNo, 'diewr', seq, sancha, wkDt);
    print(result);
    _san = result['last']['san'];
    _statusCd = result['last']['statusCd'];

    // 코드값 조회
    _statusName = await Util().getCodeSysValue(_statusCd);

    setState(() {
      // 폐사원인 0번째 선택
      // diedValue = diedList[0];
    });

  }

  @override
  Widget build(BuildContext context) {

    if(bigo.isNotEmpty) {
      bigoController.text = bigo;
    }

    return GestureDetector(
        onTap: (){
        FocusScope.of(context).unfocus();
      },
      child:  MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        home: Scaffold(
          // resizeToAvoidBottomInset : false,
          appBar: AppBar(
            title: const Text('피그플랜'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PoyouJadonDied(),
                  )
              ),
            ),
          ),
          body: ListView(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                    3: FlexColumnWidth(),
                  },
                  border: TableBorder.all(
                      color: Colors.blueGrey,
                      style: BorderStyle.solid,
                      width: 2,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  children: [
                    TableRow(children: [
                      Column(children: const [
                        Text('개체번호', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(farmPigNo, style: const TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('이각번호', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(igakNo, style: const TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('현재상태', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_statusName, style: const TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('현재산차', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_san, style: const TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                  ],
                ),
              ),
              // 저장 부분
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Container(
                child: ExpansionTile(
                // key: formKey,
                title: const Text('포유자돈폐사기록 수정',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                children: [
                  SizedBox(
                      width: 350,
                      child: ButtonBar(
                          children: [
                            Container(
                              child: const Text('선택모돈',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 130.0),
                            ),
                            SizedBox(
                              key: const ValueKey('modon'),
                              width: 130,
                              height: 25,
                              child:
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  farmPigNo,
                                ),
                              ),
                            ),
                          ]
                      )
                  ),
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
                            child: RaisedButton(onPressed: () => _selectFromDate(context),
                              child: Text("${selectedFromDate.toLocal()}"
                                  .split(" ")[0]
                                  .toString()),
                            ),
                            buttonColor: Colors.grey,
                            height: 30,
                          ),
                          Column(
                            children: [
                              Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                            padding: const EdgeInsets.only(right: 130.0),
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
                          /*
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
                          */
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
                      child: const Text('수정', style: TextStyle(fontSize: 20),),
                      onPressed: () async {


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

                        if(diedValue == null) {
                          _showDialog(context,"폐사원인을 선택해 주세요.");
                          FocusScope.of(context).unfocus();
                          return;
                        }

                        setUpdate(bigoController.text, diedValue!, selectedFarrowingValue, selectedDate);
                      },
                    ),
                  ),
                ],
              ),
              ),
              TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.lime,
                  isScrollable: true,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: "산차기록",),
                    Tab(text: "분만기록",),
                    Tab(text: "이유기록",),
                    Tab(text: "포유자돈",),
                    Tab(text: "백신기록",),
                    Tab(text: "장소이동",),
                  ],
                ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SanchaListPage(pigNo: pigNo),
                      BunmanListPage(pigNo: pigNo),
                      EyuListPage(pigNo: pigNo),
                      PoyuListPage(pigNo: pigNo),
                      VaccienListPage(pigNo: pigNo),
                      LocationListPage(pigNo: pigNo),
                    ],
                  ),
                ),

                /* RefreshIndicator(
                    onRefresh: () =>
                        Future.delayed(const Duration(seconds: 1)),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SanchaListPage(pigNo: pigNo),
                        BunmanListPage(pigNo: pigNo),
                        EyuListPage(pigNo: pigNo),
                        PoyuListPage(pigNo: pigNo),
                        VaccienListPage(pigNo: pigNo),
                        LocationListPage(pigNo: pigNo),
                      ],
                    ),
                  ),*/
              ),
            ],
          )
            ],
          ),
        ),
      ),
    );
  }

  String _baseUrl = "http://192.168.3.46:8080/";

// 사고구분 값
  Future<List<ComboListModel>> getSagoGbn() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);

    // url, parameter 셋팅
    var url = _baseUrl + "comboSysCodeCd.json?" + "pcode=05&lang=ko";
    var parameters = {
      'pcode': '05',
      'lang': 'ko',
    };

    final uri = Uri.http('192.168.3.46:8080', '/common/comboSysCodeCd.json', parameters);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      for (int i = 0; i < data.length; i++) {
        sagogbn.add(ComboListModel.fromJson(data[i]));
      }
      setState(() {});
      return sagogbn;
    } else {
      throw Exception('error');
    }
  }

  // 사고리스트
  Future<List<ComboListModel>> getSageList() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    //var url = _baseUrl + "comboCodeFarmDonBang.json";
    var parameters = {
      'pcodeTp': '080001, 080002, 080003',
      'lang': 'ko'
    };

    final uri = Uri.http('192.168.3.46:8080', '/pigplan/pmd/inputmd/selectSagoOne.json', parameters);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'cookie': session_id,
    });

    if (response.statusCode == 200) {
      if(response.body.isNotEmpty) {
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          sagolists.add(ComboListModel.fromJson(data[i]));
        }
      }
      setState(() {});
      return sagolists;
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
      'searchType': '1',
      'dateFormat': 'yyyy-MM-dd',
      'orderby': 'LAST_WK_DT',
    });

    url += "?searchPigNo="+pigNo+"&searchFarmPigNo="+pigNo+"&dieSearch=N&searchType=1&orderby=LAST_WK_DT&";

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

  //
  Future<dynamic> getOneModonInfo() async {

    if(pigNo == 0 || pigNo == null) {
      return;
    }

    List<PoyouJadonDiedModel> list = List<PoyouJadonDiedModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    var url = _baseUrl + "pigplan/pmd/inputmd/selectOneByPjadongDied.json";
    var parameters = json.encode({
      'pigNo': pigNo.toString(),
      'dateFormat': 'yyyy-MM-dd',
      'trSeq': trSeq,
    });

    url += "?pigNo="+pigNo.toString()+"&dateFormat=yyyy-MM-dd&trSeq="+trSeq.toString();

    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        }, body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // 값 셋팅
      femaleController.text = data['dusu'].toString();
      maleController.text = data['dusuSu'].toString();

      if(data['subGubunCd'] != "" || data['subGubunCd'] != null) {
        diedValue = diedList.singleWhere((element) => element.code == data['subGubunCd']);
      }

      if(data['locCd'] != null) {
        diedLocationValue = lcList.singleWhere((element) => element.code == data['locCd']);
      }

      bigoController.text = data['bigo'];

      setState(() {});

      return data;
    } else {
      throw Exception('error');
    }
  }

  // 데이터 수정
  setUpdate(String bigo, ComboListModel? selectedSago,
      ComboListModel? selectedLocation, DateTime selectedDate) async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = '/pigplan/pmd/inputmd/updateOrStoreMating.json';

    var msg = "";
    bool result = true;

    // 분만틀 없을 경우
    if(selectedFarrowingValue ==  null) {
      _selectedFarrowingValue = "";
    } else {
      _selectedFarrowingValue = selectedFarrowingValue!.code.toString();
    }

    /*if(selectedGbValue == null) {
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
        body: parameter
    );

    print(response.body);

    if (response.statusCode == 200 && result == true ) {
      _showDialog(context, "수정 되었습니다.");
      return "sucess";
    } else if(result == false) {
      _showDialog(context, msg);
    } else {
      throw Exception('error');
      return "false";
    }

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
