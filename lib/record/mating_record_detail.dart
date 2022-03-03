import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pigplan_mobile/common/modon_history.dart';
import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/home/daily_report.dart';
import 'package:pigplan_mobile/home/grade_graph.dart';
import 'package:pigplan_mobile/home/iot_page.dart';
import 'package:pigplan_mobile/home/pig_info.dart';
import 'package:pigplan_mobile/home/quick_menu.dart';

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
import 'package:pigplan_mobile/model/record/pregnancy_accident_record_model.dart';
import 'package:pigplan_mobile/record/matingrecord.dart';
import 'package:pigplan_mobile/record/modon_history_page/bunman_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/eyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/location_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/poyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/sancha_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/vaccien_page.dart';

class MatingRecordDetail extends StatefulWidget {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final String sancha;
  final String igakNo;
  final String sagoGubunNm;
  final int seq;
  final String wkPersonCd;
  final int locCd;
  final String wkgubun;
  final String wkDt;
  final String method1;
  final String method2;
  final String method3;

  // 웅돈
  final EungdonModel? PselectedEd1Value;
  final EungdonModel? PselectedEd2Value;
  final EungdonModel? PselectedEd3Value;

  // 교배방법
  final ComboListModel? PselectedCbEd1Value;
  final ComboListModel? PselectedCbEd2Value;
  final ComboListModel? PselectedCbEd3Value;

  final String ufarmPigNo1;
  final String ufarmPigNo2;
  final String ufarmPigNo3;

  final String ungdonPigNo1;
  final String ungdonPigNo2;
  final String ungdonPigNo3;

  final String pbigo;

  const MatingRecordDetail({
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
    required this.wkDt,
    required this.method1,
    required this.method2,
    required this.method3,
    required this.ufarmPigNo1,
    required this.ufarmPigNo2,
    required this.ufarmPigNo3,
    required this.ungdonPigNo1,
    required this.ungdonPigNo2,
    required this.ungdonPigNo3,
    required this.PselectedEd1Value,
    required this.PselectedEd2Value,
    required this.PselectedEd3Value,
    required this.PselectedCbEd1Value,
    required this.PselectedCbEd2Value,
    required this.PselectedCbEd3Value,
    required this.pbigo,
  }) : super(key: key);

  @override
  _MatingRecordDetail createState() => _MatingRecordDetail(
      farmNo, pigNo, farmPigNo, sancha, igakNo, sagoGubunNm, seq, wkPersonCd,
      locCd, wkgubun, wkDt, method1, method2, method3, ufarmPigNo1, ufarmPigNo2, ufarmPigNo3,
      ungdonPigNo1, ungdonPigNo2, ungdonPigNo3, PselectedEd1Value, PselectedEd2Value, PselectedEd3Value,
      PselectedCbEd1Value, PselectedCbEd2Value, PselectedCbEd3Value, pbigo,
  );
}

class _MatingRecordDetail extends State<MatingRecordDetail> with TickerProviderStateMixin {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final String sancha;
  final String igakNo;
  final String sagoGubunNm;
  final int seq;
  final String wkPersonCd;
  final int locCd;
  final String wkgubun;
  final String wkDt;
  final String method1;
  final String method2;
  final String method3;

  late final String ufarmPigNo1;
  late final String ufarmPigNo2;
  late final String ufarmPigNo3;
  late final String ungdonPigNo1;
  late final String ungdonPigNo2;
  late final String ungdonPigNo3;
  // 웅돈
  late final EungdonModel? PselectedEd1Value;
  late final EungdonModel? PselectedEd2Value;
  late final EungdonModel? PselectedEd3Value;

  // 교배방법
  late final ComboListModel? PselectedCbEd1Value;
  late final ComboListModel? PselectedCbEd2Value;
  late final ComboListModel? PselectedCbEd3Value;

  // 웅돈 1,2,3회 입력 폼
  TextEditingController ed1Controller = TextEditingController();
  TextEditingController ed2Controller = TextEditingController();
  TextEditingController ed3Controller = TextEditingController();

  late final String pbigo;

