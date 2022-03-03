import 'dart:developer';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/model/combolist_model.dart';
import 'package:pigplan_mobile/model/record/eungdon_model.dart';
import 'package:pigplan_mobile/model/modon_dropbox_model.dart';
import 'package:pigplan_mobile/model/modon_history/modon_history_model.dart';

//개발, 운영 설정파일

class Util {

  String _baseUrl = "http://192.168.3.46:8080";

  //모돈 리스트 조회
  Future<List<ModonDropboxModel>> getModonList(pigNo) async {

    print(pigNo);
    late List<ModonDropboxModel> modonList = List<ModonDropboxModel>.empty(growable: true);

    String url = _baseUrl + "/common/combogridModonList.json";

    var parameters = json.encode({
      "searchPigNo": pigNo,
      "searchType": '2',
      "orderby": 'FARM_PIG_NO',
    //  "searchStatus": {'010002', '010006', '010007'},
    });

    url += "?searchType=2&orderby=FARM_PIG_NO&searchStatus=" + "010002,010006,010007";

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

  // 단일 코드값 조회
  Future<String> getCodeRecord(String type, String code, String pcode) async {

    // 코드가 없을 경우 return
    if (code.isEmpty) {
      return "";
    }

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?type="+type+"&code=" + code + "&pcode=" + pcode;

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
        if (data[i]['code'] == code) {
          value = data[i]['cname'];
          return value;
        }
      }
      return value;
    } else {
      throw Exception('error');
    }
  }

  // TC_CODE_SYS 코드리스트 값 조회
  Future<List<ComboListModel>> getCodeSysList(String type, String code, String pcode, String gbn, String lang) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);
    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/common/getCodes.json";

    var gbnValue = gbn.toString().split(",");

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?type="+type+"&code=" + code + "&pcode=" + pcode + "&lang=" + lang;

    // print(url);

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
          // 얻어야하는 값이랑 같으면 list에 추가

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

  // TC_CODE_JOHAP 코드리스트 값 조회
  Future<List<ComboListModel>> getCodeJohabList(String pcode, String code, String lang, String useyn, String johap) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);
    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/common/getCodes.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    // ModelAttribute로 받아줘서 url뒤로 넘김
    url += "?&pcode=" + pcode + "&code=" + code + "&lang=" + lang + "&useyn=" + useyn + "&type=" + johap;

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
          // 얻어야하는 값이랑 같으면 list에 추가
          if(data[i]['pcode'] == pcode) {
            cbList.add(ComboListModel.fromJson(data[i]));
          }
      }

      print(cbList.length);
      return cbList;
    } else {
      throw Exception('error');
    }
  }

  // api url로 특정 코드 리스트 조회
  Future<List<ComboListModel>> getCodeListFromUrl(String url) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);
    // RequestBody로 받아줘서 body로 넘기는게 가능
    url = _baseUrl + url;

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

      for (int i = 0; i < data.length; i++) {
        cbList.add(ComboListModel.fromJson(data[i]));
      }

      return cbList;
    } else {
      throw Exception('error');
    }
  }

  // 농장 공통 코드 조회
  Future<List<ComboListModel>> getFarmCodeList(String code, String pcode) async {

    // 코드가 없을 경우 return
    if (pcode.isEmpty) {
      throw Exception("error");
    }

    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);

    // RequestBody로 받아줘서 body로 넘기는게 가능
    String url = _baseUrl + "/common/comboFarmCodeCd.json";

    var parameters = json.encode({
      'lang': 'ko',
    });

    url += "?pcode=" + pcode;

    dynamic session_id = await FlutterSession().get("SESSION_ID");
    final response = await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'cookie': session_id,
        },
        body: parameters);

    var statusCode = response.statusCode;

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        list.add(ComboListModel.fromJson(data[i]));
      }
      return list;
    } else {
      throw Exception('error');
    }

  }

  // 장소구분
  Future<List<ComboListModel>> getLocation(String pcodeTp) async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    var url = _baseUrl + "/common/comboCodeFarmDonBang.json";
    var parameters = {
      'pcodeTp': pcodeTp,
      'lang': 'ko'
    };

    final uri = Uri.http('192.168.3.46:8080', '/common/comboCodeFarmDonBang.json', parameters);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'cookie': session_id,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        list.add(ComboListModel.fromJson(data[i]));
      }
      return list;
    } else {
      throw Exception('error');
    }
  }

  // 분만틀
  Future<List<ComboListModel>> getFarmFarrowing(String locCd) async {
    List<ComboListModel> list = List<ComboListModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    var url = _baseUrl + "/common/comboCodeFarmFarrowing.json";
    var parameters = {
      'locCd': locCd,
      'lang': 'ko'
    };

    final uri = Uri.http('192.168.3.46:8080', '/common/comboCodeFarmFarrowing.json', parameters);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'cookie': session_id,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        list.add(ComboListModel.fromJson(data[i]));
      }
      return list;
    } else {
      throw Exception('error');
    }
  }

  // 웅돈 조회
  Future<List<EungdonModel>> getEungdon() async {
    List<EungdonModel> list = List<EungdonModel>.empty(growable: true);
    dynamic session_id = await FlutterSession().get("SESSION_ID");

    // url, parameter 셋팅
    var url = _baseUrl + "/common/comboBoarList.json";
    var parameters = {
      'pcodeTp': '080001, 080002, 080003',
      'lang': 'ko'
    };

    final uri = Uri.http('192.168.3.46:8080', '/common/comboBoarList.json', parameters);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'cookie': session_id,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      for (int i = 0; i < data.length; i++) {
        list.add(EungdonModel.fromJson(data[i]));
      }
      return list;
    } else {
      throw Exception('error');
    }
  }

  // dropbox parameter로 list 만들기
  Future<List<ComboListModel>> getCodeListFromString(String param) async {

    late List<ComboListModel> cbList = List<ComboListModel>.empty(growable: true);

    cbList.add(ComboListModel(code: "Y", cname: "예", pcode: "", cvalue: ""));
    cbList.add(ComboListModel(code: "N", cname: "아니오", pcode: "", cvalue: ""));

    // RequestBody로 받아줘서 body로 넘기는게 가능
    var data = [];
    data = param.split(",");

    if (data.isNotEmpty) {
      //
      // for (int i = 0; i < datamap.length; i++) {
      //   cbList.add(ComboListModel.fromJson(data[i]));
      // }

      return cbList;
    } else {
      throw Exception('error');
    }
  }

  Future<dynamic> getOneModonInfo(pigNo) async {

    late List<ModonDropboxModel> modonList = List<ModonDropboxModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    // String url = _baseUrl + "/pigplan/pmd/inputmd/selectOneByDiedSell.json";

    String url = _baseUrl + "/pigplan/pmd/inputmd/selectMdLastAndJobInfo.json";

    var parameters = json.encode({
      'pigNo': pigNo,
      'lang': 'ko',
      'dateFormat': 'yyyy-MM-dd',
      'target': 'mdDiewr',
      'iuFlag': 'U',
      'seq': 0,
      'sancha': 0,
    });

    url += "?pigNo="+pigNo.toString()+"&lang=ko&dateFormat=yyyy-MM-dd&target=mdDiewr&seq=0&sancha=0&iuFlag=U";


    // {pigNo=1862, seq=0, sancha=0, sysEnv=local, target=mdDiewr, iuFlag=U, lang=ko, farmNo=105, dateFormat=yyyy-MM-dd, env=local}

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
      return data;
    } else {
      throw Exception('error');
    }
  }

  // 모돈 최종작업 및 이전 작업정보 조회(공통)
  Future<dynamic> getLastModonInfo(pigNo, target, seq, sancha, wkDt) async {

    late List<ModonDropboxModel> modonList = List<ModonDropboxModel>.empty(growable: true);

    const String _baseUrl = "http://192.168.3.46:8080/";
    // String url = _baseUrl + "/pigplan/pmd/inputmd/selectOneByDiedSell.json";

    String url = _baseUrl + "/pigplan/pmd/inputmd/selectMdLastAndJobInfo.json";

    var parameters = json.encode({
      'pigNo': pigNo,
      'target': target,
      'seq': seq,
      'sancha': sancha,
      'wkDt': wkDt,
      'lang': 'ko',
      'iuFlag': 'U',
      'dateFormat': 'yyyy-MM-dd',
    });

    // url += "?pigNo="+pigNo.toString()+"&lang=ko&dateFormat=yyyy-MM-dd&target=mdDiewr&seq=0&sancha=0&iuFlag=U";

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

      // print('lastmodon');
      // print(data);

      return data;
    } else {
      throw Exception('error');
    }
  }

  // johap 코드 조회
  getCodeSysValue(String code) async {

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





}
