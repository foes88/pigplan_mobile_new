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
import 'package:pigplan_mobile/model/record/md__died__sell__model.dart';
import 'package:pigplan_mobile/model/record/pregnancy_accident_record_model.dart';
import 'package:pigplan_mobile/record/md_died_sell.dart';
import 'package:pigplan_mobile/record/modon_history_page/bunman_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/eyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/location_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/poyu_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/sancha_page.dart';
import 'package:pigplan_mobile/record/modon_history_page/vaccien_page.dart';

class MdDiedSellDetail extends StatefulWidget {
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

  const MdDiedSellDetail({
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
  }) : super(key: key);

  @override
  _MdDiedSellDetail createState() => _MdDiedSellDetail(
      farmNo, pigNo, farmPigNo, sancha, igakNo, sagoGubunNm, seq, wkPersonCd,
      locCd, wkgubun, pbigo, pouDusu
  );
}

class _MdDiedSellDetail extends State<MdDiedSellDetail> with TickerProviderStateMixin {
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

  _MdDiedSellDetail(
       this.farmNo, this.pigNo, this.farmPigNo, this.sancha, this.igakNo, this.sagoGubunNm, this.seq, this.wkPersonCd,
       this.locCd, this.wkgubun, this.pbigo, this.pouDusu,
      );

  late List<ComboListModel> sagogbn = List<ComboListModel>.empty(growable: true);
  late List<ComboListModel> sagolists = List<ComboListModel>.empty(growable: true);

  late List<PregnancyAccidentRecordModel> lists = [];

  // ?????? ??????????????? ??? ?????????
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

  // ???????????????
  late List<ComboListModel> MdDiedList = [];

  ComboListModel? selectedLocation;
  ComboListModel? selectedSago;

  late TabController _tabController;
  late TabController _tabController2;

  ComboListModel? diedValue;
  // ????????????
  ComboListModel? diedLocationValue;

  // ???????????????
  ComboListModel? selectedOutReasonCd;

  // ????????? ??????
  late List<ComboListModel> MdDiedGbnList = [];

  ComboListModel? MdDiedValue;

  TextEditingController bigoController = TextEditingController(text: '');
  TextEditingController kgController = TextEditingController();

  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
   late String _wkDtP = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;
  late String wkDt = "";
  late String _san = "";
  late String _statusCd = "";
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
        initialDate: selectedDate,
        firstDate: DateTime(2000),
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

