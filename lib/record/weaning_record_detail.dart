import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
import 'package:pigplan_mobile/model/record/child_birth_model.dart';

import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:client_cookie/client_cookie.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pigplan_mobile/model/record/eungdon_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:pigplan_mobile/model/modon_history/bunman_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/eyu_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/location_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/poyu_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/sancha_record_model.dart';
import 'package:pigplan_mobile/model/modon_history/vaccien_record_model.dart';
import 'package:pigplan_mobile/model/modon_last_info_model.dart';
import 'package:pigplan_mobile/model/record/poyu_modon_model.dart';
import 'package:pigplan_mobile/model/record/pregnancy_accident_record_model.dart';
import 'package:pigplan_mobile/model/record/weaning_model.dart';
import 'package:pigplan_mobile/record/modon_history_page/bunman_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/eyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/location_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/poyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/sancha_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/vaccien_page.dart';
import 'package:pigplan_mobile/record/weaning_record.dart';

class WeaningDetail extends StatefulWidget {
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
  final String autoGb;

  const WeaningDetail({
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
    required this.autoGb,
  }) : super(key: key);

  @override
  _WeaningDetail createState() => _WeaningDetail(
    farmNo,
    pigNo,
    farmPigNo,
    sancha,
    igakNo,
    // sagoGubunNm,
    seq,
    wkPersonCd,
    locCd,
    wkGubun,
    pbigo,
    wkDt,
    autoGb,
  );
}

class _WeaningDetail extends State<WeaningDetail>
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
  final String autoGb;

  _WeaningDetail(
      this.farmNo,
      this.pigNo,
      this.farmPigNo,
      this.sancha,
      this.igakNo,
      // this.sagoGubunNm,
      this.seq,
      this.wkPersonCd,
      this.locCd,
      this.wkgubun,
      this.pbigo,
      this.wkDt,
      this.autoGb,
  );

  late List<ComboListModel> sagogbn = List<ComboListModel>.empty(growable: true);
  late List<ComboListModel> sagolists = List<ComboListModel>.empty(growable: true);

  late List<PregnancyAccidentRecordModel> lists = [];

  // ?????? ??????????????? ??? ?????????
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

  // ???????????? - ???
  TextEditingController dusuController = TextEditingController(text: '0');
  // ???????????? - ???
  TextEditingController dusuSuController = TextEditingController(text: '0');
  //?????? ????????????
  TextEditingController avgKgController = TextEditingController(text: '0');
  // ?????? ?????????
  TextEditingController saengsiKgController = TextEditingController();

  // ????????? ?????? - ???
  TextEditingController suckleController = TextEditingController(text: '0');
  // ????????? ?????? - ???
  TextEditingController suckleSuController = TextEditingController(text: '0');

  late TabController _tabController;
  late TabController _tabController2;

