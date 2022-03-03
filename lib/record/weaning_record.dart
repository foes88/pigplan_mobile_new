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
import 'package:pigplan_mobile/model/modon_last_info_model.dart';
import 'package:pigplan_mobile/model/record/poyou_jadon_died_model.dart';
import 'package:pigplan_mobile/model/record/poyu_modon_model.dart';
import 'package:pigplan_mobile/model/record/weaning_model.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/record/poyou_jadon_died_detail.dart';
import 'package:pigplan_mobile/record/weaning_record_detail.dart';

import '../dashboard.dart';
import 'child_birth_detail.dart';
import 'mating_record_detail.dart';

class Weaning extends StatefulWidget {

  int pPigNo = 0;

  Weaning({
    Key? key,
    required this.pPigNo,
  }) : super(key: key);

  @override
  _Weaning createState() => _Weaning(pPigNo);
}

class _Weaning extends State<Weaning> {

  final formKey = GlobalKey<FormState>();

  final int pPigNo;

  _Weaning(this.pPigNo);

  TextEditingController controller = TextEditingController();
  TextEditingController bigoController = TextEditingController();

  // 이유두수 - 암
  TextEditingController dusuController = TextEditingController(text: '0');
  // 이유두수 - 수
  TextEditingController dusuSuController = TextEditingController(text: '0');
  //자돈 평균체중
  TextEditingController avgKgController = TextEditingController(text: '0');
  // 자돈 총체중
  TextEditingController saengsiKgController = TextEditingController();

  // 재포유 두수 - 암
  TextEditingController suckleController = TextEditingController(text: '0');
  // 재포유 두수 - 수
  TextEditingController suckleSuController = TextEditingController(text: '0');

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;