    //_wkGubun = wkgubun;
    //bigo = pbigo;
    _tabController = TabController(length: 6, vsync: this);
    _tabController2 = TabController(length: 6, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        if(_tabController.index == 1) {
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
    // dropbox
    sagogbn = await getSagoGbn();
    gbList = await Util().getFarmCodeList('','G');
    lcList = await Util().getLocation('080001, 080002, 080003');
    edList = await Util().getEungdon();

    MdDiedList = await getCodeList('', '08');

    MdDiedGbnList = await getCodeJohapList('', '031');

    // ?????? ???????????? ??? ?????? ???????????? ??????
    var result = await Util().getLastModonInfo(pigNo, 'mdDiewr', seq, sancha, wkDt);
    _statusCd = result['last']['statusCd'];
    _san = result['last']['san'];
    _seq = result['last']['seq'];

    // ????????? ??????
    _statusName = await Util().getCodeSysValue(_statusCd);

    // ????????????
    // var modonInfo = await Util().getOneModonInfo(pigNo);
    // _seq = modonInfo['last']['seq'];

    _pigNo =pigNo;

    await getOneModonInfo();

    setState(() { });

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
            title: const Text('????????????'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MdDiedSell(),
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
                        Text(_statusName,
                            style: const TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: const [
                        Text('????????????', style: TextStyle(fontSize: 16.0))
                      ]),
                      Column(children: [
                        Text(_san, style: const TextStyle(fontSize: 16.0))
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
                  title: const Text('??????????????? ??????',
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
                                child: const Text('????????????',
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
                              child: const Text('????????????',
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
                            // Column(
                            //   children: [
                            //     Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            //       child: Text('???????????? : $pouDusu '),
                            //     ),
                            //   ],
                            // ),
                          ],
                        )
                    ),
                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                          children: [
                            Container(
                              child: const Text('???????????????',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 120.0),
                            ),
                            SizedBox(
                              key: const ValueKey('gyobaelc'),
                              width: 130,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('??????'),
                                value: MdDiedValue,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) {
                                  setState(() {
                                    MdDiedValue = newValue!;
                                  });
                                },
                                items: MdDiedList.map((ComboListModel item) {
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
                              child: const Text('???????????????',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 120.0),
                            ),
                            SizedBox(
                              width: 130,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('??????'),
                                value: selectedOutReasonCd,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) async {
                                  setState(() {
                                    selectedOutReasonCd = newValue!;
                                    // ?????? ?????????, ????????? ??????

                                    // farrowingList = await Util().getFarmFarrowing(diedLocationValue!.code.toString());
                                    // print(farrowingList.length);
                                  });

                                },
                                items: MdDiedGbnList.map((ComboListModel item) {
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
                              child: const Text(
                                '??????kg',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 180.0),
                            ),
                            Container(
                              child: SizedBox(
                                width: 90,
                                height: 40,
                                child: TextFormField(
                                  controller: kgController,
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
                                      )),
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 3.0),
                            ),
                          ]
                      ),
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
                        child: const Text('??????', style: TextStyle(fontSize: 20),),
                        onPressed: () async {

                          if(MdDiedValue == null) {
                            _showDialog(context,"?????????????????? ????????? ?????????.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

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

// ???????????? ???
  Future<List<ComboListModel>> getSagoGbn() async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);

    // url, parameter ??????
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

  Future<String> getLastModonInfo() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter ??????
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

      // pouDusu = data['dusu']['pouDusuSum'];
print('data');
      print(data);

      setState(() {});
      return data['wkvw']['statusCd'];
    } else {
      throw Exception('error');
    }
  }

  Future<List<ComboListModel>> getCodeList(String code, String pcode) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);

    // RequestBody??? ???????????? body??? ???????????? ??????
    String url = "http://192.168.3.46:8080/common/getCodes.json";
    var gbn = "080001,080002,080003,080004";
    var gbnValue = gbn.toString().split(",");

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute??? ???????????? url?????? ??????
    url += "?type=sys&code="+code+"&pcode="+pcode;

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
        for(int j=0; j<gbnValue.length; j++) {
          if(data[i]['code'] == gbnValue[j]) {
            cbList.add(ComboListModel.fromJson(data[i]));
          }
        }
      }

      return cbList;
    } else {
      throw Exception('error');
    }
  }

  getCodeValue(String code, String pcode) async {

    if(code.isEmpty) {
      return "";
    }
    print('sdfsdfds');
    print(code);
    print(pcode);

    // RequestBody??? ???????????? body??? ???????????? ??????
    String url = "http://192.168.3.46:8080/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute??? ???????????? url?????? ??????
    url += "?type=sys&code="+code+"&pcode="+pcode;

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

  getCodeJohapValue(String code) async {

    if(code.isEmpty) {
      return "";
    }

    String url = "http://192.168.3.46:8080/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute??? ???????????? url?????? ??????
    url += "?type=johap&code="+code;

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

  Future<List<ComboListModel>> getCodeJohapList(String code, String pcode) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);

    // RequestBody??? ???????????? body??? ???????????? ??????
    String url = "http://192.168.3.46:8080/common/comboPeasaReason.json";

    var parameters = json.encode({
      'lang': 'ko',
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

      for(int i=0; i<data.length; i++) {
        cbList.add(ComboListModel.fromJson(data[i]));
      }

      return cbList;
    } else {
      throw Exception('error');
    }
  }

  //?????? ????????? ??????
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

  // ????????? ??????
  setUpdate(String bigo, DateTime selectedDate) async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = 'pigplan/pmd/inputmd/updateOrStoreDiedSell.json';

    var msg = "";
    bool result = true;

    var etcTradeYn = "N";
    var _selectedOutReasonCd = "";

    if(selectedOutReasonCd == null) {
      _selectedOutReasonCd = "";
    } else {
      _selectedOutReasonCd = selectedOutReasonCd!.code.toString();
    }

    if(MdDiedValue!.code.toString() == "080004") {
      etcTradeYn = "Y";
    }

    final parameter = json.encode({
      'autoGb': "",
      'daeriYn': "",
      'etcTradeYn': etcTradeYn,     // ????????? ???????????? Y ?????????
      'iuFlag': "U",
      'outGubunCd': MdDiedValue!.code.toString(),
      'outReasonCd': _selectedOutReasonCd,
      'outKg': kgController.text,
      'outReasonDetail': bigo,
      'pEtcTradeYn': "",
      'pigNo': _pigNo,
      'topPigNo': _pigNo,
      'popSearchOrder': "NEXT_DT",
      'popSearchStatusCode': "",
      'saleComCd': "",
      'salePrice': 0,
      'sancha': 0,
      'seq': 0,
      'targetWkDt': "",
      'topIgakNo': "",
      'wkDt': selectedDate.toLocal().toString().split(" ")[0],
      'wkDtP': _wkDtP,
      'wkGubun': _wkGubun,
      'youtPigNo': "",
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
        body: parameter
    );

    print(response.body);

    result = jsonDecode(response.body)['result'];
    msg = jsonDecode(response.body)['msg'];

    if (response.statusCode == 200 && result == true ) {
      // ?????? ?????????, ?????????
      // reset();
      _showDialog(context, "?????????????????????.");
      return "sucess";
    } else if(result == false) {
      _showDialog(context, msg);
    } else {
      throw Exception('error');
      return "false";
    }
  }

  Future<dynamic> getOneModonInfo() async {

    if(pigNo == 0 || pigNo == null) {
      return;
    }

    List<MdDiedSellModel> list = List<MdDiedSellModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    var url = _baseUrl + "pigplan/pmd/inputmd/selectOneByDiedSell.json";
    var parameters = json.encode({
      'pigNo': pigNo.toString(),
      'dateFormat': 'yyyy-MM-dd',
      'lang': 'ko',
    });

    url += "?pigNo="+pigNo.toString()+"&dateFormat=yyyy-MM-dd&lang=ko";

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

      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      selectedDate = dateFormat.parse(data['wkDt']);

      // ??? ??????
      if(data['outGubunCd'] != null) {
        MdDiedValue = MdDiedList.singleWhere((element) => element.code == data['outGubunCd']);
      }
      if(data['outReasonCd'] != null) {
        selectedOutReasonCd = MdDiedGbnList.singleWhere((element) => element.code == data['outReasonCd']);
      }

      kgController.text = data['outKg'];
      bigoController.text = data['outReasonDetail'];

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


    setState(() { });
  }
}
