import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:pigplan_mobile/model/record/eungdon_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:pigplan_mobile/model/modon_history/location_record_model.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/widget/bottom_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:pigplan_mobile/nav.dart';
import 'package:pigplan_mobile/api_call.dart';
import 'package:pigplan_mobile/model/record/mating_record_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dashboard.dart';
import 'mating_record_detail.dart';

class MatingRecord extends StatefulWidget {
  int pPigNo = 0;

  MatingRecord({
    Key? key,
    required this.pPigNo,
  }) : super(key: key);

  @override
  _MatingRecord createState() => _MatingRecord(pPigNo);
}

class _MatingRecord extends State<MatingRecord> {
  final formKey = GlobalKey<FormState>();

  final int pPigNo;

  _MatingRecord(this.pPigNo);

  TextEditingController controller = TextEditingController();
  TextEditingController bigoController = TextEditingController();

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;

  late List<MatingRecordModel> lists = [];
  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];
  late List<ComboListModel> edGbnList = [];

  ComboListModel? selectedMdValue;
  ComboListModel? selectedGbValue;
  ComboListModel? selectedGblValue;

  EungdonModel? selectedEd1Value;
  EungdonModel? selectedEd2Value;
  EungdonModel? selectedEd3Value;

  ComboListModel? selectedCbEd1Value;

  // selectedCbEd1Value. = 995001

  ComboListModel? selectedCbEd2Value;
  ComboListModel? selectedCbEd3Value;

  // 웅돈 1,2,3회 입력 폼
  TextEditingController ed1Controller = TextEditingController();
  TextEditingController ed2Controller = TextEditingController();
  TextEditingController ed3Controller = TextEditingController();

  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;

  String _selectedGbValue = "";
  String _selectedLocation = "";
  String _selectedCbEd1Value = "";
  String _selectedCbEd2Value = "";
  String _selectedCbEd3Value = "";

  String _ufarmPigNo1 = "";
  String _ufarmPigNo2 = "";
  String _ufarmPigNo3 = "";
  String _ungdonPigNo1 = "";
  String _ungdonPigNo2 = "";
  String _ungdonPigNo3 = "";

  static const historyLength = 3;

  // 경과일 = 이전작업일 - 사고일
  late int elapsedDay = 0;

  // 분만예정일 = 교배일 + 임신기간
  late String childBirthDate = "";

  // dropdownsearch
  bool dropdownSearchVisible = true;

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

        // 분만예정일 = 교배일 + 임신기간 115로 일단...
        childBirthDate =
            selectedDate.add(const Duration(days: 115)).toLocal().toString();
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

    // qr에서 넘어오면 dropdown안보이고, Text로 보여주고 값 select
    if (pPigNo != 0) {
      dropdownSearchVisible = false;
      //qr에서 넘어온경우 셋팅해야함

      getModonInfo();
    }

    setState(() {
      method();
    });
  }

  method() async {

    // lists = await getList();

    gbList = await Util().getFarmCodeList('', 'G');
    lcList = await Util().getLocation('080001, 080002, 080003');
    edList = await Util().getEungdon();
    // 교배방법
    edGbnList = await getEdGbnList();

    setState(() {
      selectedCbEd1Value = edGbnList[1];
      const SingleChildScrollView();
    });
  }

  /*
  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('피그플랜을 종료하시겠습니까?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('아니오'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('예'),
              ),
            ],
          ),
        )) ??
        false;
  }
  */

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(360,690),
      allowFontScaling: false,
      builder: () => GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: MaterialApp(
            title: '교배기록',
            home: Scaffold(
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

                            // 모돈 선택시, 경과일 계산
                            elapsedDay = int.parse(today.difference(DateTime.parse(_targetWkDt)).inDays.toString());

                            // 예정일 계산
                            childBirthDate = selectedDate.add(const Duration(days: 115)).toLocal().toString();

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
                            )),
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
                  // key: formKey,
                  initiallyExpanded: true,
                  title: const Text(
                    '교배기록 등록',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  children: [
                    SizedBox(
                      width: 350,
                      child: ButtonBar(children: [
                        /*
                        Container(
                          child: const Text(
                            '모돈선택',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Signatra',
                            ),
                          ),
                          padding: const EdgeInsets.only(right: 0),
                        ),
                        */
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text(
                                '예정일 : ${childBirthDate.split(" ")[0]}',
                              ),
                            ),
                          ],
                        ),

                        // qr에서 넘어온 경우
                        /*
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
                        */

                      ]
                      ),
                    ),
                    SizedBox(
                        width: 350,
                        child: ButtonBar(children: [
                          Container(
                            child: const Text(
                              '교배자',
                              style: TextStyle(
                                fontSize: 16,
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
                        ])),
                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                          children: [
                            Container(
                              child: const Text(
                                '교배장소',
                                style: TextStyle(
                                  fontSize: 16,
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
                                value: selectedGblValue,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) {
                                  setState(() {
                                    selectedGblValue = newValue!;
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
                        )),
                    SizedBox(
                        width: 320,
                        child: Row(
                          children: [
                            Container(
                              child: const Text(
                                '교배일',
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
                                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                  child: Text('경과일 : $elapsedDay '),
                                ),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      width: 350,
                      child: ButtonBar(
                        buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        children: [
                          Container(
                            child: const Text(
                              '웅돈1회',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 15.0),
                          ),
                          Container(
                            child: SizedBox(
                              width: 100,
                              height: 40,
                              child: TextFormField(
                                controller: ed1Controller,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                    labelText: "",
                                    // 글자가 sizebox보다 넘어갈경우 맞추기
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
                          Container(
                            child: SizedBox(
                              width: 90,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('선택'),
                                value: selectedEd1Value,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (EungdonModel? newValue) {
                                  setState(() {
                                    selectedEd1Value = newValue!;
                                    _ufarmPigNo1 =
                                        selectedEd1Value!.farmPigNo.toString();
                                    _ungdonPigNo1 =
                                        selectedEd1Value!.pigNo.toString();
                                    // textbox 초기화
                                    ed1Controller.text = "";
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
                            padding: const EdgeInsets.only(right: 5.0),
                          ),
                          SizedBox(
                            width: 60,
                            child: DropdownButton<ComboListModel>(
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('선택'),
                              value: selectedCbEd1Value,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (ComboListModel? newValue) {
                                setState(() {
                                  selectedCbEd1Value = newValue!;

                                  print(newValue.code);

                                  // textbox 초기화
                                  ed1Controller.text = "";
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
                      ),
                    ),
                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                          buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          children: [
                            Container(
                              child: const Text(
                                '웅돈2회',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 15.0),
                            ),
                            Container(
                              child: SizedBox(
                                width: 100,
                                height: 40,
                                child: TextFormField(
                                  controller: ed2Controller,
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
                                    _ufarmPigNo2 =
                                        selectedEd2Value!.farmPigNo.toString();
                                    _ungdonPigNo2 =
                                        selectedEd2Value!.pigNo.toString();
                                    // textbox 초기화
                                    ed2Controller.text = "";
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
                              width: 60,
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
                        )),
                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                          buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          children: [
                            Container(
                              child: const Text(
                                '웅돈3회',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 15.0),
                            ),
                            Container(
                              child: SizedBox(
                                width: 100,
                                height: 40,
                                child: TextFormField(
                                  controller: ed3Controller,
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
                                    _ufarmPigNo3 =
                                        selectedEd3Value!.farmPigNo.toString();
                                    _ungdonPigNo3 =
                                        selectedEd3Value!.pigNo.toString();
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
                              width: 60,
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
                        )),
                    SizedBox(
                      width: 300,
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
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: RaisedButton(
                        child: const Text(
                          '저장',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          if (_searchValue.isEmpty) {
                            _showDialog(context, "모돈을 선택해 주세요.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          DropdownSearch == null;

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

                          if (selectedEd1Value == null && ed1Controller.text == "") {
                            _showDialog(context, "웅돈1회를 입력, 선택 해주세요.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          if (selectedEd1Value == null &&
                              selectedEd2Value != null &&
                              selectedEd3Value != null) {
                            _showDialog(context, "교배웅돈 및 방법은 순차적으로 입력 되어야 합니다.");
                            FocusScope.of(context).unfocus();
                            return;
                          }
                          if (selectedEd1Value == null &&
                              selectedEd2Value == null &&
                              selectedEd3Value != null) {
                            _showDialog(context, "교배웅돈 및 방법은 순차적으로 입력 되어야 합니다.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          if (selectedCbEd1Value == null &&
                              selectedCbEd2Value != null &&
                              selectedCbEd3Value != null) {
                            _showDialog(context, "교배웅돈 및 방법은 순차적으로 입력 되어야 합니다.");
                            FocusScope.of(context).unfocus();
                            return;
                          }
                          if (selectedCbEd1Value == null &&
                              selectedCbEd2Value == null &&
                              selectedCbEd3Value != null) {
                            _showDialog(context, "교배웅돈 및 방법은 순차적으로 입력 되어야 합니다.");
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

                          setInsert(bigoController.text, selectedGbValue,
                              selectedGblValue, selectedDate);
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
                      DataColumn(
                          label: Text(
                            '모돈번호',
                          )),
                      DataColumn(label: Text('이각번호')),
                      DataColumn(label: Text('산차')),
                      DataColumn(label: Text('교배일')),
                      DataColumn(label: Text('교배방법')),
                      DataColumn(label: Text('웅돈1회')),
                      DataColumn(label: Text('웅돈2회')),
                      DataColumn(label: Text('웅돈3회')),
                    ],
                    rows: lists
                        .map(
                      ((element) => DataRow(
                        cells: [
                          DataCell(Text(element.farmPigNo), onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MatingRecordDetail(
                                    farmNo: element.farmNo,
                                    pigNo: element.pigNo,
                                    farmPigNo: element.farmPigNo,
                                    sancha: element.sancha ?? "",
                                    igakNo: element.igakNo ?? "",
                                    sagoGubunNm: element.sagoGubunNm ?? "",
                                    seq: element.seq,
                                    wkgubun: element.wkGubun,
                                    wkPersonCd: element.wkPersonCd,
                                    wkDt: element.wkDt,
                                    method1: element.method1,
                                    method2: element.method2,
                                    method3: element.method3,
                                    ufarmPigNo1: element.ufarmPigNo1,
                                    ufarmPigNo2: element.ufarmPigNo2,
                                    ufarmPigNo3: element.ufarmPigNo3,
                                    ungdonPigNo1: element.ungdonPigNo1,
                                    ungdonPigNo2: element.ungdonPigNo2,
                                    ungdonPigNo3: element.ungdonPigNo3,
                                    locCd: element.locCd,
                                    PselectedEd1Value: selectedEd1Value,
                                    PselectedEd2Value: selectedEd2Value,
                                    PselectedEd3Value: selectedEd3Value,
                                    PselectedCbEd1Value: selectedCbEd1Value,
                                    PselectedCbEd2Value: selectedCbEd2Value,
                                    PselectedCbEd3Value: selectedCbEd3Value,
                                    pbigo: element.bigo,
                                    // 모돈번호, 교배자, 교배장소, 교배일, 웅돈 1,2,3회 , 비고
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
                                        builder: (context) => MatingRecordDetail(
                                            farmNo: element.farmNo,
                                            pigNo: element.pigNo,
                                            farmPigNo: element.farmPigNo,
                                            sancha: element.sancha ?? "",
                                            igakNo: element.igakNo ?? "",
                                            sagoGubunNm:
                                            element.sagoGubunNm ?? "",
                                            seq: element.seq,
                                            wkgubun: element.wkGubun,
                                            wkPersonCd: element.wkPersonCd,
                                            wkDt: element.wkDt,
                                            method1: element.method1,
                                            method2: element.method2,
                                            method3: element.method3,
                                            ufarmPigNo1: element.ufarmPigNo1,
                                            ufarmPigNo2: element.ufarmPigNo2,
                                            ufarmPigNo3: element.ufarmPigNo3,
                                            ungdonPigNo1: element.ungdonPigNo1,
                                            ungdonPigNo2: element.ungdonPigNo2,
                                            ungdonPigNo3: element.ungdonPigNo3,
                                            locCd: element.locCd,
                                            PselectedEd1Value: selectedEd1Value,
                                            PselectedEd2Value: selectedEd2Value,
                                            PselectedEd3Value: selectedEd3Value,
                                            PselectedCbEd1Value:
                                            selectedCbEd1Value,
                                            PselectedCbEd2Value:
                                            selectedCbEd2Value,
                                            PselectedCbEd3Value:
                                            selectedCbEd3Value,
                                            pbigo: element.bigo),
                                        settings:
                                        RouteSettings(arguments: element)));
                              }),
                          DataCell(Text((element.sancha).toString())),
                          DataCell(Text(element.wkDt)),
                          DataCell(
                            FutureBuilder(
                              future: getEdGbMethodValue(element.method1.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString());
                                } else {
                                  return const Text('');
                                }
                              },
                            ),
                          ),
                          DataCell(Text(element.ufarmPigNo1)),
                          DataCell(Text(element.ufarmPigNo2)),
                          DataCell(Text(element.ufarmPigNo3)),
                        ],
                      )),
                    )
                        .toList(),
                  ),
                ),
              ]

                /*
        children: <Widget>[
          Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title : TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '검색', border: InputBorder.none
                    ),
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        _searchResult = value;
                      });

                      // 조회
                      method();
                    },
                  )
                )

              ),
              */ /*
              Container(
                // 컨테이너 내부 상하좌우에 32픽셀만큼의 패딩 삽입
                padding: const EdgeInsets.all(32),
                // 자식으로 로우를 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // 로우에 위젯들(Expanded, Icon, Text)을 자식들로 추가
                  children: <Widget>[
                    const Text("교배기록", textAlign: TextAlign.start),
                    OutlinedButton(onPressed: () {}, child: const Text('대시보드')),
                  ],
                ),
              ),
              */ /*
              TextButton(
                  style: TextButton.styleFrom(primary: Colors.black26),
                  onPressed: () async {
                    var url = 'mobile/selectGyobaeList.json';
                    lists = await getList();

                    print("DATA RESULT");
                    print(lists[0]);

                    const SingleChildScrollView();
                  },
                  child: const Text('조회')
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: DataTable(
                  sortAscending: true,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('개체번호',)),
                    DataColumn(label: Text('품종')),
                    DataColumn(label: Text('산차')),
                  ],
                  rows: lists
                      .map(
                        ((element) => DataRow(
                              cells: [
                                DataCell(Text(element.farmPigNo)),
                                DataCell(Text((element.pumjongNm).toString())),
                                DataCell(Text((element.sancha).toString())),
                              ],
                            )),
                      )
                      .toList(),

                ),
              ),
              // SfCartesianChart(),
              //environmentSection,
              //reportSection
            ],
          )
        ],
        */

              ),
            )
        ),
      )


      //width: -poikuy][p ScreenUtil.screenWidth,
     // height: ScreenUtil.screenHeight,

    );




  }

  // 조회
  String _baseUrl = "http://192.168.3.46:8080/";

  Future<List<MatingRecordModel>> getList() async {
    List<MatingRecordModel> datas =
    List<MatingRecordModel>.empty(growable: true);

    var url = _baseUrl + "pigplan/pmd/inputmd/selectGyobaeList.json";

    var parameters = {
      'searchFarmPigNo': _searchValue,
      'searchModonItem': "md",
      'searchSort': "WK_DT ASC,TG.LOG_UPT_DT ASC",
      'searchDtBacisItem': 'updt',
      // 'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      // 'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
    };

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    final response = await http.post(Uri.parse(url),
        headers: {
          'cookie': session_id,
        },
        body: parameters
    );

    print(parameters);
    print("교배기록 조회 :: " + response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];

      for (int i = 0; i < data.length; i++) {
        datas.add(MatingRecordModel.fromJson(data[i]));
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

    url += "?searchPigNo=" +
        pigNo +
        "&searchFarmPigNo=" +
        pigNo +
        "&dieSearch=N&searchType=1&orderby=LAST_WK_DT&";

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameters);

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

  //모돈 조회 (qr코드로 넘어왔을 경우 특정 모돈 정보만 조회)
  Future<List<ModonDropboxModel>> getModonInfo() async {
    late List<ModonDropboxModel> modonList =
        List<ModonDropboxModel>.empty(growable: true);

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

      // print(data);

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

      // 분만예정일 = 교배일 + 임신기간 115로 일단...
      childBirthDate =
          selectedDate.add(const Duration(days: 115)).toLocal().toString();

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

  // 웅돈 교배방법 값 return
  getEdGbMethodValue(code) async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);

    // url, parameter 셋팅
    var url = _baseUrl + "comboSysCodeCd.json?pcode=995";
    var parameters = {
      'pcode': '995',
      'lang': 'ko',
    };

    final uri = Uri.http('192.168.3.46:8080', '/common/comboSysCodeCd.json', parameters);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
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


  setInsert(String bigo, ComboListModel? selectedSago,
      ComboListModel? selectedLocation, DateTime selectedDate) async {

    var url = '/pigplan/pmd/inputmd/updateOrStoreMating.json';
    var msg = "";
    bool result = true;

    if (selectedGbValue == null) {
      _selectedGbValue = "";
    } else {
      _selectedGbValue = selectedGbValue!.code.toString();
    }

    if (selectedLocation == null) {
      _selectedLocation = "";
    } else {
      _selectedLocation = selectedLocation.code.toString();
    }

    if (selectedCbEd1Value == null) {
      _selectedCbEd1Value = "";
    } else {
      if (selectedCbEd1Value!.code.toString() == '995001') {
        _selectedCbEd1Value = "A";
      } else {
        _selectedCbEd1Value = "N";
      }
    }
    if (selectedCbEd2Value == null) {
      _selectedCbEd2Value = "";
    } else {
      if (selectedCbEd2Value!.code.toString() == '995001') {
        _selectedCbEd2Value = "A";
      } else {
        _selectedCbEd2Value = "N";
      }
    }
    if (selectedCbEd3Value == null) {
      _selectedCbEd3Value = "";
    } else {
      if (selectedCbEd3Value!.code.toString() == '995001') {
        _selectedCbEd3Value = "A";
      } else {
        _selectedCbEd3Value = "N";
      }
    }

    // 웅돈 1,2,3회 값 - 입력값이 있으면 코드값은 안넘어간다
    if (ed1Controller.text != '') {
      _ungdonPigNo1 = '';
      _ufarmPigNo1 = ed1Controller.text;
    }
    if (ed2Controller.text != '') {
      _ungdonPigNo2 = '';
      _ufarmPigNo2 = ed2Controller.text;
    }
    if (ed3Controller.text != '') {
      _ungdonPigNo3 = '';
      _ufarmPigNo3 = ed3Controller.text;
    }

    final parameter = json.encode({
      'pigNo': _pigNo, // 모돈번호
      'topPigNo': _pigNo,
      // 'wkPersonCd': selectedSago!.code.toString(), // 사고코드
      'wkPersonCd': _selectedGbValue, // 교배자
      'locCd': _selectedLocation, // 교배장소
      'seq': _seq,
      'sancha': _sancha,
      'wkGubun': _wkGubun,
      'method1': _selectedCbEd1Value,
      'method2': _selectedCbEd2Value, // selectedCbEd2Value.code.toString(),
      'method3': _selectedCbEd3Value, // selectedCbEd3Value.code.toString(),
      'ungdonPigNo1': _ungdonPigNo1,
      'ungdonPigNo2': _ungdonPigNo2,
      'ungdonPigNo3': _ungdonPigNo3,
      'ufarmPigNo1': _ufarmPigNo1,
      'ufarmPigNo2': _ufarmPigNo2,
      'ufarmPigNo3': _ufarmPigNo3,
      'bigo': bigo,
      'wkDt': selectedDate.toLocal().toString().split(" ")[0], // 2021-11-03
      'iuFlag': 'I', // I, U
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
        body: parameter
    );

    print(response.body);

    result = jsonDecode(response.body)['result'];
    msg = jsonDecode(response.body)['msg'];

    if (response.statusCode == 200 && result == true) {
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

  // test
  getTest() async {
    List<MatingRecordModel> datas =
        List<MatingRecordModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/pmd/inputmd/MdMatingWr.do";

    var parameters = {
      '': '',
    };

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          'cookie': session_id,
        },
        body: parameters);

    print("교배기록 ---*--- :: " + response.body);

    /*
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];
      print(response.body);
      for (int i = 0; i < data.length; i++) {
        datas.add(MatingRecordModel.fromJson(data[i]));
      }
      return datas;
    } else {
      throw Exception('error');
    }*/
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
  reset() {
    selectedGbValue = null;
    selectedGblValue = null;

    selectedEd1Value = null;
    selectedCbEd1Value = null;
    ed1Controller.text = "";
    _ufarmPigNo1 = "";
    _ungdonPigNo1 = "";

    selectedEd2Value = null;
    selectedCbEd2Value = null;
    ed2Controller.text = "";
    _ufarmPigNo2 = "";
    _ungdonPigNo2 = "";

    selectedEd3Value = null;
    selectedCbEd3Value = null;
    ed3Controller.text = "";
    _ufarmPigNo3 = "";
    _ungdonPigNo3 = "";

    bigoController.text = "";

    setState(() {});
  }

/*
  List<String> filterSearchTerms({
    required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      // Reversed because we want the last added items to appear first in the UI
      return _searchResult.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchResult.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchResult.contains(term)) {
      // This method will be implemented soon
      putSearchTermFirst(term);
      return;
    }
    _searchResult.add(term);
    if (_searchResult.length > historyLength) {
      _searchResult.removeRange(0, _searchResult.length - historyLength);
    }
    // Changes in _searchHistory mean that we have to update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  void deleteSearchTerm(String term) {
    _searchResult.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: "");
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }
*/
/*
  Widget builDataTable() {

    return DataTable(
        columns: getColumns(columns)
        , rows: rows)
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
      label: Text(column)
      ))
  .toList();
*/

}
