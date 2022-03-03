import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil_init.dart';

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
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:pigplan_mobile/model/modon_history/bunman_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/eyu_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/location_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/poyu_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/sancha_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/vaccien_record_model.dart';
import 'package:pigplan_mobile/model/modon_last_info_model.dart';
import 'package:pigplan_mobile/model/record/pregnancy_accident_record_model.dart';
import 'package:pigplan_mobile/record/modon_history_page/bunman_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/eyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/location_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/poyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/sancha_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/vaccien_page.dart';
import 'package:pigplan_mobile/record/pregnancy_accident_record.dart';

class PregnancyAccidentRecordRegit extends StatefulWidget {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final String sancha;
  final String igakNo;
  final String sagoGubunNm;
  final int seq;
  final String wkGubun;
  final String wkDt;
  final String wkDtP;
  final String sagoGubunCd;
  final String dieOutYn;
  final String pbigo;
  final String passDt;

  const PregnancyAccidentRecordRegit({
    Key? key,
    required this.farmNo,
    required this.pigNo,
    required this.farmPigNo,
    required this.sancha,
    required this.igakNo,
    required this.sagoGubunNm,
    required this.seq,
    required this.wkGubun,
    required this.wkDt,
    required this.wkDtP,
    required this.sagoGubunCd,
    required this.dieOutYn,
    required this.pbigo,
    required this.passDt,
  }) : super(key: key);

  @override
  _PregnancyAccidentRecordRegit createState() => _PregnancyAccidentRecordRegit(
      farmNo, pigNo, farmPigNo, sancha, igakNo, sagoGubunNm, seq, wkGubun,
      wkDt, wkDtP, sagoGubunCd, dieOutYn, wkGubun, pbigo, passDt,
  );
}

class _PregnancyAccidentRecordRegit extends State<PregnancyAccidentRecordRegit> with TickerProviderStateMixin {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final String sancha;
  final String igakNo;
  final String sagoGubunNm;
  final int seq;
  final String wkGubun;
  final String wkDt;
  final String wkDtP;
  final String sagoGubunCd;
  final String dieOutYn;
  final String wkgubun;
  final String pbigo;
  final String passDt;

  _PregnancyAccidentRecordRegit(this.farmNo, this.pigNo, this.farmPigNo,
      this.sancha, this.igakNo, this.sagoGubunNm, this.seq, this.wkGubun, this.wkDt, this.wkDtP,
      this.sagoGubunCd, this.dieOutYn, this.wkgubun, this.pbigo, this.passDt,
    );

  late List<ComboListModel> sagolists = List<ComboListModel>.empty(growable: true);
  late List<ComboListModel> locationlists = List<ComboListModel>.empty(growable: true);

  late List<PregnancyAccidentRecordModel> lists = [];
  late List<modonLastInfoModel> oneList = [];

  // 모돈 기록리스트 각 항목별
  late List<SanchaRecordModel> sanchaLists = List<SanchaRecordModel>.empty(growable: true);
  late List<BunmanRecordModel> bunmanLists =  List<BunmanRecordModel>.empty(growable: true);
  late List<EyuRecordModel> eyuLists = List<EyuRecordModel>.empty(growable: true);
  late List<PoyuRecordModel> poyuLists = List<PoyuRecordModel>.empty(growable: true);
  late List<VaccienRecordModel> vaccienLists = List<VaccienRecordModel>.empty(growable: true);
  late List<LocationRecordModel> locationRecordLists = List<LocationRecordModel>.empty(growable: true);

  //String sagoValue = '';
  ComboListModel? selectedLocation;
  ComboListModel? selectedSago;

  late TabController _tabController;
  late TabController _tabController2;

  TextEditingController bigoController = TextEditingController(text: '');

  // 모돈선택시 값
  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late String _sancha = "";
  late String _wkDt = "";
  late String _san = "";
  late String _statusCd = "";
  late String _statusName = "";

  //최종 모돈 도/폐사 상태값
  String dieOutYnValue = "N";

  // 경과일 = 이전작업일 - 사고일
  late int elapsedDay = 0;

  // 버튼 visible
  bool btnVisible = true;
  bool delBtnVibible = true;

  // 비고
  String bigo = "";

  String _locCd = "";

  // 날짜 셋팅
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // elapsedDay = int.parse(passDt);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _pigNo = pigNo;
    _sancha = sancha;
    _seq = seq;
    _wkGubun = wkgubun;
    _wkDt = wkDt;
    bigo = pbigo;

    print("passDt");
    print(passDt);

