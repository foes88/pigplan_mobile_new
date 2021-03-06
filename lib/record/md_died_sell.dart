import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
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
import 'package:pigplan_mobile/model/record/poyou_jadon_died_model.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/record/poyou_jadon_died_detail.dart';

import '../dashboard.dart';
import 'md__died__sell__detail.dart';


class MdDiedSell extends StatefulWidget {
  const MdDiedSell({Key? key}) : super(key: key);

  @override
  _MdDiedSell createState() => _MdDiedSell();
}

class _MdDiedSell extends State<MdDiedSell> {

  final formKey = GlobalKey<FormState>();

  late final int pigNo;
  late final int sancha;
  late final int seq;
  late final String wkDt = "";
  late int pouDusu = 0;

  TextEditingController controller = TextEditingController();
  TextEditingController bigoController = TextEditingController();
  TextEditingController kgController = TextEditingController();

  ScrollController listScrollController = ScrollController();
  final sccontroller = ScrollController();

  late String _searchResult = "";
  late List<String> filteredSearchHistory;
  late String selectedTerm;

  late List<MdDiedSellModel> lists = [];

  late List<ComboListModel> gbList = [];
  late List<ComboListModel> lcList = [];
  late List<EungdonModel> edList = [];

  // 폐사원인
  late List<ComboListModel> diedList = [];

  // 분만틀
  late List<ComboListModel> farrowingList = [];

  // 도폐사원인
  late List<ComboListModel> MdDiedList = [];

  // 도폐사 구분
  late List<ComboListModel> MdDiedGbnList = [];

  ComboListModel? MdDiedValue;

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

  // 분만틀 값
  String _selectedFarrowingValue = "";

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

    MdDiedList = await getCodeList('', '08');

    MdDiedGbnList = await getCodeJohapList('', '031');

