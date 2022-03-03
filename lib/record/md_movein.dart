import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:pigplan_mobile/common/util.dart';
import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:pigplan_mobile/model/modon_last_info_model.dart';
import 'package:pigplan_mobile/model/record/eungdon_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:flutter/material.dart';
import 'package:pigplan_mobile/model/record/mating_record_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:pigplan_mobile/model/record/md__died__sell__model.dart';
import 'package:pigplan_mobile/model/record/md_movein_model.dart';
import 'package:pigplan_mobile/model/record/poyou_jadon_died_model.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/record/poyou_jadon_died_detail.dart';

import '../dashboard.dart';
import 'md__died__sell__detail.dart';
import 'md_movein_detail.dart';


class Mdmovein extends StatefulWidget {
  const Mdmovein({Key? key}) : super(key: key);

  @override
  _Mdmovein createState() => _Mdmovein();
}

class _Mdmovein extends State<Mdmovein> {

  final formKey = GlobalKey<FormState>();

  late final int pigNo;
  late final int sancha;
  late final int seq;
  late final String wkDt = "";
  late int pouDusu = 0;

  TextEditingController controller = TextEditingController();

  TextEditingController farmPigNoController = TextEditingController();
  TextEditingController igakNoController = TextEditingController();
  TextEditingController inSanchaController = TextEditingController(text: '0');
  TextEditingController inGyobaeCntController = TextEditingController(text: '0');
  TextEditingController bigoController = TextEditingController();

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;