    _tabController = TabController(length: 6, vsync: this);
    _tabController2 = TabController(length: 6, vsync: this);

    _tabController.addListener(() {
        if (_tabController.indexIsChanging == false) {
          if(_tabController.index == 1) {
            //Trigger your request
          }
        }
      }
    );

    // 필요 정보 호출(개체정보, 사고구분, 장소)
    setState(() {
      method();
    });
  }

  method() async {
    // dropbox
    sagolists = await getSagoGbn();
    locationlists = await Util().getLocation('080001, 080002, 080003');

    var lastModonInfo = await getLastModonInfo();

    // 모돈 최종작업 및 이전 작업정보 조회
    var result = await Util().getLastModonInfo(pigNo, 'sgwr', seq, sancha, wkDt);
    _statusCd = result['last']['statusCd'];
    dieOutYnValue = result['last']['dieOutYn'].toString();

    await getSagoOne();

    // 코드값 조회
    _statusName = await getCodeJohapValue(_statusCd);

    if(sagoGubunCd == "050003" || sagoGubunCd == "050004" || sagoGubunCd == "050005" || sagoGubunCd == "050006") {
      btnVisible = false;
    }
    if(dieOutYnValue == "Y") {
      btnVisible = false;
      delBtnVibible = false;
    }

    // 넘어온 값 셋팅
    //사고일
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    selectedDate = dateFormat.parse(wkDt);

    // 임신사고원인
    if(sagoGubunCd != "") {
      selectedSago = sagolists.singleWhere((element) => element.code == sagoGubunCd);
    }

    //진단장소
    if(_locCd != "") {
      selectedLocation = locationlists.singleWhere((element) => element.code == _locCd);
    }

    //비고
    bigoController.text = pbigo;


    setState(() {
      // 임신사고원인 첫번째 선택
      // selectedSago = sagolists[0];

      // 경과일
      elapsedDay = int.parse(passDt);

      // elapsedDay = int.parse(DateTime.parse(selectedDate.toLocal().toString().split(" ")[0])
      //     .difference(DateTime.parse(wkDtP)).inDays.toString());
    });

    // 하단 tab list
    // 산차기록
    //sanchaLists = await getSanchaRecord(pigNo);
    // 분만기록
    //bunmanLists = await getBunmanRecord(pigNo);
    // 이유기록
    //eyuLists = await getIyuRecord(pigNo);
    // 포유자돈
    //poyuLists = await getPoyuPig(pigNo);
    // 백신기록
    //vaccienLists = await getVaccineRecord(pigNo);
    // 장소이동
    //locationRecordLists = await getMoveLocation(pigNo);

  }

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      allowFontScaling: false,
      builder: () => GestureDetector(
        onTap: () {
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
                    builder: (context) => PregnancyAccidentRecord(pPigNo: 0,),
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
                    Column(children: const [Text('개체번호', style: TextStyle(fontSize: 16.0))]),
                    Column(children: [Text(farmPigNo, style: const TextStyle(fontSize: 16.0))]),
                    Column(children: const [Text('이각번호', style: TextStyle(fontSize: 16.0))]),
                    Column(children: [Text(igakNo, style: const TextStyle(fontSize: 16.0))]),
                  ]),
                  TableRow(children: [
                    Column(children: const [Text('현재상태', style: TextStyle(fontSize: 16.0))]),
                    Column(children: [Text(_statusName, style: const TextStyle(fontSize: 16.0))]),
                    Column(children: const [Text('현재산차', style: TextStyle(fontSize: 16.0))]),
                    Column(children: [Text(_san, style: const TextStyle(fontSize: 16.0))]),
                  ]),
                ],
                ),
              ),
              // padding
              const Padding(padding: EdgeInsets.only(bottom: 20)),

              Container(
                child: ExpansionTile(
                  // key: formKey,
                  initiallyExpanded: true,
                  title: const Text(
                    '임신사고기록 수정',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  children: [
                    SizedBox(
                      width: 350,
                      child: ButtonBar(children: [
                        Container(
                          child: const Text(
                            '선택모돈',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Signatra',
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 130.0),
                        ),
                        SizedBox(
                          key: const ValueKey('modon'),
                          width: 100,
                          height: 25,
                          child:
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              farmPigNo,
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),

                    SizedBox(
                      width: 320,
                      child: Row(
                        children: [
                          Container(
                            child: const Text(
                              '사고일',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 35.0),
                          ),
                          ButtonTheme(
                            child: RaisedButton(
                              onPressed: () => _selectDate(context),
                              child: Text("${selectedDate.toLocal()}"
                                  .split(" ")[0]
                                  .toString()),
                            ),
                            buttonColor: Colors.grey,
                            height: 30,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Text('경과일 : $elapsedDay '),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),


                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                          children: [
                            Container(
                              child: const Text('임신사고원인',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 100.0),
                            ),
                            SizedBox(
                              width: 110,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('선택'),
                                value: selectedSago,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) async {
                                  setState(() {
                                    selectedSago = newValue!;
                                  });
                                },
                                items: sagolists.map((ComboListModel item) {
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
                          children: [
                            Container(
                              child: const Text('진단장소',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 130.0),
                            ),
                            SizedBox(
                              width: 110,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('선택'),
                                value: selectedLocation,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) async {
                                  setState(() {
                                    selectedLocation = newValue!;
                                  });

                                },
                                items: locationlists.map((ComboListModel item) {
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
                      height: 50,
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



                      child:
                          Row(
                            children: [
                              Column(children: const [Text('')]),
                              Column(children: [
                                Visibility(
                                  // visible: btnVisible,
                                  child:
                                  RaisedButton(
                                    onPressed: () async {

                                      setUpdate(selectedSago,
                                          selectedLocation, selectedDate);
                                    },
                                    child: const Text('수정', style: TextStyle(fontSize: 20)),
                                  ),

                                ),
                                /*
                                Visibility(
                                  visible: delBtnVibible,
                                  child:
                                  RaisedButton(
                                    onPressed: () async {

                                      setDelete(selectedSago, selectedLocation, selectedDate);
                                    },
                                    child: const Text('삭제', style: TextStyle(fontSize: 20)),
                                  ),
                                ),
                                */
                              ],
                              ),
                            ],
                          )



                      /*
                      RaisedButton(
                        child: const Text(
                          '수정',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          // setUpdate(farmNo, pigNo, selectedSago, selectedLocation, selectedDate);
                        },
                      ),
                      */



                    ),
                  ],
                ),
              ),


/*
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(120),
                  1: FlexColumnWidth(),
                },
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    Column(children: const [
                      Text('사고일', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      RaisedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('${selectedDate.toLocal()}'.split(" ")[0]),
                      ),
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: const [
                      Text('임신사고원인', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.circular(2)
                        ),
                        child: DropdownButton<ComboListModel>(
                          value: selectedSago,
                          hint: const Text('선택'),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: DropdownButtonHideUnderline(child: Container()),
                          onChanged: (ComboListModel? newValue) {
                            setState(() {
                              selectedSago = newValue!;
                            });
                          },
                          items: sagolists.map((ComboListModel item) {
                            return DropdownMenuItem<ComboListModel>(
                              child: Text(item.cname),
                              value: item,
                            );
                          }).toList(),
                        ),
                      )
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: const [
                      Text('진단장소', style: TextStyle(fontSize: 16.0))
                    ]),
                    Column(children: [
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid
                            ),
                            borderRadius: BorderRadius.circular(2)
                        ),
                        child: DropdownButton<ComboListModel>(
                          value: selectedLocation,
                          hint: const Text('선택'),
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: DropdownButtonHideUnderline(child: Container()),
                          onChanged: (ComboListModel? newValue) {
                            setState(() {
                              selectedLocation = newValue!;
                            });
                          },
                          items: locationlists.map((ComboListModel item) {
                            return DropdownMenuItem<ComboListModel>(
                              child: Text(item.cname),
                              value: item,
                            );
                          }).toList(),
                        ),
                      )
                    ]),
                  ]),
                  TableRow(
                    children: [
                      Column(children: const [
                        Text('비고', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        TextFormField(
                          cursorColor: Theme.of(context).cursorColor,
                          maxLength: 100,
                          controller: bigoController,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.favorite),
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            // labelText: '비고',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            // suffixIcon: Icon(
                            //   Icons.check_circle,
                            // ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            helperText: '',
                          ),
                        ),
                      ]),
                    ],
                  ),
                  TableRow(
                    children: [
                    Column(children: const [Text('')]),
                    Column(children: [
                      Visibility(
                        visible: btnVisible,
                        child:
                      RaisedButton(
                        onPressed: () async {

                          setUpdate(farmNo, pigNo, selectedSago,
                              selectedLocation, selectedDate);
                        },
                        child: const Text('수정', style: TextStyle(fontSize: 20)),
                      ),

                      ),
                      Visibility(
                        visible: delBtnVibible,
                        child:
                        RaisedButton(
                          onPressed: () async {

                            setDelete(farmNo, pigNo, selectedSago,
                                selectedLocation, selectedDate);
                          },
                          child: const Text('삭제', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                    ),
                  ]
                  ),
                ],
              ),
              */

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
                  ),
                ],
              )
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
        sagolists.add(ComboListModel.fromJson(data[i]));
      }
      setState(() {});
      return sagolists;
    } else {
      throw Exception('error');
    }
  }

  // 현재 모돈 최종 상태정보 조회
  Future<dynamic> getLastModonInfo() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = _baseUrl + "/pigplan/pmd/inputmd/selectMdLastAndJobInfo.json";
    var parameters = json.encode({
      'pigNo': pigNo.toString(),
      'seq': seq.toString(),
      'wkDt': wkDt,
      'sancha': sancha.toString(),
      'target': 'sgwr',
      'ifFlag': 'U',
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

      return data;
    } else {
      throw Exception('error');
    }
  }

  // 1건 조회
  getSagoOne() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    var url = _baseUrl + "pigplan/pmd/inputmd/selectSagoOne.json";
    var parameters = json.encode({
      'pigNo': pigNo.toString(),
      'dateFormat': 'yyyy-MM-dd',
      'wkDt': wkDt,
    });

    url += "?pigNo="+pigNo.toString()+"&dateFormat=yyyy-MM-dd&wkDt="+wkDt;

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

      print(data['locCd']);
      if(data['locCd'] != 0) {
        _locCd = data['locCd'].toString();
      } else {
        _locCd = "";
      }

      _san = data['san'];

      return "data";
    } else {
      throw Exception('error');
    }
  }

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

  // 데이터 저장
  setUpdate(ComboListModel? selectedSago,
      ComboListModel? selectedLocation, DateTime selectedDate) async {
    //var url = 'mobile/updateOrStoreSago.json';
    var url = 'pigplan/pmd/inputmd/updateOrStorePregnancy.json';

    const String _baseUrl = "http://192.168.3.46:8080/";

    var msg = "";
    bool result = true;

    var sagoValue = "";
    var locValue = "";

    if(selectedSago == null) {
      sagoValue = "";
    } else {
      sagoValue = selectedSago.code.toString();
    }

    if(selectedLocation == null) {
      locValue = "";
    } else {
      locValue = selectedLocation.code.toString();
    }

    final parameter = json.encode({
      'pigNo': pigNo.toString(),
      'sagoGubunCd': sagoValue,                  //사고코드
      'locCd': locValue,                         // 장소코드
      'bigo': bigoController.text.toString(),
      'wkDt': selectedDate.toLocal().toString().split(" ")[0], // 2021-11-03
      'seq': seq,
      'wkGubun': wkGubun,
      'targetWkDt': wkDt,
      'iuFlag': 'U', // I, U
      'lang': 'ko',
      'dateFormat': 'yyyy-MM-dd',
    });

    dynamic session_id = await FlutterSession().get("SESSION_ID");

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

    if (response.statusCode == 200 && result == true) {
      // 수정 성공시, 초기화
      _showDialog(context, "수정 되었습니다.");
      return "sucess";
    } else if (result == false) {
      _showDialog(context, msg);
    } else {
      throw Exception('error');
      return "false";
    }

  }

  // 삭제
  Future<String> setDelete(ComboListModel? selectedSago,
      ComboListModel? selectedLocation, DateTime selectedDate) async {

    var url = 'pigplan/pmd/inputmd/updateOrStorePregnancy.json';

    const String _baseUrl = "http://192.168.3.46:8080/";

    print(selectedSago!.code.toString());
    print(selectedLocation!.code);

    final parameter = json.encode({
      'pigNo': _pigNo,
      'sagoGubunCd': selectedSago.code.toString(), //사고코드
      'locCd': selectedLocation.code.toString(), // 장소코드
      'bigo': bigoController.text.toString(),
      'wkDt': selectedDate.toLocal().toString().split(" ")[0], // 2021-11-03
      'seq': seq,
      'wkGubun': wkGubun,
      'targetWkDt': wkDt,
      'iuFlag': 'U', // I, U
      'lang': 'ko',
      'dateFormat': 'yyyy-MM-dd',
    });

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

    if (response.statusCode == 200) {
      return "sucess";
    } else {
      throw Exception('error');
      return "false";
    }
  }

  // 초기화
  reset() {
    selectedSago = sagolists[0];
    // 진단장소
    selectedLocation = null;
    bigoController.text = "";

    setState(() { });
  }

  // alert dialog
  _showDialog(context, String text) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(''),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text('확인'),
              onPressed: () {
                // Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            )
          ],
        )
    );
  }


}
