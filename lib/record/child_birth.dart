import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/model/record/child_birth_model.dart';
import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:pigplan_mobile/model/record/eungdon_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:flutter/material.dart';
import 'package:pigplan_mobile/model/record/mating_record_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:pigplan_mobile/model/record/poyou_jadon_died_model.dart';
import 'package:pigplan_mobile/model/record/poyu_modon_model.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/record/poyou_jadon_died_detail.dart';
import 'package:pigplan_mobile/record/weaning_record.dart';

import '../dashboard.dart';
import 'child_birth_detail.dart';
import 'mating_record_detail.dart';

class ChildBirth extends StatefulWidget {

  int pPigNo = 0;

  ChildBirth({
    Key? key,
    required this.pPigNo,
  }) : super(key: key);

  @override
  _ChildBirth createState() => _ChildBirth(pPigNo);
}

class _ChildBirth extends State<ChildBirth> with TickerProviderStateMixin {

  final formKey = GlobalKey<FormState>();

  final int pPigNo;

  _ChildBirth(this.pPigNo);

  TextEditingController controller = TextEditingController();
  TextEditingController bigoController = TextEditingController();

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
  TextEditingController silsanController = TextEditingController(text: '0');
  TextEditingController pouController = TextEditingController(text: '0');
  // 실산 - 암 / 수
  TextEditingController silsanFemaleController = TextEditingController(text: '0');
  TextEditingController silsanMaleController = TextEditingController(text: '0');
  // 자돈 평균체중
  TextEditingController avgKgController = TextEditingController(text: '0');
  // 자돈 총체중
  TextEditingController saengsiKgController = TextEditingController(text: '0');
  // 양자전입 - 암 / 수
  TextEditingController junipDusuController = TextEditingController();
  TextEditingController junipDusuSuController = TextEditingController();
  // 양자전출 - 암 / 수
  TextEditingController junchulDusuController = TextEditingController();
  TextEditingController junchulDusuSuController = TextEditingController();

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;