  late List<MdMoveinModel> lists = [];

  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];

  late List<ComboListModel> pumjongList = [];
  late List<ComboListModel> statusList = [];
  late List<ComboListModel> buyCompList = [];

  // 폐사원인
  late List<ComboListModel> diedList = [];

  // 분만틀
  late List<ComboListModel> farrowingList = [];

  // 도폐사원인
  late List<ComboListModel> MdDiedList = [];

  // 도폐사 구분
  late List<ComboListModel> MdDiedGbnList = [];

  ComboListModel? pumjongValue;
  ComboListModel? statusValue;
  ComboListModel? buyCompValue;

  // 도폐사원인
  ComboListModel? selectedOutReasonCd;
  // 선택된 분만틀 값
  ComboListModel? selectedFarrowingValue;

  late String _searchValue = "";
  late String _wkGubun = "";
  late String _targetWkDt = "";
  late String _wkDtP = "";
  late int _pigNo = 0;
  late int _seq = 0;
  late int _sancha = 0;

  late String pumjongCd = "";
  late String pumjongNm = "";
  late String _status = "";
  late String _buyComp = "";

  // 날짜 셋팅
  DateTime today = DateTime.now();

  // 출생일
  DateTime selectedBirthDate = DateTime.now();
  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedBirthDate,
        // firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedBirthDate) {
      setState(() {
        selectedBirthDate = picked;
      });
    }
  }

  // 전입일
  DateTime selectedInDate = DateTime.now();
  Future<void> _selectedInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedInDate,
        // firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedInDate) {
      setState(() {
        selectedInDate = picked;
      });
    }
  }

  // 최종작업일
  DateTime selectedLastDate = DateTime.now();
  Future<void> _selectLastDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedLastDate,
        // firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedLastDate) {
      setState(() {
        selectedLastDate = picked;
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

    setState(() {
      method();
    });
  }

  method() async {

    // lists = await getList();
    gbList = await Util().getFarmCodeList('','G');
    lcList = await Util().getLocation('080004');
    edList = await Util().getEungdon();

    // 폐사원인
    // diedList = await Util().getCodeListFromUrl('/common/comboPeasaReason.json');

    // 품종
    pumjongList = await getPumjongCodeList('', '');

    // 시작 상태
    statusList = await getStatusCodeList('','');

    // 구입처
    buyCompList = await getBuyCompCodeList('','');

    //MdDiedList = await getCodeList('', '08');

    //dDiedGbnList = await getCodeJohapList('', '031');

    setState(() {
      const SingleChildScrollView();

      // 폐사원인 0번째 선택
      //MdDiedValue = MdDiedList[0];
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
                  ),
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
                      // visible: dropdownSearchVisible,
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

                              // 선택 모돈으로 list 조회
                              getList();

                            }),
                          ),
                        ),
                      ),
                    ),

                    // qr에서 넘어온 경우
                    /*
                        Visibility(
                          // visible: !dropdownSearchVisible,
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

                ExpansionTile(
                  // key: formKey,
                  initiallyExpanded: true,
                  title: const Text(
                    '모돈전입기록 등록',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,

                    ),
                  ),
                  children: [
                    SizedBox(
                      width: 350,
                      child: ButtonBar(
                          buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          children: [
                            Container(
                              child: const Text(
                                '개체번호',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 80.0),
                            ),
                            Container(
                              child: SizedBox(
                                width: 150,
                                height: 40,
                                child: TextFormField(
                                  controller: farmPigNoController,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
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
                      width: 350,
                      child: ButtonBar(
                          buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          children: [
                            Container(
                              child: const Text(
                                '이각번호',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 80.0),
                            ),
                            Container(
                              child: SizedBox(
                                width: 150,
                                height: 40,
                                child: TextFormField(
                                  controller: igakNoController,
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
                        width: 320,
                        child: Row(
                          children: [
                            Container(
                              child: const Text('출생일',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(40, 0, 80, 0),
                            ),
                            ButtonTheme(
                              child: RaisedButton(onPressed: () => _selectBirthDate(context),
                                child: Text("${selectedBirthDate.toLocal()}"
                                    .split(" ")[0]
                                    .toString()),
                              ),
                              buttonColor: Colors.grey,
                              height: 30,
                            ),
                          ],
                        )
                    ),

                    SizedBox(
                        width: 320,
                        child: Row(
                          children: [
                            Container(
                              child: const Text('전입일',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(40, 0, 80, 0),
                            ),
                            ButtonTheme(
                              child: RaisedButton(onPressed: () => _selectedInDate(context),
                                child: Text("${selectedInDate.toLocal()}"
                                    .split(" ")[0]
                                    .toString()),
                              ),
                              buttonColor: Colors.grey,
                              height: 30,
                            ),
                          ],
                        )
                    ),

                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                          children: [
                            Container(
                              child: const Text('품종',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 120.0),
                            ),
                            SizedBox(
                              key: const ValueKey('pumjong'),
                              width: 130,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('선택'),
                                value: pumjongValue,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) {
                                  setState(() {
                                    pumjongValue = newValue!;
                                  });
                                },
                                items: pumjongList.map((ComboListModel item) {
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
                              child: const Text('시작상태',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 95.0),
                            ),
                            SizedBox(
                              width: 130,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('선택'),
                                value: statusValue,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) async {
                                  setState(() {
                                    statusValue = newValue!;
                                  });
                                },
                                items: statusList.map((ComboListModel item) {
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
                                '시작산차',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 142.0),
                            ),
                            Container(
                              child: SizedBox(
                                width: 90,
                                height: 40,
                                child: TextFormField(
                                  controller: inSanchaController,
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
                      width: 350,
                      child: ButtonBar(
                          buttonPadding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                          children: [
                            Container(
                              child: const Text(
                                '교배차수',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 142.0),
                            ),
                            Container(
                              child: SizedBox(
                                width: 90,
                                height: 40,
                                child: TextFormField(
                                  controller: inGyobaeCntController,
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
                        width: 320,
                        child: Row(
                          children: [
                            Container(
                              child: const Text('최종작업일',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(35, 0, 80, 0),
                            ),
                            ButtonTheme(
                              child: RaisedButton(onPressed: () => _selectLastDate(context),
                                child: Text("${selectedLastDate.toLocal()}"
                                    .split(" ")[0]
                                    .toString()),
                              ),
                              buttonColor: Colors.grey,
                              height: 30,
                            ),
                          ],
                        )
                    ),

                    SizedBox(
                        width: 350,
                        child: ButtonBar(
                          children: [
                            Container(
                              child: const Text('구입처',
                                style: TextStyle(fontSize: 16,
                                  fontFamily: 'Signatra',
                                ),
                              ),
                              padding: const EdgeInsets.only(right: 110.0),
                            ),
                            SizedBox(
                              key: const ValueKey('buycomp'),
                              width: 130,
                              child: DropdownButton(
                                isDense: true,
                                isExpanded: true,
                                hint: const Text('선택'),
                                value: buyCompValue,
                                style: const TextStyle(color: Colors.black),
                                onChanged: (ComboListModel? newValue) {
                                  setState(() {
                                    buyCompValue = newValue!;
                                  });
                                },
                                items: buyCompList.map((ComboListModel item) {
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

                          if(farmPigNoController.text == "") {
                            _showDialog(context,"개체번호를 입력해 주세요.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          if(pumjongValue == null) {
                            _showDialog(context,"품종을 선택해 주세요.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          if(statusValue == null) {
                            _showDialog(context,"시작상태를 선택해 주세요.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          if(inSanchaController.text == "") {
                            _showDialog(context,"시작산차를 입력해 주세요.");
                            FocusScope.of(context).unfocus();
                            return;
                          }

                          // 중복체크
                          var rslt = await dupCheck();

                          print(rslt);
                          if(rslt != "false") {
                            // 저장
                            setInsert();
                          }


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
                      DataColumn(label: Text('품종')),

                      DataColumn(label: Text('출생일')),
                      DataColumn(label: Text('전입일')),
                      DataColumn(label: Text('시작상태')),
                      DataColumn(label: Text('최종작업일')),
                      DataColumn(label: Text('구입처')),

                      DataColumn(label: Text('수정일')),
                      DataColumn(label: Text('수정자')),
                    ],
                    rows: lists
                        .map(
                      ((element) => DataRow(
                        cells: [
                          DataCell(Text(element.farmPigNo.toString()), onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MdmoveinDetail(
                                          pigNo: element.pigNo,
                                          farmPigNo: element.farmPigNo,
                                          igakNo: element.igakNo ?? "",
                                          birthDt: element.birthDt,
                                          inDt: element.inDt,
                                          pumjongCd: element.pumjongCd,
                                          status: element.statusCd,
                                          inSancha: element.inSancha,
                                          inGyobae: element.inGyobaeCnt,
                                          lastWkDt: element.lastWkDt,
                                          buyComCd: element.buyComCd,
                                          bigo: element.bigo,
                                          seq: element.seq,
                                        ),
                                    settings: RouteSettings(arguments: element)
                                ));
                          }),
                          DataCell(Text(element.igakNo.toString()), onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MdmoveinDetail(
                                          pigNo: element.pigNo,
                                          farmPigNo: element.farmPigNo,
                                          igakNo: element.igakNo ?? "",
                                          birthDt: element.birthDt,
                                          inDt: element.inDt,
                                          pumjongCd: element.pumjongCd,
                                          status: element.statusCd,
                                          inSancha: element.inSancha,
                                          inGyobae: element.inGyobaeCnt,
                                          lastWkDt: element.lastWkDt,
                                          buyComCd: element.buyComCd,
                                          bigo: element.bigo,
                                          seq: element.seq,
                                        ),
                                    settings: RouteSettings(arguments: element)
                                ));
                          }),
                          // DataCell(Text((element.pumjongCd).toString())),
                          DataCell(
                            FutureBuilder(
                              future: getCodeSysValue(element.pumjongCd.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString());
                                } else {
                                  return const Text('');
                                }
                              },
                            ),
                          ),

                          DataCell(Text(element.birthDt)),
                          DataCell(Text(element.inDt)),
                          DataCell(
                            FutureBuilder(
                              future: getCodeSysValue(element.statusCd.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString());
                                } else {
                                  return const Text('');
                                }
                              },
                            ),
                          ),
                          DataCell(Text(element.lastWkDt)),
                          DataCell(Text(element.buyComNm)),
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
  Future<List<MdMoveinModel>> getList() async {
    List<MdMoveinModel> datas = List<MdMoveinModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/pmd/inputmd/moveinList.json";

    var parameters = {
      // 'searchDtBacisItem': "indt",
      "searchModonItem": "md",
      "ck": "0",
      "searchSort": "FARM_PIG_NO DESC",
      // 'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      // `'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
      "dieSearch": "Y",
      'dateFormat': "yyyy-MM-dd",
      'searchPigNo': _searchValue,
    };


    print('parameters');
    print(parameters);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    final response = await http.post(Uri.parse(_baseUrl + url),
        headers: {
          'cookie': session_id,
        },
        body: parameters
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['rows'];

      for (int i = 0; i < data.length; i++) {
        datas.add(MdMoveinModel.fromJson(data[i]));
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
      'searchFarmPigNo': pigNo,
      'dieSearch': 'Y',
    });

    url += "?searchFarmPigNo="+pigNo+"&dieSearch=Y";

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

  // 개체번호 중복 체크
  Future<String?> dupCheck() async {
    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = '/pigplan/pmd/common/searchModonChk.json';

    var msg = "";
    bool result = true;


    final parameter = json.encode({
      'pigNo': "",
      'searchFarmPigNo': farmPigNoController.text,
      'liveYn': "Y",
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

    var data = jsonDecode(response.body);

    // result = jsonDecode(response.body)['result'];
    // msg = jsonDecode(response.body)['msg'];

    if (response.statusCode == 200) {
      // 중복 확인
      if (data.isNotEmpty) {
        _showDialog(context, "중복 개체번호가 있습니다.");
        return "false";
      }
    } else {
      throw Exception('error');
      return "false";
    }

  }

  setInsert() async {

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = 'pigplan/pmd/inputmd/updateOrStoreMovein.json';

    var msg = "";
    bool result = true;

    var etcTradeYn = "N";
    var _selectedOutReasonCd = "";

    // 시작상태
    if(statusValue == null) {
      _status = "";
    } else {
      _status = statusValue!.code.toString();
    }

    if(pumjongValue == null) {
      pumjongCd = "";
      pumjongNm = "";
    } else {
      pumjongCd = pumjongValue!.code.toString();
      pumjongNm = pumjongValue!.cname.toString();
    }

    if(buyCompValue == null) {
      _buyComp = "";
    }

    final parameter = json.encode({
      'bigo': bigoController.text,                  //
      'birthDt': selectedBirthDate.toLocal().toString().split(" ")[0], //
      'buyComCd': _buyComp,
      'buyComCd4Digit': "",
      'familyCd': "",
      'farmPigNo': farmPigNoController.text,        //
      'hyultongNo': "",
      'igakNo': igakNoController.text,              //
      'inDt': selectedInDate.toLocal().toString().split(" ")[0], //
      'inGyobaeCnt': inGyobaeCntController.text,    //
      'inSancha': inSanchaController.text,          //
      'iuFlag': "I",
      'lastWkDt': selectedLastDate.toLocal().toString().split(" ")[0],   //
      'method': "",
      'mila': 0,
      'moHyulNo': "",
      'moPigNo': "",
      'modonType': _status,                         //
      'overJobCnt': "",
      'pigNo': "",
      'pss': "",
      'pumjongCd': pumjongCd,             //
      'pumjongNm': pumjongNm,             //
      'rfidNo': "",
      'sasan': 0,
      'silsanAm': 0,
      'silsanSu': 0,
      'startLoc': "",
      'statusCd': _status,                //
      'statusCdP': "",
      'ufarmPigNo': "",
      'unHyulNo': "",
      'unPigNo': "",
      'ungdonPigNo': "0",
      'weight': 0,
      'wkDtP': "",
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

    if (response.statusCode == 200 && result == true ) {
      // 저장 성공시, 초기화
      reset();
      setState(() async {
        lists = await getList();
      });

      _showDialog(context, "저장 되었습니다.");
      return "sucess";
    } else if(result == false) {
      _showDialog(context, msg);
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

  Future<List<ComboListModel>> getPumjongCodeList(String code, String pcode) async {

    late List<ComboListModel> pumjongList = List<ComboListModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
    // String url = "http://192.168.3.46:8080/common/comboFarmPumjongCd.json";
    String url = "http://192.168.3.46:8080/common/comboJohapCodeCd.json";
    var parameters = json.encode({
    });

    url += '?lang=ko&pcode=041,23';

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
        pumjongList.add(ComboListModel.fromJson(data[i]));
      }

      return pumjongList;
    } else {
      throw Exception('error');
    }
  }

  Future<List<ComboListModel>> getStatusCodeList(String code, String pcode) async {

    late List<ComboListModel> statusList = List<ComboListModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = "http://192.168.3.46:8080/common/comboModonStatus.json";
    var parameters = json.encode({
      'lang': 'ko',
    });

    url += '?lang=ko';

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
        statusList.add(ComboListModel.fromJson(data[i]));
      }

      return statusList;
    } else {
      throw Exception('error');
    }
  }

  Future<List<ComboListModel>> getBuyCompCodeList(String code, String pcode) async {

    late List<ComboListModel> compList = List<ComboListModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = "http://192.168.3.46:8080/common/comboBuyComp.json";
    var parameters = json.encode({
      'lang': 'ko',
    });

    url += '?lang=ko&pcode=041';

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
        compList.add(ComboListModel.fromJson(data[i]));
      }
      return compList;
    } else {
      throw Exception('error');
    }
  }

  getCodeValue(String code, String pcode) async {

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

  getCodeSysValue(String code) async {

    if(code.isEmpty) {
      return "";
    }

    // RequestBody로 받아줘서 body로 넘기는게 가능
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

  Future<List<ComboListModel>> getCodeJohapList(String code, String pcode) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
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

  Future<String> getLastModonInfo() async {
    List<modonLastInfoModel> list = List<modonLastInfoModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
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

      pouDusu = data['dusu']['pouDusuSum'];

      print(data['dusu']['pouDusuSum']);

      setState(() {});
      return data['wkvw']['statusCd'];
    } else {
      throw Exception('error');
    }
  }

  getCodeSysList(String code, String pcode) async {
    //
    // if(code.isEmpty) {
    //   return "";
    // }

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = "http://192.168.3.46:8080/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?type=sys&code="+code+"&pcode="+pcode+"&codeChar=Y&jsonSearch=Y";

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

    //MdDiedValue = MdDiedList[0];

    farmPigNoController.text = "";
    igakNoController.text = "";
    inSanchaController.text = "0";
    inGyobaeCntController.text = "";
    bigoController.text = "";

    setState(() { });
  }

}

// 대문자 변환
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
