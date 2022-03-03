import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pigplan_mobile/dashboard.dart';
import 'package:pigplan_mobile/page/home_page.dart';
import 'package:pigplan_mobile/page/login_page.dart';
import 'package:pigplan_mobile/api_call.dart';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/page/my_page.dart';
import 'package:pigplan_mobile/page/qr_page.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/widget/bottom_bar.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart' show Permission, PermissionActions, PermissionGroup, PermissionHandler, PermissionListActions, PermissionStatus, openAppSettings;
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main(List<String> args) async {

  //개발, 운영 설정파일
  await dotenv.load(fileName: "assets/.env");

  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // calendar 한글화
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {

  // id, 암호 저장
  var _isChecked = false;

  // 사용자 정보 저장
  String userInfo = "";
  static const storage = FlutterSecureStorage();

  final formKey = GlobalKey<FormState>();

  String _id = '';
  String _password = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });

    // 권한 얻기
    callPermissions();
  }

  // 계정정보 얻기
  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)

    if(await storage.read(key: "login") == null) {
      return;
    }

    userInfo = (await storage.read(key: "login"))!;

    print("사용자 정보 출력");
    print(userInfo);

    //user의 정보가 있다면 바로 로그아웃 페이지로 넘어가게 합니다.
    if (userInfo != null) {

      nameController.text = userInfo.split(" ")[1];
      passwordController.text = userInfo.split(" ")[3];
      print('test');
      print(userInfo.split(" ")[5] == "true");
      if(userInfo.split(" ")[5] == "true") {
        _isChecked = true;
      }

      /*
      Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (context) => const Dashboard()
          )
      );
      */

    }
  }

  Future<bool> _onWillPop() async {
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
            onPressed: () => SystemNavigator.pop(),
            child: const Text('예'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('피그플랜'),
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ID를 입력해 주세요.';
                        } else {
                          return '';
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
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '암호를 입력해 주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  CheckboxListTile(
                    title: const Text('계정 정보 저장'),
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        _isChecked = value!;
                      });
                    },
                    // secondary: const Icon(Icons.home),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blueAccent,
                    checkColor: Colors.white,
                    isThreeLine: false,
                  ),
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

                      var parameters = '?id=' +
                          _id +
                          '&passwd=' +
                          _password +
                          '&loginLang=ko';
                      var url =
                          'http://192.168.3.46:8080/pigplan/into/lgin/loginchecked.do' +
                              parameters;

                      var data = await restApiGetXml(url, parameters);

                      if (data == "200") {
                        //if(data.isNotEmpty) {

                        // toast bar 삭제
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        // 계정 정보 저정일 경우, sotrage 저장
                        if(_isChecked) {
                          await storage.write(
                            key: 'login',
                            value: "id " + _id + " " + "password " + _password + " " + "check " + _isChecked.toString(),
                          );
                        } else {
                          await storage.write(
                            key: 'login',
                            value: "id " + " " + "password " + " " + "check " + _isChecked.toString(),
                          );
                        }

                        // 페이지 이동
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Dashboard()
                            )
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
      ),
    );
  }

  Future<bool> callPermissions() async {
    // PermissionStatus status = await Permission.camera.request();

    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
    ].request();

    bool rst = true;

    //권한 요청



    statuses.forEach((permission, PermissionStatus) {

      if (!PermissionStatus.isGranted) {
        rst = false;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("권한 설정을 확인해주세요."),
                actions: [
                  FlatButton(
                      onPressed: () {
                        openAppSettings(); // 앱 설정으로 이동
                      },
                      child: const Text('설정하기')),
                ],
              );
            }
        );
      }
    });

    return rst;

    /*
    if(!statuses.values.every((element) => element.isGranted)) { // 허용이 안된 경우
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("권한 설정을 확인해주세요."),
              actions: [
                FlatButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: const Text('설정하기')),
              ],
            );
          });
      return false;
    }
    return true;
    */

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

      print(response.body);
      print(response.headers);

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
