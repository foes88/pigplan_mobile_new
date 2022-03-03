import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:pigplan_mobile/model/modon_last_info_model.dart';
import 'package:pigplan_mobile/model/record/child_birth_model.dart';

import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:pigplan_mobile/model/record/eungdon_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:pigplan_mobile/model/modon_history/bunman_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/eyu_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/location_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/poyu_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/sancha_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/vaccien_record_model.dart';
import 'package:pigplan_mobile/model/record/poyu_modon_model.dart';
import 'package:pigplan_mobile/model/record/pregnancy_accident_record_model.dart';
import 'package:pigplan_mobile/record/modon_history_page/bunman_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/eyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/location_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/poyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/sancha_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/vaccien_page.dart';
import 'package:pigplan_mobile/record/weaning_record.dart';

import 'child_birth.dart';

class ChildBirthDetail extends StatefulWidget {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final int sancha;
  final String igakNo;
  // final String sagoGubunNm;
  final int seq;
  final String wkPersonCd;
  final String locCd;
  final String wkGubun;
  final String pbigo;
  final String wkDt;
  final String bunmanGubunCd;

  const ChildBirthDetail({
    Key? key,
    required this.farmNo,
    required this.pigNo,
    required this.farmPigNo,
    required this.sancha,
    required this.igakNo,
    // required this.sagoGubunNm,
    required this.seq,
    required this.wkPersonCd,
    required this.locCd,
    required this.wkGubun,
    required this.pbigo,
    required this.wkDt,
    required this.bunmanGubunCd,
  }) : super(key: key);

  @override
  _ChildBirthDetail createState() => _ChildBirthDetail(
    farmNo, pigNo, farmPigNo, sancha, igakNo,
    // sagoGubunNm,
    seq, wkPersonCd, locCd, wkGubun, pbigo, wkDt, bunmanGubunCd,
  );
}

