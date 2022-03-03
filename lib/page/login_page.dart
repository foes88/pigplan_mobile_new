import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:pigplan_mobile/model/login_model.dart';

import 'dart:async';
import 'dart:convert';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

import 'package:pigplan_mobile/dashboard.dart';
import 'package:pigplan_mobile/page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _id = '';
  String _password = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

/*
  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is validate id :  $_id, password: $_password');
    } else {
      print('Form is validate id :  $_id, password: $_password');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Pgplan Login'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  '피그플랜 로그인',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20.0),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '아이디',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ID를 입력해 주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '암호',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '암호를 입력해 주세요.';
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 30)),
                MaterialButton(
                  height: 40.0,
                  minWidth: 250.0,
                  color: Colors.blueAccent,
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }

                    _id = nameController.text;
                    _password = passwordController.text;

                    //var url = 'http://10.0.2.2:8080/mobile/mobileLogin.do?id='+_id+'&pw='+_password;
                    var parameters = '?id=' + _id + '&passwd=' + _password + '&loginLang=ko';
                    var url = 'http://192.168.3.46:8080/pigplan/into/lgin/loginchecked.do'+parameters;

                    var data = await restApiGetXml(url, parameters);

                    if (data == "200") {
                      //if(data.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dashboard()
                          ),
                      );
                    } else {
                      _showDialog(context);
                    }
                  },
                  child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Color(0xfffbfbfb),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> restApiGetXml(url, parameters) async {
  String _baseUrl = "http://192.168.3.46:8080";
  // String _baseUrl = "http://10.0.2.2:8080";

  final Xml2Json xml2Json = Xml2Json();
  final response = await http.get(Uri.parse(url));

  print(url);

  var jsonString = "";
  var statusCode = response.statusCode;

  xml2Json.parse(response.body);
  jsonString = xml2Json.toParker();


  print(jsonString);

  // 피그플랜 최초 로그인 api 호출시 계정이 틀릴경우 okcode값이 null 로 return
  if (jsonDecode(jsonString)['Map']['okcode'] != null) {
    // null이 아닐경우, return되는 url 호출
    if (statusCode == 200) {
      // jsonString = xml2Json.toParker();

      var decodeJson = json.decode(jsonString);
      print(decodeJson['Map']['loginViewName']);

      url = _baseUrl + decodeJson['Map']['loginViewName'] + parameters;
      final response = await http.get(Uri.parse(url));

      print('최종결과');
      print(url);

      RegExp sessionRegex = RegExp(r"SESSION=\b(.*)\b;", caseSensitive: false);

      //정규식으로 SESSION 값 추출
      var sessionValue = sessionRegex
          .stringMatch(response.headers['set-cookie'].toString().trim());

      print("피그플랜 cookie값 :: " + sessionValue!);

      // session에 pigplan에서 받아온 cookie값 등록
      var session = FlutterSession();
      await session.set("SESSION_ID", sessionValue);

      return statusCode.toString();
    } else {
      return statusCode.toString();
    }
  } else {
    return "false";
  }
}

// Dialog error
_showDialog(context) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(''),
      content: const Text('ID와 암호를 확인해 주세요.'),
      actions: <Widget>[
        FlatButton(
          child: const Text('확인'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