    setState(() {
      const SingleChildScrollView();

      // 폐사원인 0번째 선택
      MdDiedValue = MdDiedList[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child:  Scaffold(
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
                            _wkDtP = value.lastWkDt;

                            // 선택 모돈으로 list 조회
                            getList();

                          }),
                        ),
                      ),
                    ),
                  ),
                ]
                ),
              ),


              ExpansionTile(
                // key: formKey,
                initiallyExpanded: true,
                title: const Text(
                  '도폐사판매 등록',
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
                            SizedBox(
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
                                  _wkDtP = value.lastWkDt;

                                  //getLastModonInfo();
                                }),
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
                            child: const Text('도폐사일',
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
                        ],
                      )
                  ),
                  SizedBox(
                      width: 350,
                      child: ButtonBar(
                        children: [
                          Container(
                            child: const Text('도폐사구분',
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
                              hint: const Text('선택'),
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
                            child: const Text('도폐사원인',
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
                              hint: const Text('선택'),
                              value: selectedOutReasonCd,
                              style: const TextStyle(color: Colors.black),
                              onChanged: (ComboListModel? newValue) async {
                                setState(() {
                                  selectedOutReasonCd = newValue!;
                                  // 장소 변경시, 분만틀 조회

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
                        '체중kg',
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

                        if(_searchValue.isEmpty) {
                          _showDialog(context,"모돈을 선택해 주세요.");
                          FocusScope.of(context).unfocus();
                          return;
                        }

                        if(MdDiedValue == null) {
                          _showDialog(context,"도폐사구분을 선택해 주세요.");
                          FocusScope.of(context).unfocus();
                          return;
                        }

                        setInsert(bigoController.text, MdDiedValue!, selectedDate);
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
                    DataColumn(label: Text('도폐사일')),
                    DataColumn(label: Text('도폐사구분')),
                    DataColumn(label: Text('도폐사원인')),
                    DataColumn(label: Text('판매금액')),
                    DataColumn(label: Text('체중')),
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
                                    MdDiedSellDetail(
                                      farmNo: element.farmNo,
                                      pigNo: element.pigNo,
                                      farmPigNo: element.farmPigNo,
                                      sancha: element.sancha.toString(),
                                      igakNo: element.igakNo ?? "",
                                      sagoGubunNm: element.sagoGubunNm ?? "",
                                      seq: element.seq,
                                      wkgubun: element.wkGubun,
                                      locCd: '',
                                      pbigo: element.bigo,
                                      wkPersonCd: '',
                                      pouDusu: pouDusu,
                                    ),
                              ));
                        }),
                        DataCell(Text(element.igakNo.toString()), onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MdDiedSellDetail(
                                        farmNo: element.farmNo,
                                        pigNo: element.pigNo,
                                        farmPigNo: element.farmPigNo,
                                        sancha: element.sancha.toString(),
                                        igakNo: element.igakNo ?? "",
                                        sagoGubunNm: element.sagoGubunNm ?? "",
                                        seq: element.seq,
                                        wkgubun: element.wkGubun,
                                        locCd: '',
                                        pbigo: element.bigo,
                                        wkPersonCd: '',
                                         pouDusu: pouDusu,
                                      ),
                                  settings: RouteSettings(arguments: element)
                              ));
                            }),
                        // DataCell(Text((element.pumjongCd).toString())),
                        DataCell(
                          FutureBuilder(
                            future: getCodeJohapValue(element.pumjongCd.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.toString());
                              } else {
                                return const Text('');
                              }
                            },
                          ),
                        ),

                        DataCell(Text(element.wkDt)),
                        DataCell(
                          FutureBuilder(
                            future: getCodeValue(element.outGubunCd.toString(), '031'),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.toString());
                              } else {
                                return const Text('');
                              }
                            },
                          ),
                        ),
                        DataCell(
                          FutureBuilder(
                            future: getCodeValue(element.outReasonCd.toString(), '031'),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data.toString());
                              } else {
                                return const Text('');
                              }
                            },
                          ),
                        ),

                        DataCell(Text(element.salePrice.toString())),
                        DataCell(Text(element.outKg.toString())),
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
    );
  }

  // 조회
  Future<List<MdDiedSellModel>> getList() async {
    List<MdDiedSellModel> datas = List<MdDiedSellModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    var url = "pigplan/pmd/inputmd/diedSellList.json";

    var parameters = {
      'searchFarmPigNo': _searchValue,
      // 'searchFromWkDt': selectedFromDate.toLocal().toString().split(" ")[0],
      // 'searchToWkDt': selectedToDate.toLocal().toString().split(" ")[0],
      'searchModonItem': "md",
      'searchDtBacisItem': "updt",
      'searchSort': "TM.LOG_UPT_DT DESC,FARM_PIG_NO DESC",
      'sowBoar': "S",
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
        datas.add(MdDiedSellModel.fromJson(data[i]));
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
      'searchType': '4',
      'dateFormat': 'yyyy-MM-dd',
      'orderby': 'NEXT_DT',
    });

    url += "?searchPigNo="+pigNo+"&searchFarmPigNo="+pigNo+"&dieSearch=N&searchType=4&orderby=NEXT_DT"
        "&searchStatus='010002','010003','010004','010005','010006','010007'";

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

  setInsert(String bigo, ComboListModel? selectedSago, DateTime selectedDate) async {

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
      'daeriYn': "N",
      'etcTradeYn': etcTradeYn,     // 판매일 경우에는 Y 여야함
      'iuFlag': "I",
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
      'sancha': _sancha,
      'seq': _seq,
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

  Future<List<ComboListModel>> getCodeList(String code, String pcode) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = "http://192.168.3.46:8080/common/getCodes.json";
    var gbn = "080001,080002,080003,080004";
    var gbnValue = gbn.toString().split(",");

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

  getCodeJohapValue(String code) async {

    if(code.isEmpty) {
      return "";
    }

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = "http://192.168.3.46:8080/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
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

    MdDiedValue = MdDiedList[0];

    selectedOutReasonCd = null;
    bigoController.text = "";

    setState(() { });
  }


}