class _ChildBirthDetail extends State<ChildBirthDetail>
    with TickerProviderStateMixin {
  final int farmNo;
  final int pigNo;
  final String farmPigNo;
  final int sancha;
  final String igakNo;
  // final String sagoGubunNm;
  final int seq;
  final String wkPersonCd;
  final String locCd;
  final String wkgubun;
  final String pbigo;
  final String wkDt;
  final String bunmanGubunCd;

  _ChildBirthDetail(
      this.farmNo, this.pigNo, this.farmPigNo, this.sancha, this.igakNo,
      // this.sagoGubunNm,
      this.seq, this.wkPersonCd, this.locCd, this.wkgubun, this.pbigo, this.wkDt, this.bunmanGubunCd,
      );

  late List<ComboListModel> sagogbn = List<ComboListModel>.empty(growable: true);
  late List<ComboListModel> sagolists = List<ComboListModel>.empty(growable: true);

  late List<PregnancyAccidentRecordModel> lists = [];

  // 모돈 기록리스트 각 항목별
  late List<SanchaRecordModel> sanchaLists = List<SanchaRecordModel>.empty(growable: true);
  late List<BunmanRecordModel> bunmanLists = List<BunmanRecordModel>.empty(growable: true);
  late List<EyuRecordModel> eyuLists = List<EyuRecordModel>.empty(growable: true);
  late List<PoyuRecordModel> poyuLists = List<PoyuRecordModel>.empty(growable: true);
  late List<VaccienRecordModel> vaccienLists = List<VaccienRecordModel>.empty(growable: true);
  late List<LocationRecordModel> locationRecordLists = List<LocationRecordModel>.empty(growable: true);

  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];

  late List<ComboListModel> edGbnList = [];

  TextEditingController bigoController = TextEditingController(text: '');

  // 총산
  TextEditingController chongSanController = TextEditingController(text: '0');
  // 미라
  TextEditingController milaController = TextEditingController(text: '0');
  // 사산
  TextEditingController sasanController = TextEditingController(text: '0');
  // 체미
  TextEditingController cmController = TextEditingController(text: '0');
  // 기형
  TextEditingController ghController = TextEditingController(text: '0');
  // 쇄항
  TextEditingController shController = TextEditingController(text: '0');
  // 창상
  TextEditingController csController = TextEditingController(text: '0');
  // 탈장
  TextEditingController tjController = TextEditingController(text: '0');
  // 기타
  TextEditingController gtController = TextEditingController(text: '0');
  // 요약 - 실산 / 포유개시
  TextEditingController silsanController = TextEditingController();
  TextEditingController pouController = TextEditingController();
  // 실산 - 암 / 수
  TextEditingController silsanFemaleController = TextEditingController(text: '0');
  TextEditingController silsanMaleController = TextEditingController(text: '0');
  // 자돈 평균체중
  TextEditingController avgKgController = TextEditingController();
  // 자돈 총체중
  TextEditingController saengsiKgController = TextEditingController();
  // 양자전입 - 암 / 수
  TextEditingController junipDusuController = TextEditingController();
  TextEditingController junipDusuSuController = TextEditingController();
  // 양자전출 - 암 / 수
  TextEditingController junchulDusuController = TextEditingController();
  TextEditingController junchulDusuSuController = TextEditingController();

  late TabController _tabController;
  late TabController _tabController2;

  // 분만구분
  late List<ComboListModel> bunmanGubunList = [];
  ComboListModel? bunmanGubunValue;

  // 분만장소
  late List<ComboListModel> bunmanLocationList = [];
  ComboListModel? bunmanLocationValue;

  // 분만틀
  late List<ComboListModel> farrowingList = [];
  ComboListModel? farrowingValue;

  // 전입모돈 리스트
  late List<ComboListModel> junipModonList = [];
  ComboListModel? junipModonValue;

  // 전출모돈 리스트
  late List<ComboListModel> junchulModonList = [];
  ComboListModel? junchulModonValue;

  // 모돈선택시 값
  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;
  late String _wkDt = "";
  late String _locCd = "";
  late String _san = "";
  late String _statusCd = "";
  late String _statusName = "";

  // 양자 전입
  late String _jisearchValue = "";
  late String _jiwkGubun = "";
  late String _jitargetWkDt = "";
  late int _jipigNo = 0;
  late int _jiseq = 0;
  late int _jisancha = 0;

  // 양자 전출
  late String _jcsearchValue = "";
  late String _jcwkGubun = "";
  late String _jctargetWkDt = "";
  late int _jcpigNo = 0;
  late int _jcseq = 0;
  late int _jcsancha = 0;

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

    _pigNo = pigNo;
    _sancha = sancha;
    _seq = seq;
    _wkGubun = wkgubun;
    _wkDt = wkDt;
    bigo = pbigo;
    _tabController = TabController(length: 6, vsync: this);
    _tabController2 = TabController(length: 6, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        if (_tabController.index == 1) {
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
    // lists = await getList();
    await getRecord();

    gbList = await Util().getFarmCodeList('', 'G');
    lcList = await Util().getLocation('080004');
    edList = await Util().getEungdon();

    // 모돈 최종작업 및 이전 작업정보 조회
    var result = await Util().getLastModonInfo(pigNo, 'bmwr', seq, sancha, wkDt);
    _statusCd = result['last']['statusCd'];

    // 코드값 조회
    _statusName = await getCodeJohapValue(_statusCd);

    // 분만구분
    bunmanGubunList = await Util().getCodeListFromUrl('/common/comboBunmanGubun.json');

    // 분만장소
    bunmanLocationList = await Util().getLocation('080004');

    // 분만틀

    // 전입 모돈 리스트
    junipModonList = await Util().getCodeListFromUrl('/common/combogridPouModonList.json?inOut=IN');

    // 전출 모돈 리스트
    junchulModonList = await Util().getCodeListFromUrl('/common/combogridPouModonList.json?inOut=OUT');

    // 넘어온 값 셋팅
    // 분만일
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    selectedDate = dateFormat.parse(wkDt);

    // 분만구분
    if(bunmanGubunCd != "") {
      bunmanGubunValue = bunmanGubunList.singleWhere((element) => element.code == bunmanGubunCd);
    }

    // 분만장소
    print(_locCd);
    if(_locCd.isNotEmpty) {
      bunmanLocationValue = bunmanLocationList.singleWhere((element) => element.code == _locCd);
    }

    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    if (bigo.isNotEmpty) {
      bigoController.text = bigo;
    }

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
                      builder: (context) => ChildBirth(pPigNo: 0,),
                    )
                ),
              ),
            ),
            body: ListView(
              children: [
                // 상단 선택 모돈 정보 영역
                const Padding(padding: EdgeInsets.only(top: 10)),
                Table(
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
                      borderRadius: const BorderRadius.all(Radius.circular(5))
                  ),
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
                        Text(_statusName, style: TextStyle(fontSize: 16.0))
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
                // 저장 부분
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                Container(
                  child: ExpansionTile(
                    // key: formKey,
                    initiallyExpanded: true,
                    title: const Text(
                      '분만기록 수정',
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
                            padding: const EdgeInsets.only(right: 100.0),
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
                        ],
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: Row(
                          children: [
                            Container(
                              child: const Text(
                                '분만일',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 35.0),
                            ),
                            ButtonTheme(
                              child: RaisedButton(
                                onPressed: () => _selectFromDate(context),
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
                                child: const Text(
                                  '분만구분',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Signatra',
                                  ),
                                ),
                                padding: const EdgeInsets.only(right: 100.0),
                              ),
                              SizedBox(
                                key: const ValueKey('gyobaelc'),
                                width: 130,
                                child: DropdownButton(
                                  isDense: true,
                                  isExpanded: true,
                                  hint: const Text('선택'),
                                  value: bunmanGubunValue,
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (ComboListModel? newValue) {
                                    setState(() {

                                      bunmanGubunValue = newValue!;
                                    });
                                  },
                                  items:
                                  bunmanGubunList.map((ComboListModel item) {
                                    return DropdownMenuItem<ComboListModel>(
                                      child: Text(item.cname),
                                      value: item,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                          width: 350,
                          child: ButtonBar(
                            children: [
                              Container(
                                child: const Text(
                                  '분만장소',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Signatra',
                                  ),
                                ),
                                padding: const EdgeInsets.only(right: 100.0),
                              ),
                              SizedBox(
                                key: const ValueKey('gyobaelc'),
                                width: 130,
                                child: DropdownButton(
                                  isDense: true,
                                  isExpanded: true,
                                  hint: const Text('선택'),
                                  value: bunmanLocationValue,
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (ComboListModel? newValue) {
                                    setState(() {
                                      bunmanLocationValue = newValue!;
                                    });
                                    // 장소 변경시, 분만틀 조회
                                    // farrowingList = await Util().getFarmFarrowing(diedLocationValue!.code.toString());
                                  },
                                  items: bunmanLocationList
                                      .map((ComboListModel item) {
                                    return DropdownMenuItem<ComboListModel>(
                                      child: Text(item.cname),
                                      value: item,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                          width: 350,
                          child: ButtonBar(
                              buttonPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: chongSanController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
                                    decoration: const InputDecoration(
                                        labelText: "총산",
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
                                      if(chongSanController.text == '0') {
                                        chongSanController.text = '';
                                      }
                                    },
                                    onChanged: (text) {

                                      if(chongSanController.text == "") {
                                        return;
                                      }

                                      // 35마리 이상 입력 불가
                                      if(int.parse(chongSanController.text) > 35) {
                                        _showDialog(context,"총산은 35두 이상 입력할 수 없습니다.");
                                        chongSanController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      // 총산 - 미라 - 사산 = 실산
                                      silsanController.text = text;
                                      pouController.text = text;

                                      // 포유개시
                                      if(chongSanController.text != "") {
                                        pouController.text =
                                            (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                                                - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                                                - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
                                            ).toString();
                                      }

                                      // 총산 입력시, 자돈 평균체중이랑 총제중이 없을경우는 계산 X
                                      // 자돈 평균체중이 있으면, 총체중 입력
                                      // else 면 반대
                                      /*
                                if((avgKgController.text != "" || avgKgController.text != "0")
                                    && (saengsiKgController.text != "" || saengsiKgController.text != "0")) {

                                  if(avgKgController.text != "" && avgKgController.text != "0") {
                                    print("여기 타나");
                                    saengsiKgController.text = (int.parse(chongSanController.text) * double.parse(avgKgController.text)).toString();
                                  } else {
                                    avgKgController.text = (double.parse(saengsiKgController.text) / int.parse(chongSanController.text)).toString();
                                  }
                                }
                                */

                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: milaController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true)],
                                    decoration: const InputDecoration(
                                        labelText: "미라",
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
                                      if(milaController.text == '0') {
                                        milaController.text = '';
                                      }

                                    },
                                    onChanged: (text) {
                                      if(milaController.text == "") {
                                        return;
                                      }
                                      if(int.parse(milaController.text) > 35) {
                                        _showDialog(context,"25두 이상 입력할 수 없습니다.");
                                        milaController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      // 총산 - 미라 - 사산 = 실산
                                      silsanController.text = (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)).toString();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: sasanController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
                                    decoration: const InputDecoration(
                                        labelText: "사산",
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
                                      if(sasanController.text == '0') {
                                        sasanController.text = '';
                                      }
                                    },
                                    onChanged: (text) {
                                      if(sasanController.text == "") {
                                        return;
                                      }
                                      if(int.parse(sasanController.text) > 35) {
                                        _showDialog(context,"25두 이상 입력할 수 없습니다.");
                                        sasanController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      pouController.text =
                                          (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                                              - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                                              - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
                                          ).toString();
                                    },
                                  ),
                                ),
                              ])),
                      SizedBox(
                          width: 350,
                          child: ButtonBar(
                              buttonPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: cmController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
                                    decoration: const InputDecoration(
                                        labelText: "체미",
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
                                      if(cmController.text == '0') {
                                        cmController.text = '';
                                      }
                                    },
                                    onChanged: (text) {
                                      if(cmController.text == "") {
                                        return;
                                      }
                                      if(int.parse(cmController.text) > 35) {
                                        _showDialog(context,"25두 이상 입력할 수 없습니다.");
                                        cmController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      pouController.text =
                                          (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                                              - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                                              - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
                                          ).toString();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: ghController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
                                    decoration: const InputDecoration(
                                        labelText: "기형",
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
                                      if(ghController.text == '0') {
                                        ghController.text = '';
                                      }
                                    },
                                    onChanged: (text) {
                                      if(ghController.text == "") {
                                        return;
                                      }
                                      if(int.parse(ghController.text) > 35) {
                                        _showDialog(context,"25두 이상 입력할 수 없습니다.");
                                        ghController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      pouController.text =
                                          (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                                              - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                                              - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
                                          ).toString();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: shController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
                                    decoration: const InputDecoration(
                                        labelText: "쇄항",
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
                                      if(shController.text == '0') {
                                        shController.text = '';
                                      }
                                    },
                                    onChanged: (text) {
                                      if(shController.text == "") {
                                        return;
                                      }
                                      if(int.parse(shController.text) > 35) {
                                        _showDialog(context,"25두 이상 입력할 수 없습니다.");
                                        shController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      pouController.text =
                                          (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                                              - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                                              - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
                                          ).toString();
                                    },
                                  ),
                                ),
                              ])),
                      SizedBox(
                          width: 350,
                          child: ButtonBar(
                              buttonPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: csController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
                                    decoration: const InputDecoration(
                                        labelText: "창상",
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
                                      if(csController.text == '0') {
                                        csController.text = '';
                                      }
                                    },
                                    onChanged: (text) {
                                      if(csController.text == "") {
                                        return;
                                      }
                                      if(int.parse(csController.text) > 35) {
                                        _showDialog(context,"25두 이상 입력할 수 없습니다.");
                                        csController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      pouController.text =
                                          (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                                              - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                                              - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
                                          ).toString();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: tjController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
                                    decoration: const InputDecoration(
                                        labelText: "탈장",
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
                                      if(tjController.text == '0') {
                                        tjController.text = '';
                                      }
                                    },
                                    onChanged: (text) {
                                      if(tjController.text == "") {
                                        return;
                                      }
                                      if(int.parse(tjController.text) > 35) {
                                        _showDialog(context,"25두 이상 입력할 수 없습니다.");
                                        tjController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      pouController.text =
                                          (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                                              - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                                              - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
                                          ).toString();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 50,
                                  child: TextFormField(
                                    controller: gtController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
                                    decoration: const InputDecoration(
                                        labelText: "기타",
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
                                      if(gtController.text == '0') {
                                        gtController.text = '';
                                      }
                                    },
                                    onChanged: (text) {
                                      if(gtController.text == "") {
                                        return;
                                      }
                                      if(int.parse(gtController.text) > 35) {
                                        _showDialog(context,"25두 이상 입력할 수 없습니다.");
                                        gtController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      pouController.text =
                                          (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                                              - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                                              - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
                                          ).toString();
                                    },
                                  ),
                                ),
                              ])),
                      SizedBox(
                          width: 350,
                          child: ButtonBar(children: [
                            Container(
                              child: const Text(
                                '요약',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 55.0),
                            ),
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: TextFormField(
                                controller: silsanController,
                                textInputAction: TextInputAction.done,
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: "실산",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  fillColor: Colors.amberAccent,
                                  filled: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              height: 55,
                              child: TextFormField(
                                controller: pouController,
                                textInputAction: TextInputAction.done,
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: "포유개시",
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  fillColor: Colors.amberAccent,
                                  filled: true,
                                ),
                              ),
                            ),
                          ])),
                      SizedBox(
                        width: 350,
                        child: ButtonBar(
                            buttonPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            children: [
                              SizedBox(
                                width: 120,
                                height: 55,
                                child: TextFormField(
                                  controller: avgKgController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    labelText: "자돈 평균체중",
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  onChanged: (text) {
                                    if(double.parse(text) > 3.0 ) {
                                      _showDialog(context,"생시체중이 두당 3kg 를 넘을 수 없습니다.");
                                      avgKgController.text = "";
                                      saengsiKgController.text = "";
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }
                                    saengsiKgController.text =
                                        ((double.parse(text)) * (int.parse(silsanController.text.toString()))).toString();
                                  },
                                  onTap: () {
                                    if(avgKgController.text == '0') {
                                      avgKgController.text = '';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                height: 55,
                                child: TextFormField(
                                  controller: saengsiKgController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      labelText: "자돈 총체중",
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red),
                                      )
                                  ),
                                  onChanged: (text) {
                                    // 총산이 있을 경우.
                                    // 자동 총체중 / 총산 했을때 3넘으면 X
                                    if(chongSanController.text != "0") {
                                      var tmpRslt = double.parse(saengsiKgController.text) / int.parse(chongSanController.text);

                                      if(tmpRslt > 3.0 ) {
                                        _showDialog(context,"생시체중이 두당 3kg 를 넘을 수 없습니다.");
                                        avgKgController.text = "";
                                        saengsiKgController.text = "";
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }
                                    }

                                    if(chongSanController.text != "0") {
                                      avgKgController.text =
                                          (double.parse(saengsiKgController.text) / int.parse(chongSanController.text)).toStringAsFixed(2);
                                    }

                                  },
                                  onTap: () {
                                    if(saengsiKgController.text == '0') {
                                      saengsiKgController.text = '';
                                    }
                                  },
                                ),
                              ),
                            ]
                        ),
                      ),
                      /*
                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                            children: [
                              Container(
                                child: const Text('실산',
                                  style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                                ),
                                padding: const EdgeInsets.only(right: 55.0),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: silsanFemaleController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    labelText: "암",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  onChanged: (text) {
                                    // 실산 암 + 수 했을때 총산보다 클 경우 return;
                                    if((int.parse(silsanFemaleController.text)+int.parse(silsanMaleController.text)) > int.parse(silsanController.text) ) {
                                      _showDialog(context,"[실산(암/수)]이(가) [실산]을(를) 초과할 수 없습니다.");
                                      silsanFemaleController.text = '0';
                                      if(silsanMaleController.text == '') {
                                        silsanMaleController.text = '0';
                                      }
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }
                                  },
                                  onTap: () {
                                    if(silsanFemaleController.text == '0') {
                                      silsanFemaleController.text = '';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: silsanMaleController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      labelText: "수",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red),
                                      )
                                  ),
                                  onChanged: (text) {
                                    // 실산 암 + 수 했을때 총산보다 클 경우 return;
                                    if((int.parse(silsanFemaleController.text)+int.parse(silsanMaleController.text)) > int.parse(silsanController.text) ) {
                                      _showDialog(context,"[실산(암/수)]이(가) [실산]을(를) 초과할 수 없습니다.");
                                      silsanMaleController.text = '0';
                                      if(silsanFemaleController.text == '') {
                                        silsanFemaleController.text = '0';
                                      }
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }
                                  },
                                  onTap: () {
                                    if(silsanMaleController.text == '0') {
                                      silsanMaleController.text = '';
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
                                child: const Text('양자전입',
                                  style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                                ),
                                padding: const EdgeInsets.only(right: 70.0),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: junipDusuController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      labelText: "암",
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
                                width: 50,
                                child: TextFormField(
                                  controller: junipDusuSuController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      labelText: "수",
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
                                width: 80,
                                child:  DropdownSearch(
                                  // mode: Mode.MENU,
                                  showSearchBox: true,
                                  scrollbarProps: ScrollbarProps(
                                    isAlwaysShown: true,
                                    thickness: 4,
                                  ),
                                  onFind: (String? filter) => getCodeListFromUrl(filter!),
                                  itemAsString: (PoyuModonModel? m) => m!.farmPigNo.toString(),
                                  onChanged: (PoyuModonModel? value) => setState(() {
                                    _jisearchValue = value!.farmPigNo.toString();
                                    _jipigNo = value.pigNo;
                                    _jiseq = value.seq;
                                    _jiwkGubun = value.wkGubun;
                                    _jitargetWkDt = value.lastWkDt;
                                    _jisancha = value.sancha;

                                  }),
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
                                child: const Text('양자전출',
                                  style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                                ),
                                padding: const EdgeInsets.only(right: 70.0),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: junchulDusuController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      labelText: "암",
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
                                width: 50,
                                child: TextFormField(
                                  controller: junchulDusuSuController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      labelText: "수",
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
                                width: 80,
                                child:  DropdownSearch(
                                  // mode: Mode.MENU,
                                  showSearchBox: true,
                                  scrollbarProps: ScrollbarProps(
                                    isAlwaysShown: true,
                                    thickness: 4,
                                  ),
                                  onFind: (String? filter) => getCodeListFromUrl(filter!),
                                  itemAsString: (PoyuModonModel? m) => m!.farmPigNo.toString(),
                                  onChanged: (PoyuModonModel? value) => setState(() {
                                    _jcsearchValue = value!.farmPigNo.toString();
                                    _jcpigNo = value.pigNo;
                                    _jcseq = value.seq;
                                    _jcwkGubun = value.wkGubun;
                                    _jctargetWkDt = value.lastWkDt;
                                    _jcsancha = value.sancha;

                                  }),
                                ),
                              ),
                            ]
                        )
                    ),
                    */

                      SizedBox(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          key: const ValueKey('bigo'),
                          controller: bigoController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              labelText: "비고",
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
                          child: const Text(
                            '수정',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            setUpdate(bigoController.text, selectedDate);
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
      ),
    );
  }

  String _baseUrl = "http://192.168.3.46:8080/";

  // 선택 모돈 상게 내역 조회
  getRecord() async {
    List<ChildBirthModel> data = List<ChildBirthModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    var url = _baseUrl + "/pigplan/pmd/inputmd/selectChildbirthOne.json" +
        "?pigNo=" + _pigNo.toString()+"&wkDt=" + _wkDt +
        "&wkGubun=" + _wkDt+"&sancha=" + _sancha.toString()+"&seq=" + _seq.toString()+"&sysEnv=";

    var parameters = {
      'pigNo': _pigNo,
      'wkDt': _wkDt,
      'wkGubun': _wkGubun,
      'sancha': _sancha,
      'seq': _seq,
      'sysEnv': '',
    };

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        'cookie': session_id,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {

      if(response.body.isNotEmpty) {
        var data = jsonDecode(response.body);

        // 총산
        if(data['chongSan'] == null) {
          chongSanController.text = "0";
        } else {
          chongSanController.text = data['chongSan'].toString();
        }

        // 미라
        if(data['mila'] == null) {
          milaController.text = "0";
        } else {
          milaController.text = data['mila'].toString();
        }

        // 사산
        if(data['sasan'] == null) {
          sasanController.text = "0";
        } else {
          sasanController.text = data['sasan'].toString();
        }

        // 체미
        if(data['cm'] == null) {
          cmController.text = "0";
        } else {
          cmController.text = data['cm'].toString();
        }

        // 기형
        if(data['gh'] == null) {
          ghController.text = "0";
        } else {
          ghController.text = data['gh'].toString();
        }

        // 쇄항
        if(data['sh'] == null) {
          shController.text = "0";
        } else {
          shController.text = data['sh'].toString();
        }

        // 창상
        if(data['cs'] == null) {
          csController.text = "0";
        } else {
          csController.text = data['cs'].toString();
        }

        // 탈장
        if(data['tj'] == null) {
          tjController.text = "0";
        } else {
          tjController.text = data['tj'].toString();
        }

        // 기타
        if(data['gt'] == null) {
          gtController.text = "0";
        } else {
          gtController.text = data['gt'].toString();
        }

        // 분만 장소
        if(data['locCd'] == null) {
          _locCd = "";
        } else {
          _locCd = data['locCd'].toString();
        }

        _san = data['san'];

        bigoController.text = data['bigo'];

        // 실산 - 암
        silsanFemaleController.text = data['silsanAm'].toString();
        // 실산 - 수
        silsanMaleController.text = data['silsanSu'].toString();
        // 자돈 평균체중
        avgKgController.text = data['avgKg'].toString();
        // 자돈 총체중
        saengsiKgController.text = data['saengsiKg'].toString();

        // 요약 - 실산
        silsanController.text = (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)).toString();
        // 요약 - 포유개시
        pouController.text =
            (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
            ).toString();

        // 양자전입 - 암
        if(data['junipDusu'] == null) {
          junipDusuController.text = "0";
        } else {
          junipDusuController.text = data['junipDusu'].toString();
        }

        // 양자전입 - 수
        if(data['junipDusuSu'] == null) {
          junipDusuSuController.text = "0";
        } else {
          junipDusuSuController.text = data['junipDusuSu'].toString();
        }

        // 양자전출 - 암
        if(data['junchulDusu'] == null) {
          junchulDusuController.text = "0";
        } else {
          junchulDusuController.text = data['junchulDusu'].toString();
        }

        // 양자전출 - 수
        if(data['junchulDusuSu'] == null) {
          junchulDusuSuController.text = "0";
        } else {
          junchulDusuSuController.text = data['junchulDusuSu'].toString();
        }

        if(data['wkDtP'] != ''|| data['wkDtP'] != null) {
          // 경과일
          elapsedDay = int.parse(today.difference(DateTime.parse(data['wkDtP'])).inDays.toString());
        }

        setState(() {});
        return data;
      }
    } else {
      throw Exception('error');
    }
  }

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
    var parameters = {'pcodeTp': '080001, 080002, 080003', 'lang': 'ko'};

    final uri = Uri.http('192.168.3.46:8080',
        '/pigplan/pmd/inputmd/selectSagoOne.json', parameters);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'cookie': session_id,
    });

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
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
    late List<ModonDropboxModel> modonList =
    List<ModonDropboxModel>.empty(growable: true);

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

  // 현재 모돈 최종 상태정보 조회
  /*
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
      'target': 'bmwr',
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
  setUpdate(String bigo, DateTime selectedDate) async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = '/pigplan/pmd/inputmd/updateOrStoreChildbirth.json';

    var msg = "";
    bool result = true;

    if(chongSanController.text == "" || chongSanController.text == "0") {
      _showDialog(context,"총산을 입력해주세요.");
      FocusScope.of(context).unfocus();
      return;
    }

    // 총산 < 실산 X
    if(int.parse(chongSanController.text) < int.parse(silsanController.text)) {
      _showDialog(context,"총산, 실산을 확인해주세요.");
      FocusScope.of(context).unfocus();
      return;
    }

    // 실산 or 포유가 = 0 X
    if(int.parse(silsanController.text) == 0 ||
        int.parse(pouController.text) == 0) {
      _showDialog(context,"실산, 포유개시가 0일 수 없습니다.");
      FocusScope.of(context).unfocus();
      return;
    }

    /*
    // 양자 전입 수
    if(junipDusuController.text == "") {
      junipDusuController.text = "0";
    }

    // 양자전입 암
    if(junipDusuSuController.text == "") {
      junipDusuSuController.text = "0";
    }

    // 양자 전입 모돈
    if(junipModonValue == null) {
      _jisearchValue = "";
    }

    // 양자 전출 수
    if(junchulDusuController.text == "") {
      junchulDusuController.text = "0";
    }

    // 양자 전출 암
    if(junchulDusuSuController.text == "") {
      junchulDusuSuController.text = "0";
    }

    // 양자 전출 모돈
    if(junchulModonValue == null) {
      _jcsearchValue = "";
    }
     */

    final parameter = json.encode({
      "pigNo": _pigNo,
      "sancha": _sancha,
      "searchPigNo": "",
      "seq": _seq,
      "topPigNo": _pigNo,
      'wkDt': selectedDate.toLocal().toString().split(" ")[0],    // 분만일
      "bunmanGubunCd": bunmanGubunValue!.code.toString() ,        // 분만구분
      "locCd": bunmanLocationValue!.code.toString(),              // 분만장소
      "chongSan": int.parse(chongSanController.text),             // 총산
      "mila": int.parse(milaController.text),                     // 미라
      "sasan": int.parse(sasanController.text),                   // 사산
      "cm": int.parse(cmController.text),                         // 체미
      "gh": int.parse(ghController.text),                         // 기형
      "sh": int.parse(shController.text),                         // 쇄항
      "cs": int.parse(csController.text),                         // 창상
      "tj": int.parse(tjController.text),                         // 탈장
      "gt": int.parse(gtController.text),                         // 기타
      "silsan": int.parse(silsanController.text),                 // 요약 - 실산(요약의 포유개시는 보여주기만 하는듯?)
      "silsanAm": int.parse(silsanFemaleController.text),         // 실산 - 암
      "silsanSu": int.parse(silsanMaleController.text),           // 실산 - 수
      "avgKg": double.parse(avgKgController.text),                // 자돈 평균체중
      "saengsiKg": double.parse(saengsiKgController.text),        // 자돈 총체중
      "junipDusu": int.parse(junipDusuController.text),           // 양자 전입 - 수
      "junipDusuSu": int.parse(junipDusuSuController.text),       // 양자 전입 - 암
      "yinPigNo": _jisearchValue,               // 양자 전입 - 모돈번호
      "junchulDusu": int.parse(junchulDusuController.text),       // 양자 전출 - 수
      "junchulDusuSu": int.parse(junchulDusuSuController.text),   // 양자 전출 - 암
      "youtPigNo": _jcsearchValue,            // 양자 전출 - 모돈번호
      "bigo": bigo,                                               // 비고
      "wkGubun": _wkGubun,
      "iuFlag": "U",
      "farmConfChongsanAuto": "N",
      "gyobaeCnt": 0,
      "fwNo": "",
      "popSearchOrder": "NEXT_DT",
      "popSearchStatusCode": "",
      "targetWkDt": "",
      "topIgakNo": "",
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

    result = jsonDecode(response.body)['result'];
    msg = jsonDecode(response.body)['msg'];

    if (response.statusCode == 200 && result == true) {
      _showDialog(context, "수정 되었습니다.");
      return "sucess";
    } else if (result == false) {
      _showDialog(context, msg);
    } else {
      throw Exception('error');
      return "false";
    }
  }

  // api url로 특정 코드 리스트 조회
  Future<List<PoyuModonModel>> getCodeListFromUrl(String filter) async {
    const String _baseUrl = "http://192.168.3.46:8080/";
    String url = 'common/combogridPouModonList.json?inOut=IN';
    print(filter);
    if (filter.isNotEmpty) {
      filter = "&farmPigNo=" + filter;
    }
    print(filter);
    late List<PoyuModonModel> cbList =
    List<PoyuModonModel>.empty(growable: true);
    // RequestBody로 받아줘서 body로 넘기는게 가능
    url = _baseUrl + url + filter;

    var parameters = json.encode({
      'lang': 'ko',
    });

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

      for (int i = 0; i < data.length; i++) {
        cbList.add(PoyuModonModel.fromJson(data[i]));
      }

      return cbList;
    } else {
      throw Exception('error');
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
        ));
  }

  // 초기화
  reset() {


    bigoController.text = "";
    setState(() { });
  }

}
