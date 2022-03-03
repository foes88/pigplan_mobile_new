import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_screenutil/screenutil_init.dart';

import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:pigplan_mobile/model/record/pregnancy_accident_record_model.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/record/pregnancy_accident_record_detail.dart';
import 'package:pigplan_mobile/widget/bottom_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:pigplan_mobile/api_call.dart';
import 'package:pigplan_mobile/model/record/mating_record_model.dart';
import 'package:http/http.dart' as http;

import '../model/record/mating_record_model.dart';
import 'matingrecord.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/services.dart';

class PregnancyAccidentRecord extends StatefulWidget {
  int pPigNo = 0;

  PregnancyAccidentRecord({Key? key,
    required this.pPigNo,
  }) : super(key: key);

  @override
  _PregnancyAccidentRecord createState() => _PregnancyAccidentRecord(pPigNo);
}

class _PregnancyAccidentRecord extends State<PregnancyAccidentRecord> {

  final formKey = GlobalKey<FormState>();

  final int pPigNo;

  _PregnancyAccidentRecord(this.pPigNo);

  TextEditingController searchController = TextEditingController(text: '');
  TextEditingController bigoController = TextEditingController(text: '');

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late List<ComboListModel> sagolists = List<ComboListModel>.empty(growable: true);
  late List<ComboListModel> locationlists = List<ComboListModel>.empty(growable: true);
  late List<ModonDropboxModel> modonLists = [];

  ComboListModel? selectedLocation;
  ComboListModel? selectedSago;

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;
  late List<PregnancyAccidentRecordModel> lists = [];
  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;
  late String _wkDt = "";

  String _selectedSago = "";
  String _selectedLocation = "";

  // 경과일 = 이전작업일 - 사고일
  late int elapsedDay = 0;

  // dropdownsearch
  bool dropdownSearchVisible = true;