// ?????????
  late List<ComboListModel> jaepouList = [];
  ComboListModel? jaepouValue;

  // ??????????????????
  late List<ComboListModel> locationList = [];
  ComboListModel? locationValue;

  // ???????????? ??????
  late List<ComboListModel> jadonlocList = [];
  ComboListModel? jadonlocCdValue;

  // ?????????
  late List<ComboListModel> farrowingList = [];
  ComboListModel? farrowingValue;

  // ???????????? ?????????
  late List<ComboListModel> junipModonList = [];
  ComboListModel? junipModonValue;

  // ???????????? ?????????
  late List<ComboListModel> junchulModonList = [];
  ComboListModel? junchulModonValue;

  modonLastInfoModel? modonInfo;

  // ??????????????? ???
  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;
  late String _wkDt = "";
  late String _lastWk = "";
  late String _wkDtP = "";
  late String _statusCd = "";
  late String _statusCdP = "";
  late int _silsan = 0;
  late int _pou = 0;
  late int _ilryung = 0;
  late String _san = "";
  late String _statusName = "";

  // ????????? ???
  String _selectedFarrowingValue = "";

  // ??????
  String bigo = "";

  // ????????? = ??????????????? - ?????????
  late int elapsedDay = 0;

  // ?????? ??????
  DateTime today = DateTime.now();

  // ?????? ??????
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(wkDt),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ?????? ??????1
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

  // ?????? ??????2
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

    bigoController.text = pbigo;

    _tabController = TabController(length: 6, vsync: this);
    _tabController2 = TabController(length: 6, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        if (_tabController.index == 1) {
          //Trigger your request
        }
      }
    });


    // ?????? ?????? ??????(????????????, ????????????, ??????)
    setState(() {
      method();
    });
  }

  method() async {
    // lists = await getList();

    await getRecord();

    gbList = await Util().getFarmCodeList('', 'G');

    // ???????????? - ????????????
    lcList = await Util().getLocation('080005,080006,080007,080008,080009');
    edList = await Util().getEungdon();

    // ????????? ??????
    jaepouList = await Util().getCodeListFromString('???,?????????');

    // ??????
    locationList = await Util().getLocation('080001,080002,080003,080004');

    // ?????? ???????????? ??? ?????? ???????????? ??????
    var result = await Util().getLastModonInfo(pigNo, 'euwr', seq, sancha, wkDt);
    _statusCd = result['last']['statusCd'];

    _statusName = await getCodeSys(_statusCd);

    // ?????? ?????? ?????????
    // junipModonList = await Util().getCodeListFromUrl('/common/combogridPouModonList.json?inOut=IN');

    // ?????? ?????? ?????????
    // junchulModonList = await Util().getCodeListFromUrl('/common/combogridPouModonList.json?inOut=OUT');

    await getOneModonInfo();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (bigo.isNotEmpty) {
      bigoController.text = bigo;
    }

    return GestureDetector(
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
            title: const Text('????????????'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Weaning(pPigNo: 0,),
                  )
              ),
            ),
          ),
          body: ListView(
            children: [
              // ?????? ?????? ?????? ?????? ??????
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
                        Text('????????????', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(farmPigNo, style: const TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('????????????', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(igakNo, style: const TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                    TableRow(children: [
                      Column(children: const [
                        Text('????????????', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_statusName, style: const TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('????????????', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(sancha.toString(), style: const TextStyle(fontSize: 16.0))
                      ]),
                    ]),
                  ],
                ),
              ),
              // ?????? ??????
              const Padding(padding: EdgeInsets.only(bottom: 20)),

              Container(
                child: ExpansionTile(
                  // key: formKey,
                  initiallyExpanded: true,
                  title: const Text(
                    '???????????? ??????',
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
                            '????????????',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Signatra',
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 130.0),
                        ),
                        SizedBox(
                          key: const ValueKey('modon'),
                          width: 130,
                          height: 35,
                          child: Text(farmPigNo),
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
                              '?????????',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 60.0),
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
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text('????????? : $elapsedDay '),
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
                            child: const Text('??????',
                              style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                            ),
                            padding: const EdgeInsets.only(right: 10.0),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text('$_silsan '),
                          ),
                          Container(
                            child: const Text('????????????',
                              style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                            ),
                            padding: const EdgeInsets.only(right: 10.0),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text('$_pou'),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                            children: [
                              Container(
                                child: const Text('????????????',
                                  style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                                ),
                                padding: const EdgeInsets.only(right: 10.0),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: dusuController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    labelText: "???",
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  onTap: () {
                                    if(dusuController.text == '0') {
                                      dusuController.text = '';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: dusuSuController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      labelText: "???",
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
                                    if(dusuSuController.text == '0') {
                                      dusuSuController.text = '';
                                    }
                                  },
                                ),
                              ),

                              Container(
                                child: const Text('????????????',
                                  style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: avgKgController,
                                  keyboardType: TextInputType.number,
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
                                    ),
                                  ),
                                  onTap: () {
                                    if(avgKgController.text == '0.0') {
                                      avgKgController.text = '';
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
                                child: const Text('???????????????',
                                  style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                                ),
                                padding: const EdgeInsets.only(right: 47.0),
                              ),
                              SizedBox(
                                width: 80,
                                child: DropdownButton(
                                  isDense: true,
                                  isExpanded: true,
                                  hint: const Text('??????'),
                                  value: jaepouValue,
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (ComboListModel? newValue) async {
                                    setState(() {
                                      jaepouValue = newValue!;
                                    });

                                  },
                                  items: jaepouList.map((ComboListModel item) {
                                    return DropdownMenuItem<ComboListModel>(
                                      child: Text(item.cname),
                                      value: item,
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: suckleController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    labelText: "???",
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  onTap: () {
                                    if(suckleController.text == '0') {
                                      suckleController.text = '';
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  controller: suckleSuController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      labelText: "???",
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
                                    if(suckleSuController.text == '0') {
                                      suckleSuController.text = '';
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
                              child: const Text('????????????',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 125.0),
                            ),
                            SizedBox(
                              width: 130,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('??????'),
                                value: jadonlocCdValue,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) async {
                                  setState(() {
                                    jadonlocCdValue = newValue!;
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
                          ],
                        )
                    ),

                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                          children: [
                            Container(
                              child: const Text('??????',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 155.0),
                            ),
                            SizedBox(
                              width: 130,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('??????'),
                                value: locationValue,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) async {
                                  setState(() {
                                    locationValue = newValue!;
                                  });

                                },
                                items: locationList.map((ComboListModel item) {
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
                            labelText: "??????",
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
                        child: const Text(
                          '??????',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {

                          if(autoGb == "Z") {
                            _showDialog(context, "??????????????? ????????? ??? ????????????.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          if(int.parse(suckleController.text) + int.parse(suckleSuController.text) > 25 ) {
                            _showDialog(context, "?????????????????? 25????????? ?????? ????????????.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          setUpdate();
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
                  Tab(text: "????????????",),
                  Tab(text: "????????????",),
                  Tab(text: "????????????",),
                  Tab(text: "????????????",),
                  Tab(text: "????????????",),
                  Tab(text: "????????????",),
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

  // ?????? ?????? ?????? ?????? ??????
  getRecord() async {
    List<ChildBirthModel> data = List<ChildBirthModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    var url = _baseUrl +
        "/pigplan/pmd/inputmd/selectChildbirthOne.json" +
        "?pigNo=" + _pigNo.toString() +
        "&wkDt=" + _wkDt +
        "&wkGubun=" + _wkDt +
        "&sancha=" + _sancha.toString() +
        "&seq=" + _seq.toString() +
        "&sysEnv=";

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

    if (response.statusCode == 200) {

      if(response.body.isNotEmpty) {
        var data = jsonDecode(response.body);

/*
        // ??????
        chongSanController.text = data['chongSan'].toString();
        // ??????
        milaController.text = data['mila'].toString();
        // ??????
        sasanController.text = data['sasan'].toString();
        // ??????
        cmController.text = data['cm'].toString();
        // ??????
        ghController.text = data['gh'].toString();
        // ??????
        shController.text = data['sh'].toString();
        // ??????
        csController.text = data['cs'].toString();
        // ??????
        tjController.text = data['tj'].toString();
        // ??????
        gtController.text = data['gt'].toString();
        // ?????? - ???
        silsanFemaleController.text = data['silsanAm'].toString();
        // ?????? - ???
        silsanMaleController.text = data['silsanSu'].toString();
        // ?????? ????????????
        avgKgController.text = data['avgKg'].toString();
        // ?????? ?????????
        saengsiKgController.text = data['saengsiKg'].toString();

        // ?????? - ??????
        silsanController.text = (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)).toString();
        // ?????? - ????????????
        pouController.text =
            (int.parse(chongSanController.text) - int.parse(milaController.text) - int.parse(sasanController.text)
                - int.parse(cmController.text) - int.parse(ghController.text) - int.parse(shController.text)
                - int.parse(csController.text) - int.parse(tjController.text) - int.parse(gtController.text)
            ).toString();

        // ???????????? - ???
        junipDusuController.text = data['junipDusu'].toString();
        // ???????????? - ???
        junipDusuSuController.text = data['junipDusuSu'].toString();
        // ???????????? - ???
        junchulDusuController.text = data['junchulDusu'].toString();
        // ???????????? - ???
        junchulDusuSuController.text = data['junchulDusuSu'].toString();
        */

        if(data['wkDtP'] != ''|| data['wkDtP'] != null) {
          // ?????????
          elapsedDay = int.parse(today.difference(DateTime.parse(data['wkDtP'])).inDays.toString());
        }

        setState(() {});
        return data;
      }
    } else {
      throw Exception('error');
    }
  }

  // ???????????? ???
  Future<List<ComboListModel>> getSagoGbn() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);

    // url, parameter ??????
    var url = _baseUrl + "comboSysCodeCd.json?" + "pcode=05&lang=ko";
    var parameters = {
      'pcode': '05',
      'lang': 'ko',
    };

    final uri = Uri.http(
        '192.168.3.46:8080', '/common/comboSysCodeCd.json', parameters);
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

  // ???????????????
  Future<List<ComboListModel>> getSageList() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter ??????
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

  // ?????? ?????? ?????? ???????????? ??????
  Future<String> getLastModonInfo() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter ??????
    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = _baseUrl + "/pigplan/pmd/inputmd/selectMdLastAndJobInfo.json";
    var parameters = json.encode({
      'pigNo': pigNo.toString(),
      'seq': seq.toString(),
      'wkDt': wkDt,
      'sancha': sancha.toString(),
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

      // 0 ?????????

      _silsan = data['buman']['silsan'];
      _wkDt = data['buman']['wkDt'];
      _pou = data['dusu']['euinPouDusu'];
      _lastWk = data['last']['wkDt'];
      _wkDtP = data['last']['wkDtP'];
      _statusCd = data['last']['statusCd'];
      _statusCdP = data['buman']['statusCdP'];

      elapsedDay = int.parse(today.difference(DateTime.parse(_wkDtP)).inDays.toString());

      print(data['last']);
      print(data['buman']);
      print(data['dusu']);
      print(data['wkvw']);

      return data['wkvw']['statusCd'];
    } else {
      throw Exception('error');
    }
  }

  Future<String> getCodeSys(String code) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);
    // RequestBody??? ???????????? body??? ???????????? ??????
    String url = _baseUrl + "/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute??? ???????????? url?????? ??????
    url += "?type=sys"+"&code=" + code + "&lang=ko";

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

      for(int i=0; i<data.length; i++) {
          if(data[i]['code'] == code) {
            print(data[i]);
            return data[i]['cname'];
          }
      }
      return "";
    } else {
      throw Exception('error');
    }
  }

  // ????????? ??????
  setUpdate() async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = '/pigplan/pmd/inputmd/updateOrStoreWeaning.json';

    var msg = "";
    bool result = true;

    // ????????????
    var _avgKgValue = 0.0;
    // ????????? ?????? ??????
    var _jaepouValue = "";
    // ??????????????? ???,???
    int _suckleValue = 0;
    int _suckleSuValue = 0;

    var _jadonlocCd = "";
    var _locCd = "";

    if(avgKgController.text == null || avgKgController.text == "") {
      _avgKgValue = 0;
    } else {
      _avgKgValue = double.parse(avgKgController.text);
    }

    if(jaepouValue == null) {
      _jaepouValue = "";
    } else {
      _jaepouValue = jaepouValue!.code.toString();
    }

    if(suckleController.text == null || suckleController.text == "") {
      _suckleValue = 0;
    }

    if(suckleSuController.text == null || suckleSuController.text == "") {
      _suckleSuValue = 0;
    }

    if(locationValue == null) {
      _locCd = "";
    } else {
      _locCd = locationValue!.code.toString();
    }

    if(jadonlocCdValue == null) {
      _jadonlocCd = "";
    } else {
      _jadonlocCd = jadonlocCdValue!.code.toString();
    }

    final parameter = json.encode({
      "pigNo": _pigNo,
      "sancha": _sancha,
      "searchPigNo": "",
      "seq": _seq,
      "topPigNo": _pigNo,
      'wkDt': selectedDate.toLocal().toString().split(" ")[0],    // ?????????
      "bunmanGubunCd": _jaepouValue,                              // ???????????????
      "locCd": _locCd,                                            // ?????? ?????? ??????
      "avgKg": double.parse(_avgKgValue.toString()),              // ?????? ????????????
      "bigo": bigoController.text,                                // ??????
      "wkGubun": _wkGubun,
      "iuFlag": "U",
      "farmConfChongsanAuto": "N",
      "gyobaeCnt": 0,
      "fwNo": "",
      "popSearchOrder": "NEXT_DT",
      "popSearchStatusCode": "",
      "targetWkDt": _lastWk,
      "topIgakNo": "",
      "absa": 0,
      "absaSu": 0,
      "gita": 0,
      "gitaSu": 0,
      "chemi": 0,
      "chemiSu": 0,
      "wkGubun": _wkGubun,
      "pigNo": _pigNo,
      "topPigNo": _pigNo,
      "sancha": _sancha,
      "seq": _seq,
      "bmDt": _lastWk,                              // ?????? ?????????
      "dusu": dusuController.text,                  // ???????????? - ???
      "dusuSu": dusuSuController.text,              // ???????????? - ???
      "suckle": suckleController.text,              // ????????? - ???
      "suckleSu": suckleSuController.text,          // ????????? - ???
      "daeriYn": _jaepouValue,                      // ????????? ??????
      "ilryung": elapsedDay,
      "silsan": _silsan,
      "statusCd": _statusCd,
      "statusCdP": "",
      "euinPouDusu": "0",
      "euinPouDusuSu": "0",
      "popSearchOrder": "LAST_WK_DT",
      "popSearchStatusCode": "",
      "grpId": "",
      "grpNo": "",
      "grpNoP": "",
      "gyobaeCnt": "0",
      "jadonlocCd": _jadonlocCd,                      // ?????? ?????? ????????????
      "junchul": 0,
      "junchulSu": 0,
      "junip": 0,
      "junipSu": 0,
      "moveGrpSt": "new",                             // new ????????????, sel ????????????
      "huyak": 0,
      "huyakSu": 0,
      "sikja": 0,
      "sikjaSu": 0,
      "sulsa": 0,
      "sulsaSu": 0,
      "totalKg": "0.00",
      "yinPigNo": "",
      "youtPigNo": "",
    });

    print(parameter);
    print(_baseUrl + url);

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    print("header cookie??? :: " + session_id);

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameter);

    result = jsonDecode(response.body)['result'];
    msg = jsonDecode(response.body)['msg'];

    print(jsonDecode(response.body));

    if (response.statusCode == 200 && result == true ) {
      // ?????? ?????????, ?????????
      _showDialog(context, "?????? ???????????????.");
      return "sucess";
    } else if(result == false) {
      if(msg != null) {
        _showDialog(context, msg);
      }
    } else {
      throw Exception('error');
      return "false";
    }
  }

  // api url??? ?????? ?????? ????????? ??????
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
    // RequestBody??? ???????????? body??? ???????????? ??????
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

  Future<dynamic> getOneModonInfo() async {

    if(pigNo == 0 || pigNo == null) {
      return;
    }

    List<WeaningModel> list = List<WeaningModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    var url = _baseUrl + "pigplan/pmd/inputmd/selectOneByWeaning.json";
    var parameters = json.encode({
      'pigNo': pigNo.toString(),
      'dateFormat': 'yyyy-MM-dd',
      'seq': seq,
      'sancha': sancha,
      'wkDt': wkDt,
    });

    url += "?pigNo="+pigNo.toString()+"&dateFormat=yyyy-MM-dd&seq="+seq.toString()+"&sancha="+sancha.toString()+"&wkDt="+wkDt;

    print(url);
    print(parameters);

    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        }, body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      selectedDate = dateFormat.parse(wkDt);

      // ??? ??????
      dusuController.text = data['result']['dusu'].toString();
      dusuSuController.text = data['result']['dusuSu'].toString();
      avgKgController.text = data['result']['avgKg'].toString();

      if(data['daeriYn'] != null) {
        jaepouValue = jaepouList.singleWhere((element) => element.code == data['result']['daeriYn']);
      }

      suckleController.text = data['result']['suckle'].toString();
      suckleSuController.text = data['result']['suckleSu'].toString();

      if(data['result']['moveGrpSt'] != null) {
        jadonlocCdValue = lcList.singleWhere((element) => element.code == data['result']['moveGrpSt']);
      }

      if(data['result']['locCd'] != null) {
        locationValue = locationList.singleWhere((element) => element.code == data['result']['locCd']);
      }

      bigoController.text = data['result']['outReasonDetail'];
      _san = data['san'];

      setState(() {});

      return data;
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
              child: const Text('??????'),
              onPressed: () {
                // Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            )
          ],
        )
    );
  }

  // ?????????
  reset() {
    _silsan = 0;
    _pou = 0;

    dusuController.text = "0";
    dusuSuController.text = "0";
    avgKgController.text = "0";

    jaepouValue = null;
    suckleController.text = "0";
    suckleSuController.text = "0";

    jadonlocCdValue = null;
    locationValue = null;

    bigoController.text = "";
    setState(() { });
  }


}