  late List<ChildBirthModel> lists = [];

  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];

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

  ModonDropboxModel? selectedValue = null;

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

  // 경과일 = 이전작업일 - 사고일
  late int elapsedDay = 0;

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

    // qr에서 넘어오면 dropdown안보이고, Text로 보여주고 값 select
    if(pPigNo != 0 ) {
      dropdownSearchVisible = false;
      getModonInfo();
    }

    setState(() {
      method();
    });
  }

  method() async {

    // lists = await getList();
    gbList = await Util().getFarmCodeList('','G');
    lcList = await Util().getLocation('080004');
    edList = await Util().getEungdon();

    // 분만구분
    bunmanGubunList = await Util().getCodeListFromUrl('/common/comboBunmanGubun.json');

    // 분만장소
    bunmanLocationList = await Util().getLocation('080004');

    // 분만틀

    // 전입 모돈 리스트
    junipModonList = await Util().getCodeListFromUrl('/common/combogridPouModonList.json?inOut=IN');

    // 전출 모돈 리스트
    junchulModonList = await Util().getCodeListFromUrl('/common/combogridPouModonList.json?inOut=OUT');

    setState(() {
      const SingleChildScrollView();

      // 분만구분값 0번째 선택
      bunmanGubunValue = bunmanGubunList[0];
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
        child: Scaffold(
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
                  // key: formKey,
                  initiallyExpanded: true,
                  title: const Text(
                    '분만기록 등록',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  children: [
                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                            buttonPadding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                            children: [
                              Container(
                                child: const Text('모돈선택',
                                  style: TextStyle(fontSize: 16,
                                    fontFamily: 'Signatra',
                                  ),
                                ),
                                padding: const EdgeInsets.only(right: 100.0),
                              ),
                              Visibility(
                                visible: dropdownSearchVisible,
                                child: SizedBox(
                                  key: const ValueKey('modon'),
                                  width: 140,
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

                                      // print(_searchValue);
                                      // print(_pigNo);
                                      // print(_seq);
                                      // print(_wkGubun);
                                      // print(_targetWkDt);
                                      // print(_sancha);

                                      // 모돈 선택시, 경과일 계산
                                      elapsedDay = int.parse(today.difference(DateTime.parse(_targetWkDt)).inDays.toString());
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
                    SizedBox(
                      width: 320,
                      child: Row(
                        children: [
                          Container(
                            child: const Text('분만일',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Signatra',
                              ),
                            ),
                            padding: const EdgeInsets.only(right: 15.0),
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
                              Padding(padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
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
                              child: const Text('분만구분',
                                style: TextStyle(fontSize: 16,
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
                                items: bunmanGubunList.map((ComboListModel item) {
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
                              child: const Text('분만장소',
                                style: TextStyle(fontSize: 16,
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
                                items: bunmanLocationList.map((ComboListModel item) {
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
                                    ),
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
                                      chongSanController.text = "0";
                                      silsanController.text = "0";
                                      silsanMaleController.text = "0";
                                      silsanFemaleController.text = "0";
                                      pouController.text = "0";
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

                                    silsanFemaleController.text = chongSanController.text;

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
                                  inputFormatters: [FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),],
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
                                  controller: sasanController ,
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
                            ]
                        )
                    ),

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
                            ]
                        )
                    ),

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
                                controller: tjController ,
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
                                controller: gtController  ,
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
                          ],
                        )
                    ),

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
                            buttonPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            children: [
                              Container(
                                child: const Text('요약',
                                  style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
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
                                  keyboardType: TextInputType.number,
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
                            ]
                        )
                    ),

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
                                    )
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
                        child: const Text('저장', style: TextStyle(fontSize: 20),),
                        onPressed: () async {

                          if(_searchValue.isEmpty) {
                            _showDialog(context,"모돈을 선택해 주세요.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          /*
                      if(bunmanGubunValue == null) {
                        _showDialog(context,"분만구분을 선택해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }
                      */

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
                      if(femaleController.text.isEmpty) {
                        _showDialog(context,"폐사두수 (암)을 입력해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      if(maleController.text.isEmpty) {
                        _showDialog(context,"폐사두수 (수)를 입력해 주세요.");
                        FocusScope.of(context).unfocus();
                        return;
                      }
*/

                          setInsert(bigoController.text, selectedDate);
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
                      DataColumn(label: Text('교배일')),
                      DataColumn(label: Text('분만일')),
                      DataColumn(label: Text('총산')),
                      DataColumn(label: Text('미라')),
                      DataColumn(label: Text('사산')),
                      DataColumn(label: Text('실산')),
                      DataColumn(label: Text('포유개시')),
                      DataColumn(label: Text('평균체중')),
                      DataColumn(label: Text('총체중')),
                      DataColumn(label: Text('분만구분')),
                      DataColumn(label: Text('분만장소')),
                      DataColumn(label: Text('수정일자')),
                      DataColumn(label: Text('수정자')),
                    ],
                    rows: lists
                        .map(
                      ((element) => DataRow(
                        cells: [
                          DataCell(Text(element.farmPigNo),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChildBirthDetail(
                                            farmNo: element.farmNo,
                                            pigNo: element.pigNo,
                                            farmPigNo: element.farmPigNo,
                                            sancha: element.sancha,
                                            igakNo: element.igakNo ?? "",
                                            // sagoGubunNm: element.sagoGubunNm ?? "",
                                            seq: element.seq,
                                            wkGubun: element.wkGubun,
                                            locCd: '',
                                            wkDt: element.wkDt,
                                            pbigo: element.bigo,
                                            wkPersonCd: '',
                                            bunmanGubunCd: element.bunmanGubunCd ?? "",
                                          ),
                                    ));
                              }),
                          DataCell(Text(element.igakNo.toString()),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChildBirthDetail(
                                              farmNo: element.farmNo,
                                              pigNo: element.pigNo,
                                              farmPigNo: element.farmPigNo,
                                              sancha: element.sancha,
                                              igakNo: element.igakNo ?? "",
                                              // sagoGubunNm: element.sagoGubunNm ?? "",
                                              seq: element.seq,
                                              wkGubun: element.wkGubun,
                                              locCd: '',
                                              wkDt: element.wkDt,
                                              pbigo: element.bigo,
                                              wkPersonCd: '',
                                              bunmanGubunCd: element.bunmanGubunCd ?? "",

                                            ),
                                        settings: RouteSettings(arguments: element)
                                    ));
                              }),
                          DataCell(Text((element.sancha).toString())),
                          DataCell(Text(element.gdt)),
                          DataCell(Text(element.wkDt)),
                          DataCell(Text(element.chongSan.toString())),
                          DataCell(Text(element.mila.toString())),
                          DataCell(Text(element.sasan.toString())),
                          DataCell(Text(element.silsan.toString())),
                          DataCell(Text(element.pogae.toString())),
                          DataCell(Text(element.avgKg.toString())),
                          DataCell(Text(element.saengsiKg.toString())),

                          DataCell(
                            FutureBuilder(
                              future: getCodeSysList(element.bunmanGubunCd.toString(), ''),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString());
                                } else {
                                  return const Text('');
                                }
                              },
                            ),
                          ),

                          DataCell(Text(element.locNm)),
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
      ),
    );
  }

  // 조회
  Future<List<ChildBirthModel>> getList() async {
    List<ChildBirthModel> datas = List<ChildBirthModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/pmd/inputmd/selectBunmanList.json";

    var parameters = {
      'searchFarmPigNo': _searchValue,
      // 'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      // 'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
      'searchModonItem': "md",
      'searchSort': "BM.LOG_UPT_DT DESC,BM.LOG_INS_DT ASC",
      'searchDtBacisItem': 'wkdt',
    };

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    print(parameters);

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          'cookie': session_id,
        },
        body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];
      for (int i = 0; i < data.length; i++) {
        datas.add(ChildBirthModel.fromJson(data[i]));
      }
      lists = datas;
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
      'searchType': '1',
      'dateFormat': 'yyyy-MM-dd',
      'orderby': 'LAST_WK_DT',
    });

    url += "?searchPigNo="+pigNo+"&searchFarmPigNo="+pigNo+"&dieSearch=N&searchType=1&orderby=LAST_WK_DT";

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

    late List<ModonDropboxModel> modonList = List<ModonDropboxModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    String url = _baseUrl + "/common/combogridModonList.json";

    url += "?searchPigNo="+pPigNo.toString()+"&searchFarmPigNo="+pPigNo.toString()+"&dieSearch=N&searchType=1&orderby=LAST_WK_DT&oneDataSearch=Y";

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: ''
    );

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

      elapsedDay = int.parse(today.difference(DateTime.parse(_targetWkDt)).inDays.toString());

      for (int i = 0; i < data.length; i++) {
        modonList.add(ModonDropboxModel.fromJson(data[i]));
      }

      return modonList;
    } else {
      throw Exception('error');
    }
  }

  // 저장
  setInsert(String bigo, DateTime selectedDate) async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = 'pigplan/pmd/inputmd/updateOrStoreChildbirth.json';

    var msg = "";
    bool result = true;

    var _bunmanLocation = "";

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

    // 분만장소
    if(bunmanLocationValue == null) {
      _bunmanLocation = "";
    } else {
      _bunmanLocation = bunmanLocationValue!.code.toString();
    }

    if(milaController.text == "") {
      milaController.text = "0";
    }
    if(sasanController.text == "") {
      sasanController.text = "0";
    }
    if(cmController.text == "") {
      cmController.text = "0";
    }
    if(ghController.text == "") {
      ghController.text = "0";
    }
    if(shController.text == "") {
      shController.text = "0";
    }
    if(csController.text == "") {
      csController.text = "0";
    }
    if(tjController.text == "") {
      tjController.text = "0";
    }
    if(gtController.text == "") {
      gtController.text = "0";
    }

    final parameter = json.encode({
      "pigNo": _pigNo,
      "sancha": _sancha,
      "searchPigNo": "",
      "seq": _seq,
      "topPigNo": _pigNo,
      'wkDt': selectedDate.toLocal().toString().split(" ")[0],    // 분만일
      "bunmanGubunCd": bunmanGubunValue!.code.toString() ,        // 분만구분
      "locCd": _bunmanLocation,                                   // 분만장소
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
      "yinPigNo": _jisearchValue,                                 // 양자 전입 - 모돈번호
      "junchulDusu": int.parse(junchulDusuController.text),       // 양자 전출 - 수
      "junchulDusuSu": int.parse(junchulDusuSuController.text),   // 양자 전출 - 암
      "youtPigNo": _jcsearchValue,                                // 양자 전출 - 모돈번호
      "bigo": bigo,                                               // 비고
      "wkGubun": _wkGubun,
      "iuFlag": "I",
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
      reset();
      method();
      lists = await getList();
      _showDialog(context, "저장 되었습니다.");
      return "sucess";
    } else if(result == false) {
      _showDialog(context, msg);
      FocusScope.of(context).unfocus();
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

  // api url로 특정 코드 리스트 조회
  Future<List<PoyuModonModel>> getCodeListFromUrl(String filter) async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    String url = 'common/combogridPouModonList.json?inOut=IN';
    print(filter);
    if(filter.isNotEmpty) {
      filter = "&farmPigNo="+filter;
    }
    print(filter);
    late List<PoyuModonModel> cbList = List<PoyuModonModel>.empty(growable: true);
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

  getCodeSysList(String code, String pcode) async {

    if(code.isEmpty) {
      return "";
    }

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = "http://192.168.3.46:8080/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
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


  // 초기화
  reset() {

    bunmanGubunValue = null;
    bunmanLocationValue = null;

    chongSanController.text = "0";
    milaController.text = "0";
    sasanController.text = "0";
    cmController.text = "0";
    ghController.text = "0";
    shController.text = "0";
    csController.text = "0";
    tjController.text = "0";
    gtController.text = "0";
    silsanController.text = "0";
    pouController.text = "0";
    silsanFemaleController.text = "0";
    silsanMaleController.text = "0";
    avgKgController.text = "0";
    saengsiKgController.text = "0";

    junipDusuController.text = "0";
    junipDusuSuController.text = "0";
    junchulDusuController.text = "0";
    junchulDusuSuController.text = "0";

    avgKgController.text = "";
    saengsiKgController.text = "";

    bigoController.text = "";
    setState(() { });
  }


}