  // 날짜 셋팅
  DateTime today = DateTime.now();
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
        elapsedDay = int.parse(DateTime.parse(selectedDate.toLocal().toString().split(" ")[0])
            .difference(DateTime.parse(_targetWkDt)).inDays.toString());
      });
    }
  }

  // 날짜 셋팅1
  DateTime selectedFromDate = DateTime(
      DateTime.now().year, DateTime.now().month - 2, DateTime.now().day);
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
    lists = await getList();
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
    lists = await getList();
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();

    // qr에서 넘어오면 dropdown안보이고, Text로 보여주고 값 select
    if (pPigNo != 0) {
      dropdownSearchVisible = false;
      getModonInfo();
    }

    setState(() {
      method();
    });
  }

  method() async {

    // lists = await getList();

    sagolists = await getSagoGbn();
    locationlists = await Util().getLocation('080001, 080002, 080003');

    setState(() {
      // List호출
      const SingleChildScrollView();

      // 임신사고원인 첫번째 선택
      selectedSago = sagolists[0];
    });
  }

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360,690),
      allowFontScaling: false,
      builder: () => GestureDetector(
        onTap: (){
        FocusScope.of(context).unfocus();
      },
      child:  MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        title: const Text('피그플랜'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const QuickPage()
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
                visible: dropdownSearchVisible,
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
                      onFind: (String? filter) => Util().getModonList(filter),
                      itemAsString: (ModonDropboxModel? m) =>
                          m!.farmPigNo.toString(),
                      onChanged: (ModonDropboxModel? value) => setState(() {
                        _searchValue = value!.farmPigNo.toString();
                        _pigNo = value.pigNo;
                        _seq = value.seq;
                        _wkGubun = value.wkGubun;
                        _targetWkDt = value.lastWkDt;
                        _sancha = value.sancha;

                        // 모돈 선택시, 경과일 계산
                        elapsedDay = int.parse(DateTime.parse(selectedDate.toLocal().toString().split(" ")[0])
                            .difference(DateTime.parse(_targetWkDt)).inDays.toString());

                        // 선택 모돈으로 list 조회
                        getList();

                      }),
                    ),
                  ),
                ),
              ),

              // qr에서 넘어온 경우
              Visibility(
                visible: !dropdownSearchVisible,
                child: SizedBox(
                  key: const ValueKey('modon'),
                  width: 130,
                  height: 35,
                  child:  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _searchValue.toString(),
                    ),
                  ),
                ),
              ),
            ]
            ),
          ),
          /*
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
              SizedBox(
                child: ButtonBar(children: [
                  ButtonTheme(
                      height: 25,
                      buttonColor: Colors.blueGrey,
                      child: RaisedButton(
                        onPressed: () => _selectFromDate(context),
                        child: Text("${selectedFromDate.toLocal()}"
                            .split(" ")[0]
                            .toString()),
                      )),
                  ButtonTheme(
                    height: 25,
                    buttonColor: Colors.blueGrey,
                    child: RaisedButton(
                        onPressed: () => _selectToDate(context),
                        child: Text("${selectedToDate.toLocal()}"
                            .split(" ")[0]
                            .toString())),
                  ),
                ]),
              ),
            ],
          ),
          */

          ExpansionTile(
            initiallyExpanded: true,
            title: const Text(
              '임신사고기록 등록',
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
                          padding: const EdgeInsets.only(right: 120.0),
                        ),
                        Visibility(
                            visible: dropdownSearchVisible,
                            child: SizedBox(
                            key: const ValueKey('modon'),
                            width: 100,
                            height: 35,
                            child:  DropdownSearch(
                              // mode: Mode.MENU,
                              showSearchBox: true,
                              scrollbarProps: ScrollbarProps(
                                isAlwaysShown: true,
                                thickness: 4,
                              ),
                              // isFilteredOnline: true,
                              onFind: (String? filter) => Util().getModonList(filter),
                              itemAsString: (ModonDropboxModel? m) => m!.farmPigNo.toString(),
                              onChanged: (ModonDropboxModel? value) => setState(() {
                                _searchValue = value!.farmPigNo.toString();
                                _pigNo = value.pigNo;
                                _seq = value.seq;
                                _wkGubun = value.wkGubun;
                                _targetWkDt = value.lastWkDt;
                                _sancha = value.sancha;
                                _wkDt = value.wkDt;

                                // 포유두수
                                //  _pou = value.po;
                                // 이유일령
                                //_ilryung = value.ilryung;

                                // 모돈 선택시, 경과일 계산
                                elapsedDay = int.parse(DateTime.parse(selectedDate.toLocal().toString().split(" ")[0])
                                    .difference(DateTime.parse(_targetWkDt)).inDays.toString());

                                // getSelectModonInfo();
                                // getLastModonInfo();
                                // Util().getModonList(value);
                              }),
                            ),
                          ),
                        ),

                        // qr에서 넘어온 경우
                        Visibility(
                          visible: !dropdownSearchVisible,
                          child: SizedBox(
                            key: const ValueKey('modon'),
                            width: 130,
                            height: 35,
                            child:  Align(
                              alignment: Alignment.center,
                              child: Text(
                                _searchValue.toString(),
                              ),
                            ),
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
                      child: const Text('사고일',
                        style: TextStyle(fontSize: 16,
                          fontFamily: 'Signatra',
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 35.0),
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
                        Padding(padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
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
                  onPressed: () async {

                    // 유효성 체크
                    // 모돈 선택여부
                    if(_searchValue.isEmpty) {
                      _showDialog(context,"모돈을 선택해 주세요.");
                      FocusScope.of(context).unfocus();
                      return;
                    }

                    //사고일 선택여부
                    if(selectedDate == null) {
                      _showDialog(context,"사고일을 선택해 주세요.");
                      FocusScope.of(context).unfocus();
                      return;
                    }

                    /*
                    //임신사고원인 선택여부
                    if(selectedSago == null) {
                      _showDialog(context,"임신사고원인을 선택해 주세요.");
                      FocusScope.of(context).unfocus();
                      return;
                    }

                    //진단장소 선택여부
                    if(selectedLocation == null) {
                      _showDialog(context,"진단장소를 선택해 주세요.");
                      FocusScope.of(context).unfocus();
                      return;
                    }
                    */

                    //비고 입력
                    /*
                    if(bigoController.text.isEmpty) {
                      _showDialog(context,"비고를 입력해 주세요.");
                      return;
                    }
                    */


                    // 이전 작업일 이전여부 체크


                    // 현재 상태가 임신돈 외는 신규 불가 wkGubun G만 가능
                    if(_wkGubun != 'G') {
                      _showDialog(context,"임신돈만 선택 가능합니다.");
                      FocusScope.of(context).unfocus();
                      return;
                    }

                    // 7일 이전
                    if(elapsedDay <= 7) {
                      _showDialog(context,"도태, 폐사를 제외하고는 교배 후 7일 이내에 재발이 일어나지 않습니다. (사고일자 확인) 저장 작업을 계속 진행 하시겠습니까?");
                      FocusScope.of(context).unfocus();
                      return;
                    }

                    // 저장
                    setInsert(bigoController.text, selectedSago, selectedLocation, selectedDate);
                  },
                  child: const Text('저장', style: TextStyle(fontSize: 20),),
                ),
              ),

            ],
          ),


              /*
              ExpansionTile(
                title: const Text(
                  '신규 등록',
                  textAlign: TextAlign.center,
                ),
                children: [
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(120),
                      1: FlexColumnWidth(),
                    },
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2),
                    children: [
                      TableRow(children: [
                        Column(children: const [
                          Text('모돈선택', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          DropdownSearch(
                            // mode: Mode.MENU,
                            showSearchBox: true,
                            onFind: (String? filter) => Util().getModonList(filter),
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
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('사고일', style: TextStyle(fontSize: 16.0))
                        ]),
                        Row(children: [
                          RaisedButton(
                            onPressed: () => _selectDate(context),
                            child: Text('${selectedDate.toLocal()}'.split(" ")[0]),
                          ),
                          Column(
                            children: [
                              Padding(padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                child: Text('경과일 : $elapsedDay '),
                              ),
                            ],
                          ),
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('임신사고원인', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          DropdownButton<ComboListModel>(
                            isDense: true,
                            value: selectedSago,
                            icon: const Icon(Icons.arrow_downward),
                            underline: DropdownButtonHideUnderline(child:Container()),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
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
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: const [
                          Text('진단장소', style: TextStyle(fontSize: 16.0))
                        ]),
                        Column(children: [
                          DropdownButton<ComboListModel>(
                            value: selectedLocation,
                            icon: const Icon(Icons.arrow_downward),
                            hint: const Text('선택'),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
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
                              // initialValue: '',
                              maxLength: 20,
                              controller: bigoController,
                              decoration: const InputDecoration(
                                // icon: Icon(Icons.favorite),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 0),
                                // labelText: '비고',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                helperText: '',
                              ),
                            ),
                          ]),
                        ],
                      ),
                      TableRow(children: [
                        Column(children: const [Text('')]),
                        Column(children: [
                          RaisedButton(
                            onPressed: () async {

                              // 유효성 체크
                              // 모돈 선택여부
                              if(_searchValue.isEmpty) {
                                _showDialog(context,"모돈을 선택해 주세요.!");
                                FocusScope.of(context).unfocus();
                                return;
                              }

                              //사고일 선택여부
                              if(selectedDate == null) {
                                _showDialog(context,"사고일을 선택해 주세요.");
                                FocusScope.of(context).unfocus();
                                return;
                              }

                              //임신사고원인 선택여부
                              if(selectedSago == null) {
                                _showDialog(context,"임신사고원인을 선택해 주세요.");
                                FocusScope.of(context).unfocus();
                                return;
                              }
                              
                              //진단장소 선택여부
                              if(selectedLocation == null) {
                                _showDialog(context,"진단장소를 선택해 주세요.");
                                FocusScope.of(context).unfocus();
                                return;
                              }

                              //비고 입력
                              /*
                              if(bigoController.text.isEmpty) {
                                _showDialog(context,"비고를 입력해 주세요.");
                                return;
                              }
                              */


                              // 이전 작업일 이전여부 체크


                              // 현재 상태가 임신돈 외는 신규 불가 wkGubun G만 가능
                              if(_wkGubun != 'G') {
                                _showDialog(context,"임신돈만 선택 가능합니다.");
                                FocusScope.of(context).unfocus();
                                return;
                              }

                              // 저장
                              setInsert(bigoController.text, selectedSago, selectedLocation, selectedDate);
                            },
                            child: const Text('저장', style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ]),
                      ]),
                    ],
                  ),
                ],
              ),
              */

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: true,
                  headingRowHeight: 30,
                  dataRowHeight: 30,
                  // 컬럼 헤더 색상
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blueGrey.shade50),
                  columns: const <DataColumn>[
                    DataColumn(label: Text('개체번호')),
                    DataColumn(label: Text('이각번호')),
                    DataColumn(label: Text('산차')),
                    DataColumn(label: Text('사고구분')),
                    DataColumn(label: Text('교배일')),
                    DataColumn(label: Text('사고일')),
                    DataColumn(label: Text('현재상태')),
                    DataColumn(label: Text('장소')),
                    DataColumn(label: Text('경과일')),
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
                                            PregnancyAccidentRecordRegit(
                                          farmNo: element.farmNo,
                                          pigNo: element.pigNo,
                                          farmPigNo: element.farmPigNo,
                                          sancha: element.sancha,
                                          igakNo: element.igakNo ?? "",
                                          sagoGubunNm: element.sagoGubunNm ?? "",
                                          seq: element.seq ?? 0,
                                          wkGubun: element.wkGubun ?? "",
                                          wkDt: element.wkDt ?? "",
                                          wkDtP: element.wkDtP ?? "",
                                          sagoGubunCd : element.sagoGubunCd ?? "",
                                          dieOutYn: element.dieOutYn ?? "",
                                          pbigo: element.bigo ?? "",
                                          passDt: element.passDt ?? "",
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
                                              PregnancyAccidentRecordRegit(
                                                farmNo: element.farmNo,
                                                pigNo: element.pigNo,
                                                farmPigNo: element.farmPigNo,
                                                sancha: element.sancha,
                                                igakNo: element.igakNo ?? "",
                                                sagoGubunNm: element.sagoGubunNm ?? "",
                                                seq: element.seq ?? 0,
                                                wkGubun: element.wkGubun ?? "",
                                                wkDt: element.wkDt ?? "",
                                                wkDtP: element.wkDtP ?? "",
                                                sagoGubunCd : element.sagoGubunCd ?? "",
                                                dieOutYn: element.dieOutYn ?? "",
                                                pbigo: element.bigo ?? "",
                                                passDt: element.passDt ?? "",
                                              ),
                                          settings: RouteSettings(
                                              arguments: element)));
                                }),
                                DataCell(Text((element.sancha).toString())),
                                DataCell(Text((element.sagoGubunNm).toString())),
                                DataCell(Text((element.wkDtP).toString())),
                                DataCell(Text((element.wkDt).toString())),
                                DataCell(Text(element.wkGubunNm.toString())),
                                DataCell(Text(element.locNm.toString())),
                                DataCell(Text(element.passDt.toString())),
                              ],
                            )),
                      ).toList(),
                ),
              ),
              // SfCartesianChart(),
              //environmentSection,
              //reportSection

          ],
        ),
       ),
      ),
    ),
    );
  }

  Widget monitoringSection = Container(
    // 컨테이너 내부 상하좌우에 32픽셀만큼의 패딩 삽입
    padding: const EdgeInsets.all(32),
    // 자식으로 로우를 추가
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // 로우에 위젯들(Expanded, Icon, Text)을 자식들로 추가
      children: <Widget>[
        const Text("농가 현황", textAlign: TextAlign.start),
        OutlinedButton(onPressed: () {}, child: Text('위험탐지  17건>')),
        OutlinedButton(onPressed: () {}, child: Text('질병탐지  13건>')),
        OutlinedButton(onPressed: () {}, child: Text('환경이상탐지  2건>')),
      ],
    ),
  );

  // 조회
  Future<List<PregnancyAccidentRecordModel>> getList() async {
    List<PregnancyAccidentRecordModel> datas =
        List<PregnancyAccidentRecordModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/pmd/inputmd/sagoList.json";

    var parameters = {
      // 'searchFarmNo': '105',
      // 'farmNo': '105',
      'searchFarmPigNo': _searchValue,
      'lang': 'ko',
      // 'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      // 'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
    };

    print(_baseUrl + url);
    print(parameters);

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    print("header cookie값 :: " + session_id);

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'cookie': session_id,
        },
        body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];

      for (int i = 0; i < data.length; i++) {
        datas.add(PregnancyAccidentRecordModel.fromJson(data[i]));
      }
      lists = datas;
      return datas;
    } else {
      throw Exception('error');
    }
  }

  void scrollUp() {
    const double start = 0;
    sccontroller.jumpTo(start);
  }