  _MatingRecordDetail(
      this.farmNo, this.pigNo, this.farmPigNo, this.sancha, this.igakNo, this.sagoGubunNm, this.seq, this.wkPersonCd,
      this.locCd, this.wkgubun, this.wkDt, this.method1, this.method2, this.method3, this.ufarmPigNo1, this.ufarmPigNo2, this.ufarmPigNo3,
      this.ungdonPigNo1, this.ungdonPigNo2, this.ungdonPigNo3, this.PselectedEd1Value, this.PselectedEd2Value, this.PselectedEd3Value,
      this.PselectedCbEd1Value, this.PselectedCbEd2Value, this.PselectedCbEd3Value, this.pbigo,
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

  //String sagoValue = '';
  ComboListModel? selectedLocation;
  ComboListModel? selectedSago;

  late TabController _tabController;
  late TabController _tabController2;

  ComboListModel? selectedMdValue;
  ComboListModel? selectedGbValue;
  ComboListModel? selectedGblValue;

  EungdonModel? selectedEd1Value;
  EungdonModel? selectedEd2Value;
  EungdonModel? selectedEd3Value;

  ComboListModel? selectedCbEd1Value;
  ComboListModel? selectedCbEd2Value;
  ComboListModel? selectedCbEd3Value;

  TextEditingController bigoController = TextEditingController(text: '');

  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;
  late String _san = "";
  late String _statusCd = "";
  late String _statusName = "";

  String _selectedGbValue = "";
  String _selectedCbEd1Value = "";
  String _selectedCbEd2Value = "";
  String _selectedCbEd3Value = "";

  String _ufarmPigNo1="";
  String _ufarmPigNo2="";
  String _ufarmPigNo3="";

  String _ungdonPigNo1="";
  String _ungdonPigNo2="";
  String _ungdonPigNo3="";

  // 비고
  String bigo = "";

  // 경과일 = 이전작업일 - 사고일
  late int elapsedDay = 0;
  // 날짜 셋팅
  DateTime today = DateTime.now();

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

  // 교배일
  DateTime selectGbDate = DateTime.now();
  Future<void> _selectGbDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectGbDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectGbDate) {
      setState(() {
        selectGbDate = picked;
      });
    }
    method();
    FocusScope.of(context).unfocus();
  }


  @override
  void initState() {
    super.initState();

    /*
    print(method1);
    print(method2);
    print(method3);

    print(ufarmPigNo1);
    print(ufarmPigNo2);
    print(ufarmPigNo3);

    print(ungdonPigNo1);
    print(ungdonPigNo2);
    print(ungdonPigNo3);
    */

    _wkGubun = wkgubun;

    //selectedCbEd1Value.code = ufarmPigNo1;
    //selectedCbEd2Value = PselectedCbEd2Value;
    //selectedCbEd3Value = PselectedCbEd3Value;

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
    // 모돈 정보 조회
    await getPigInfo();

    // 모돈 최종작업 및 이전 작업정보 조회
    var result = await Util().getLastModonInfo(pigNo, 'mdwr', seq, sancha, wkDt);
    _statusCd = result['last']['statusCd'];

    // 코드값 조회
    _statusName = await getCodeJohapValue(_statusCd);

    // dropbox
    sagogbn = await getSagoGbn();
    gbList = await Util().getFarmCodeList('','G');
    lcList = await Util().getLocation('080001, 080002, 080003');
    edList = await Util().getEungdon();
    // 교배방법
    edGbnList = await getEdGbnList();

    // 넘어온 값 셋팅
    if(wkPersonCd != "") {
      selectedGbValue = gbList.singleWhere((element) => element.code == wkPersonCd);
    }

    if(locCd != 0) {
      selectedLocation = lcList.singleWhere((element) => element.code == locCd.toString());
    }

    // 교배일
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    if(wkDt.isNotEmpty) {
      selectGbDate = dateFormat.parse(wkDt);
    }

    //웅돈1회

    print('dslsdls');
    print(ufarmPigNo1);
    print(ungdonPigNo1);

    ed1Controller.text = ufarmPigNo1;
    if(ungdonPigNo1 != "") {
      selectedEd1Value = edList.singleWhere((element) => element.pigNo.toString() == ungdonPigNo1);
    }
    if(method1.isNotEmpty) {
      selectedCbEd1Value = edGbnList.singleWhere((element) => element.cvalue == method1);
    }

    //웅돈2회
    ed2Controller.text = ufarmPigNo2;
    if(ungdonPigNo1 != "") {
      selectedEd2Value = edList.singleWhere((element) => element.pigNo.toString() == ungdonPigNo2);
    }
    if(method2.isNotEmpty) {
      selectedCbEd2Value = edGbnList.singleWhere((element) => element.cvalue == method2);
    }

    //웅돈3회
    ed3Controller.text = ufarmPigNo3;
    if(ungdonPigNo1 != "") {
      selectedEd3Value = edList.singleWhere((element) => element.pigNo.toString() == ungdonPigNo3);
    }
    if(method3.isNotEmpty) {
      selectedCbEd3Value = edGbnList.singleWhere((element) => element.cvalue == method3);
    }

    if(bigo.isNotEmpty) {
      bigoController.text = bigo;
    }




    setState(() {
      const SingleChildScrollView();

    });
  }

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      allowFontScaling: false,
      builder: () => GestureDetector(
        onTap: (){
        FocusScope.of(context).unfocus();
      },
      child:  MaterialApp(
        localizationsDelegates: const [
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
                    builder: (context) => MatingRecord(pPigNo: 0,),
                  )
              ),
            ),
          ),
          body: ListView(
              children: [
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
              // padding
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Container(
                child: ExpansionTile(
                // key: formKey,
                title: const Text('교배기록 수정',
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

                              )


                              /*
                              DropdownSearch(
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

                                  // 모돈 선택시, 경과일 계산
                                  elapsedDay = int.parse(today.difference(DateTime.parse(_targetWkDt)).inDays.toString());

                                  // Util().getModonList(value);
                                }),
                              ),
*/



                            ),
                          ]
                      )
                  ),
                  SizedBox(
                      width: 350,
                      child: ButtonBar(
                          children: [
                            Container(
                              child: const Text('교배자',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 110.0),
                            ),
                            SizedBox(
                              key: const ValueKey('gyobae'),
                              width: 130,
                              child: DropdownButton<ComboListModel>(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('선택'),
                                value: selectedGbValue,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) {
                                  setState(() {
                                    selectedGbValue = newValue!;
                                  });
                                },
                                items: gbList.map((ComboListModel item) {
                                  return DropdownMenuItem<ComboListModel>(
                                    child: Text(item.cname),
                                    value: item,
                                  );
                                }).toList(),
                              ),
                            )
                          ]
                      )
                  ),
                  SizedBox(
                      width: 350,
                      child: ButtonBar(
                        children: [
                          Container(
                            child: const Text('교배장소',
                              style: TextStyle(fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 97.0),
                          ),
                          SizedBox(
                            key: const ValueKey('gyobaelc'),
                            width: 130,
                            child: DropdownButton(
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('선택'),
                              value: selectedLocation,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (ComboListModel? newValue) {
                                setState(() {
                                  selectedLocation = newValue!;
                                });
                              },
                              items: lcList.map((ComboListModel item) {
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
                      width: 320,
                      child: Row(
                        children: [
                          Container(
                            child: const Text('교배일',
                              style: TextStyle(fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 35.0),
                          ),
                          ButtonTheme(
                            child: RaisedButton(onPressed: () => _selectGbDate(context),
                              child: Text("${selectGbDate.toLocal()}"
                                  .split(" ")[0]
                                  .toString()),
                            ),
                            buttonColor: Colors.grey,
                            height: 30,
                          ),
                          Column(
                            children: [
                              Padding(padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                child: Text('경과일 : $elapsedDay '),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                  SizedBox(
                      width: 350,
                      child: ButtonBar(
                        buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        children: [
                          Container(
                            child: const Text('웅돈1회',
                              style: TextStyle(fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 15.0),
                          ),
                          Container(
                            child :SizedBox(
                              width: 100,
                              height: 40,
                              child: TextFormField(
                                controller:  ed1Controller,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    labelText: "",
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
                            padding: const EdgeInsets.only(right: 3.0),
                          ),
                          SizedBox(
                            width: 90,
                            child: DropdownButton (
                              isDense: true,
                              isExpanded: true,
                              hint: const Text ('선택'),
                              value: selectedEd1Value,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (EungdonModel? newValue) {
                                setState(() {
                                  selectedEd1Value = newValue!;
                                  _ufarmPigNo1 = selectedEd1Value!.farmPigNo.toString();
                                  _ungdonPigNo1 = selectedEd1Value!.pigNo.toString();
                                  // textbox 초기화
                                  ed1Controller.text = "";

                                  print(selectedEd1Value!.farmPigNo);

                                });
                              },
                              items: edList.map((EungdonModel item) {
                                return DropdownMenuItem<EungdonModel>(
                                  child: Text(item.farmPigNo),
                                  value: item,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: DropdownButton<ComboListModel>(
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('선택'),
                              value: selectedCbEd1Value,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (ComboListModel? newValue) {
                                setState(() {
                                  selectedCbEd1Value = newValue!;
                                  _ufarmPigNo2 = selectedEd2Value!.farmPigNo.toString();
                                  _ungdonPigNo2 = selectedEd2Value!.pigNo.toString();
                                  // textbox 초기화
                                  ed2Controller.text = "";
                                });
                              },
                              items: edGbnList.map((ComboListModel item) {
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
                      width: 350,
                      child: ButtonBar(
                        buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        children: [
                          Container(
                            child: const Text('웅돈2회',
                              style: TextStyle(fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 15.0),
                          ),
                          Container(
                            child :SizedBox(
                              width: 100,
                              height: 40,
                              child: TextFormField(
                                controller:  ed2Controller,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    labelText: "",
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
                            padding: const EdgeInsets.only(right: 5.0),
                          ),
                          SizedBox(
                            width: 90,
                            child: DropdownButton(
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('선택'),
                              value: selectedEd2Value,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (EungdonModel? newValue) {
                                setState(() {
                                  selectedEd2Value = newValue!;
                                  _ufarmPigNo3 = selectedEd3Value!.farmPigNo.toString();
                                  _ungdonPigNo3 = selectedEd3Value!.pigNo.toString();
                                  // textbox 초기화
                                  ed3Controller.text = "";
                                });
                              },
                              items: edList.map((EungdonModel item) {
                                return DropdownMenuItem<EungdonModel>(
                                  child: Text(item.farmPigNo),
                                  value: item,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: DropdownButton<ComboListModel>(
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('선택'),
                              value: selectedCbEd2Value,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (ComboListModel? newValue) {
                                setState(() {
                                  selectedCbEd2Value = newValue!;
                                });
                              },
                              items: edGbnList.map((ComboListModel item) {
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
                      width: 350,
                      child: ButtonBar(
                        buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        children: [
                          Container(
                            child: const Text('웅돈3회',
                              style: TextStyle(fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 15.0),
                          ),
                          Container(
                            child :SizedBox(
                              width: 100,
                              height: 40,
                              child: TextFormField(
                                controller:  ed3Controller,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    labelText: "",
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
                            padding: const EdgeInsets.only(right: 5.0),
                          ),
                          SizedBox(
                            width: 90,
                            child: DropdownButton(
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('선택'),
                              value: selectedEd3Value,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (EungdonModel? newValue) {
                                setState(() {
                                  selectedEd3Value = newValue!;
                                });
                              },
                              items: edList.map((EungdonModel item) {
                                return DropdownMenuItem<EungdonModel>(
                                  child: Text(item.farmPigNo),
                                  value: item,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: DropdownButton<ComboListModel>(
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('선택'),
                              value: selectedCbEd3Value,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (ComboListModel? newValue) {
                                setState(() {
                                  selectedCbEd3Value = newValue!;
                                });
                              },
                              items: edGbnList.map((ComboListModel item) {
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
                      child: const Text('수정', style: TextStyle(fontSize: 20),),
                      onPressed: () async {


                      /*
                      if(selectedGbValue == null) {
                        _showDialog(context,"교배자를 선택해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      if(selectedGblValue == null) {
                        _showDialog(context,"교배장소를 선택해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }
                      */

                        //옹돈 순서대로 입력 안됬을경우 error
                        //1이 있어야 2, 2가있어야 3 선택 가능

                        print(selectedEd1Value);
                        print(selectedEd2Value);
                        print(selectedEd3Value);

                        // 웅돈1은 있어야 저장
                        if(selectedEd1Value == null && ed1Controller.text == "") {
                          _showDialog(context,"웅돈1회를 입력해주세요.");
                          FocusScope.of(context).unfocus();
                          return;
                        }

                        if(selectedEd1Value == null && selectedEd2Value != null && selectedEd3Value != null) {
                          _showDialog(context,"교배웅돈 및 방법은 순차적으로 입력 되어야 합니다.");
                          FocusScope.of(context).unfocus();
                          return;
                        }
                        if(selectedEd1Value == null && selectedEd2Value == null && selectedEd3Value != null) {
                          _showDialog(context,"교배웅돈 및 방법은 순차적으로 입력 되어야 합니다.");
                          FocusScope.of(context).unfocus();
                          return;
                        }

                        if(selectedCbEd1Value == null && selectedCbEd2Value != null && selectedCbEd3Value != null) {
                          _showDialog(context,"교배웅돈 및 방법은 순차적으로 입력 되어야 합니다.");
                          FocusScope.of(context).unfocus();
                          return;
                        }
                        if(selectedCbEd1Value == null && selectedCbEd2Value == null && selectedCbEd3Value != null) {
                          _showDialog(context,"교배웅돈 및 방법은 순차적으로 입력 되어야 합니다.");
                          FocusScope.of(context).unfocus();
                          return;
                        }
/*
                      if(selectedCbEd2Value == null) {
                        selectedCbEd2Value.code = "";
                      }
                      if(selectedCbEd3Value == null) {
                        selectedCbEd3Value.code = "";
                      }*/

                        /*
                      if(bigoController.text.isEmpty) {
                        _showDialog(context,"비고를 입력해 주세요.");
                        return;
                      }
                      */

                        setUpdate(bigoController.text, selectedGbValue!, selectedGblValue, selectGbDate);
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
            ),
          ],
        ),
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

  // 교배 방법
  Future<List<ComboListModel>> getEdGbnList() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);

    // url, parameter 셋팅
    var url = _baseUrl + "comboSysCodeCd.json?" + "pcode=995";
    var parameters = {
      'pcode': '995',
      'lang': 'ko',
    };

    final uri = Uri.http('192.168.3.46:8080', '/common/comboSysCodeCd.json', parameters);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      for (int i = 0; i < data.length; i++) {
        list.add(ComboListModel.fromJson(data[i]));
      }
      setState(() {});
      return list;
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

  //모돈 정보 조회
  getPigInfo() async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    String url = _baseUrl + "pigplan/pmd/inputmd/selectGyobaeOne.json";

    var parameters = json.encode({
      'pigNo': pigNo,
      'dateFormat': 'yyyy-MM-dd',
      'lang': 'ko',
      'wkDt': wkDt,
    });

    url+= "?pigNo="+pigNo.toString()+"&dateFormat=yyyy-MM-dd&lang=ko&wkDt="+wkDt;

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

      _san = data['san'].toString();

    } else {
      throw Exception('error');
    }
  }

  /*
  Future<String> getLastModonInfo() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = _baseUrl + "/pigplan/pmd/inputmd/selectMdLastAndJobInfo.json";
    var parameters = json.encode({
      'pigNo': pigNo.toString(),
      'seq': _seq.toString(),
      'wkDt': wkDt,
      'sancha': _sancha.toString(),
      'target': 'mdwr',
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

      print(data);

      _statusCd = data['last']['statusCd'];

      print(_statusCd);

      return "";
    } else {
      throw Exception('error');
    }
  }
   */

  // johap 코드 조회
  getCodeJohapValue(String code) async {

    if(code.isEmpty) {
      return "";
    }

    String url = "http://192.168.3.46:8080/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?type=sys&code="+code;

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

  // 데이터 수정
  setUpdate(String bigo, ComboListModel? selectedSago,
      ComboListModel? selectedLocation, DateTime selectGbDate) async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = '/pigplan/pmd/inputmd/updateOrStoreMating.json';

    var msg = "";
    bool result = true;

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
    }

    // 웅돈 1,2,3회 값 - 입력값이 있으면 코드값은 안넘어간다
    if(ed1Controller.text != '') {
      ungdonPigNo1 = '';
      ufarmPigNo1 = ed1Controller.text;
    }
    if(ed2Controller.text != '') {
      ungdonPigNo2 = '';
      ufarmPigNo2 = ed2Controller.text;
    }
    if(ed3Controller.text != '') {
      ungdonPigNo3 = '';
      ufarmPigNo3 = ed3Controller.text;
    }

    final parameter = json.encode({
      'pigNo': pigNo, // 모돈번호
      'topPigNo': pigNo,
      // 'wkPersonCd': selectedSago!.code.toString(), //사고코드
      'wkPersonCd': _selectedGbValue,
      'locCd': selectedLocation!.code.toString(), // 교배장소
      'seq': seq,
      'sancha': sancha,
      'wkGubun': wkgubun,
      'method1': _selectedCbEd1Value,
      'method2': _selectedCbEd2Value, // selectedCbEd2Value.code.toString(),
      'method3': _selectedCbEd3Value, // selectedCbEd3Value.code.toString(),
      'ungdonPigNo1': _ungdonPigNo1,
      'ungdonPigNo2': _ungdonPigNo2,
      'ungdonPigNo3': _ungdonPigNo3,
      'ufarmPigNo1': _ufarmPigNo1,
      'ufarmPigNo2': _ufarmPigNo2,
      'ufarmPigNo3': _ufarmPigNo3,
      'bigo': 'test',
      'wkDt': selectGbDate.toLocal().toString().split(" ")[0], // 2021-11-03
      'iuFlag': 'U', // I, U
      'lang': 'ko',
      'dateFormat': 'yyyy-MM-dd',
      'popSearchOrder': 'LAST_WK_DT'
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

    selectedGbValue = null;
    selectedGblValue = null;

    ed1Controller.text = "";

    selectedEd1Value = null;
    _ufarmPigNo1 = "";
    _ungdonPigNo1 = "";

    selectedEd2Value = null;
    _ufarmPigNo2 = "";
    _ungdonPigNo2 = "";

    selectedEd3Value = null;
    _ufarmPigNo3 = "";
    _ungdonPigNo3 = "";

    bigoController.text = "";

    setState(() { });

  }

}