  late List<WeaningModel> lists = [];

  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];

  // 재포유
  late List<ComboListModel> jaepouList = [];
  ComboListModel? jaepouValue;

  // 모돈이동장소
  late List<ComboListModel> locationList = [];
  ComboListModel? locationValue;

  // 자돈이동 장소
  late List<ComboListModel> jadonlocList = [];
  ComboListModel? jadonlocCdValue;

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
  late String _lastWk = "";
  late String _statusCd = "";
  late String _statusCdP = "";
  late int _silsan = 0;
  late int _pou = 0;
  late int _ilryung = 0;

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

  // 날짜 셋팅
  DateTime today = DateTime.now();

  // 이유일
  DateTime selectedDate = DateTime.now();

  // dropdownsearch
  bool dropdownSearchVisible = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        firstDate: DateTime(1900),
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

    gbList = await Util().getFarmCodeList('','G');

    // 자돈이동 - 자동생성
    lcList = await Util().getLocation('080005,080006,080007,080008,080009');

    //edList = await Util().getEungdon();

    // 재포유 구분
    jaepouList = await Util().getCodeListFromString('예,아니오');

    // 장소
    locationList = await Util().getLocation('080001,080002,080003,080004');

    // 분만틀

    // await getSelectModonInfo();
    // await getLastModonInfo();
    // await getOneModonInfo();

    // 전입 모돈 리스트
    //junipModonList = await Util().getCodeListFromUrl('/common/combogridPouModonList.json?inOut=IN');

    // 전출 모돈 리스트
    //junchulModonList = await Util().getCodeListFromUrl('/common/combogridPouModonList.json?inOut=OUT');

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

            SizedBox(
              width: 350,
              child: ButtonBar(
                children: [
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
                        child:  DropdownSearch(
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
                          itemAsString: (ModonDropboxModel? m) => m!.farmPigNo.toString(),
                          onChanged: (ModonDropboxModel? value) => setState(() {
                            _searchValue = value!.farmPigNo.toString();
                            _pigNo = value.pigNo;
                            _seq = value.seq;
                            _wkGubun = value.wkGubun;
                            _targetWkDt = value.lastWkDt;
                            _sancha = value.sancha;
                            _wkDt = value.wkDt;

                            print(value.wkDt);

                            // 포유두수
                            //  _pou = value.po;
                            // 이유일령
                            //_ilryung = value.ilryung;

                            // 모돈 선택시, 경과일 계산
                            elapsedDay = int.parse(today.difference(DateTime.parse(_targetWkDt)).inDays.toString());

                            // 일령 계산을 위해
                            getLastModonInfo();

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
                ],
              ),
            ),


            ExpansionTile(
              // key: formKey,
              initiallyExpanded: true,
              title: const Text(
                '이유기록 등록',
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
                                onChanged: (ModonDropboxModel? value) => setState(() async {
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
                                  elapsedDay = int.parse(today.difference(DateTime.parse(_targetWkDt)).inDays.toString());
                                  await getSelectModonInfo();
                                  await getLastModonInfo();
                                  await getOneModonInfo();
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
                        ],
                    ),
                ),
                */

                SizedBox(
                  width: 320,
                  height: 35,
                  child: Row(
                    children: [
                      Container(
                        child: const Text('이유일',
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
                            child: Text('일령 : $elapsedDay '),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                    width: 350,
                    child: ButtonBar(
                        // buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        children: [
                          Container(
                            child: const Text('실산',
                              style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                            ),
                            padding: const EdgeInsets.only(right: 10.0),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text('$_silsan '),
                          ),
                          Container(
                            child: const Text('포유두수',
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
                        buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        children: [
                          Container(
                            child: const Text('이유두수',
                              style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                            ),
                            padding: const EdgeInsets.only(right: 40.0),
                          ),
                          SizedBox(
                            width: 50,
                            child: TextFormField(
                              controller: dusuController,
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
                                if(dusuSuController.text == '0') {
                                  dusuSuController.text = '';
                                }
                              },
                            ),
                          ),

                          Container(
                            child: const Text('평균체중',
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
                                if(avgKgController.text == '0') {
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
                            child: const Text('재포유여부',
                              style: TextStyle(fontSize: 16, fontFamily: 'Signatra',),
                            ),
                            padding: const EdgeInsets.only(right: 50.0),
                          ),
                          SizedBox(
                            width: 80,
                            child: DropdownButton(
                              isDense: true,
                              isExpanded: true,
                              hint: const Text('선택'),
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
                          child: const Text('자돈이동',
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
                          child: const Text('장소',
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
                            hint: const Text('선택'),
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

                      // 모돈 선택여부
                      if(_searchValue.isEmpty) {
                        _showDialog(context,"모돈을 선택해 주세요.!");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      if(int.parse(suckleController.text) + int.parse(suckleSuController.text) > 25 ) {
                        _showDialog(context,"재포유두수는 25두보다 크면 안됩니다.");
                        FocusScope.of(context).unfocus();
                        return;
                      }

                      setInsert();
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
                  DataColumn(label: Text('이유일자')),
                  DataColumn(label: Text('이유두수')),
                  DataColumn(label: Text('이유일령')),
                  DataColumn(label: Text('총체중')),
                  DataColumn(label: Text('비고')),
                  DataColumn(label: Text('기록')),
                  DataColumn(label: Text('상태')),
                  DataColumn(label: Text('수정일')),
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
                                      WeaningDetail(
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
                                        autoGb: element.autoGb,
                                      ),
                                ));
                          }),
                      DataCell(Text(element.igakNo.toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WeaningDetail(
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
                                          autoGb: element.autoGb,
                                        ),
                                    settings: RouteSettings(arguments: element)
                                ));
                          }),
                      DataCell(Text((element.sancha).toString())),
                      DataCell(Text(element.wkDt)),
                      DataCell(Text((element.totalDusu).toString()
                          + '/' + '(' + element.eudusu.toString() + '/' + element.euDusuSu.toString() + ')' )),
                      DataCell(Text(element.ilryung.toString())),
                      DataCell(Text(element.totalKg.toString())),
                      DataCell(Text(element.bigo.toString())),

                      DataCell(
                        FutureBuilder(
                          builder: (context, snapshot) {
                            if (element.autoGb == "Z") {
                              return const Text("도폐사");
                            } else {
                              return const Text('');
                            }
                          },
                        ),

                        /*
                        FutureBuilder(
                          future: getCodeSysList(element.autoGb, ''),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data.toString());
                            } else {
                              return const Text('');
                            }
                          },
                        ),
                        */
                      ),
                      DataCell(Text(element.wkGubunStatus)),
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

  final String _baseUrl = "http://192.168.3.46:8080/";
  // 조회
  Future<List<WeaningModel>> getList() async {
    List<WeaningModel> datas = List<WeaningModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/pmd/inputmd/weaningList.json";

    var parameters = {
      'searchFarmPigNo': _searchValue,
      // 'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      // 'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
      'searchModonItem': "md",
      'searchSort': "A.LOG_INS_DT DESC,WK_DT DESC",
      'searchDtBacisItem': 'indt',
    };

    dynamic session_id = await FlutterSession().get("SESSION_ID");

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          'cookie': session_id,
        },
        body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];

      print(response.body);

      for (int i = 0; i < data.length; i++) {
        datas.add(WeaningModel.fromJson(data[i]));
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
      'searchType': '5',
      'dateFormat': 'yyyy-MM-dd',
      'orderby': 'LAST_WK_DT',
      'popMdChoice': 'MD',
      'searchStatus': '010002, 010003, 010004, 010005, 010006, 010007',
    });

    url += "?searchPigNo="+pigNo+"&searchFarmPigNo="+pigNo+"&dieSearch=N&searchType=5&orderby=LAST_WK_DT&popMdChoice=MD&searchStatus=010002, 010003, 010004, 010005, 010006, 010007";

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

      // print(data[0]);

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

  setInsert() async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = '/pigplan/pmd/inputmd/updateOrStoreWeaning.json';

    var msg = "";
    bool result = true;

    // 평균체중
    var _avgKgValue = 0.0;
    // 재포유 여부 선택
    var _jaepouValue = "";
    // 재포유여부 암,수
    int _suckleValue = 0;
    int _suckleSuValue = 0;

    var _jadonlocCd = "";
    var _locCd = "";

    if(avgKgController.text == null || avgKgController.text == "") {
      _avgKgValue = 0;
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
      'wkDt': selectedDate.toLocal().toString().split(" ")[0],    // 분만일
      "bunmanGubunCd": _jaepouValue,                              // 재포유구분
      "locCd": _locCd,                                            // 모돈 이동 장소
      "avgKg": double.parse(avgKgController.text),                // 자돈 평균체중
      "bigo": bigoController.text.toString(),                                // 비고
      "wkGubun": _wkGubun,
      "iuFlag": "I",
      "farmConfChongsanAuto": "N",
      "gyobaeCnt": 0,
      "fwNo": "",
      "popSearchOrder": "NEXT_DT",
      "popSearchStatusCode": "",
      "targetWkDt": "",
      "topIgakNo": "",
      "absa": 0,
      "absaSu": 0,
      "gita": 0,
      "gitaSu": 0,
      "chemi": 0,
      "chemiSu": 0,
      "wkDt": selectedDate.toLocal().toString().split(" ")[0],
      "wkGubun": _wkGubun,
      "pigNo": _pigNo,
      "topPigNo": _pigNo,
      "sancha": _sancha,
      "seq": _seq,
      "bmDt": _lastWk,                              // 최종 작업일
      "dusu": dusuController.text,                  // 이유두수 - 암
      "dusuSu": dusuSuController.text,              // 이유두수 - 수
      "suckle": suckleController.text,              // 재포우 - 암
      "suckleSu": suckleSuController.text,          // 재포유 - 수
      "daeriYn": _jaepouValue,                      // 재포유 여부
      "ilryung": elapsedDay,
      "silsan": _silsan,
      "statusCd": _statusCd,
      "statusCdP": "",
      "iuFlag": "I",
      "euinPouDusu": "0",
      "euinPouDusuSu": "0",
      "popSearchOrder": "LAST_WK_DT",
      "popSearchStatusCode": "",
      "grpId": "",
      "grpNo": "",
      "grpNoP": "",
      "gyobaeCnt": "0",
      "jadonlocCd": _jadonlocCd,                      // 자돈 이동 그룹코드
      "junchul": 0,
      "junchulSu": 0,
      "junip": 0,
      "junipSu": 0,
      "moveGrpSt": "new",                             // new 자동생성, sel 그룹선택
      "huyak": 0,
      "huyakSu": 0,
      "sikja": 0,
      "sikjaSu": 0,
      "sulsa": 0,
      "sulsaSu": 0,
      "targetWkDt": "",
      "topIgakNo": "",
      "totalKg": "0.00",
      "yinPigNo": "",
      "youtPigNo": "",
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

  // 현재 모돈 최종 상태정보 조회
  Future<dynamic> getSelectModonInfo() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = _baseUrl + "/pigplan/pmd/inputmd/selectOneByWeaningLast.json";
    var parameters = json.encode({
      'pigNo': _pigNo,
      'seq': _seq,
      'wkDt': _targetWkDt,
      'sancha': _sancha,
    });

    url += '?pigNo='+_pigNo.toString()+'&seq='+_seq.toString()+'&sancha='+_sancha.toString()
          + "&target=euwr";

    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        }, body: parameters
    );

    if (response.statusCode == 200) {

      print(response.body);

      var data = ""; //jsonDecode(response.body);

      return data;
    } else {
      throw Exception('error');
    }
  }

  // 현재 모돈 최종 상태정보 조회 (공통으로 뺴야할듯)
  Future<dynamic> getLastModonInfo() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    var url = _baseUrl + "/pigplan/pmd/inputmd/selectMdLastAndJobInfo.json";
    var parameters = json.encode({
      'pigNo': _pigNo,
      'seq': _seq,
      'wkDt': _targetWkDt,
      'sancha': _sancha,
      'target': 'euwr',
      'iuFlag': 'I',
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

      // result = jsonDecode(response.body)['result'];

      var data = jsonDecode(response.body);

      // print(data);

      _silsan = data['buman']['silsan'];
      _wkDt = data['buman']['wkDt'];
      _pou = data['dusu']['euinPouDusu'];
      _lastWk = data['last']['wkDt'];
      _statusCd = data['buman']['statusCd'];
      _statusCdP = data['buman']['statusCdP'];

      // 신규 : wkDt - lastWkDt
      //수정 : wkDt - bmDt

      _ilryung = DateTime.parse(_wkDt).difference(DateTime.parse(_targetWkDt)).inDays;

      return  data;
    } else {
      throw Exception('error');
    }
  }

  getOneModonInfo() async {

    if(_pigNo == 0 || _pigNo == null) {
      return;
    }

    List<WeaningModel> list = List<WeaningModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    var url = _baseUrl + "pigplan/pmd/inputmd/selectOneByWeaning.json";
    var parameters = json.encode({
      'pigNo': _pigNo.toString(),
      'dateFormat': 'yyyy-MM-dd',
      'seq': _seq,
      'sancha': _sancha,
      'wkDt': _wkDt,
    });

    url += "?pigNo="+_pigNo.toString()+"&dateFormat=yyyy-MM-dd&seq="+_seq.toString()+"&sancha="+_sancha.toString()+"&wkDt="+_wkDt;

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
      return data;
    } else {
      throw Exception('error');
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