// 사고구분 값
  String _baseUrl = "http://192.168.3.46:8080/mobile/";

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

      for (int i = 0; i < data.length; i++) {
        list.add(ComboListModel.fromJson(data[i]));
      }
      setState(() { });
      return list;
    } else {
      throw Exception('error');
    }
  }

  // 임신사고기록 저장
  setInsert(String bigo, ComboListModel? selectedSago,
    ComboListModel? selectedLocation, DateTime selectedDate) async {
    //var url = 'mobile/updateOrStoreSago.json';
    const String _baseUrl = "http://192.168.3.46:8080";

    var url = 'pigplan/pmd/inputmd/updateOrStorePregnancy.json';

    var msg = "";
    bool result = true;

    if (selectedSago == null) {
      _selectedSago = "";
    } else {
      _selectedSago = selectedSago.code.toString();
    }

    if (selectedLocation == null) {
      _selectedLocation = "";
    } else {
      _selectedLocation = selectedLocation.code.toString();
    }

    //print(selectedSago!.code.toString());
    //print(selectedLocation!.code);

    final parameter = json.encode({
      'searchPigNo': _searchValue.toString(), // 모돈번호
      'pigNo': _pigNo, // 모돈번호
      'topPigNo': _pigNo,
      'seq': _seq,
      'wkGubun': _wkGubun,
      'targetWkDt': _targetWkDt,
      'sancha': _sancha,
      'sagoGubunCd': _selectedSago, //사고코드
      'locCd': _selectedLocation, // 장소코드
      'bigo': bigo,
      'wkDt': selectedDate.toLocal().toString().split(" ")[0],
      'iuFlag': 'I',
      'lang': 'ko',
      'dateFormat': 'yyyy-MM-dd',
    });

    print(parameter);
    print(_baseUrl + url);

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
      // 저장 성공시, 초기화
      reset();
      method();
      lists = await getList();
      _showDialog(context, "저장 되었습니다.");
      return "sucess";
    } else if (result == false) {
      _showDialog(context, msg);
    } else {
      throw Exception('error');
      return "false";
    }
  }

  //모돈 조회 (qr코드로 넘어왔을 경우 특정 모돈 정보만 조회)
  Future<List<ModonDropboxModel>> getModonInfo() async {
    late List<ModonDropboxModel> modonList =
    List<ModonDropboxModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    String url = _baseUrl + "/common/combogridModonList.json";

    url += "?searchPigNo=" +
        pPigNo.toString() +
        "&searchFarmPigNo=" +
        pPigNo.toString() +
        "&dieSearch=N&searchType=1&orderby=LAST_WK_DT&oneDataSearch=Y";

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: '');

    var statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(response.body);
      String value = "";

      print(data);

      _searchValue = data[0]['farmPigNo'].toString();
      _pigNo = data[0]['pigNo'];
      _seq = data[0]['seq'];
      _wkGubun = data[0]['wkGubun'];
      _targetWkDt = data[0]['lastWkDt'];
      _sancha = data[0]['sancha'];

      print(_searchValue);
      print(_pigNo);
      print(_seq);
      print(_wkGubun);
      print(_targetWkDt);
      print(_sancha);

      elapsedDay = int.parse(today
          .difference(DateTime.parse(_targetWkDt))
          .inDays
          .toString());

      for (int i = 0; i < data.length; i++) {
        modonList.add(ModonDropboxModel.fromJson(data[i]));
      }

      return modonList;
    } else {
      throw Exception('error');
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
