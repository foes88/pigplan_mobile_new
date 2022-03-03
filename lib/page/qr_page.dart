import 'package:flutter/material.dart';
import 'package:pigplan_mobile/record/child_birth.dart';
import 'package:pigplan_mobile/record/matingrecord.dart';
import 'package:pigplan_mobile/record/pregnancy_accident_record.dart';
import 'package:pigplan_mobile/record/weaning_record.dart';
import 'package:pigplan_mobile/report/modon_card.dart';
import 'package:pigplan_mobile/report/modon_card_detail.dart';
import 'package:permission_handler/permission_handler.dart' show Permission, PermissionActions, PermissionGroup, PermissionHandler, PermissionStatus, openAppSettings;
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
// import 'package:qr_flutter/qr_flutter.dart' as scanner;
// import 'package:qrscan/qrscan.dart' as scanner;

class QrPage extends StatefulWidget {
  const QrPage({Key? key} ) : super(key: key);

  @override
  _QrPage createState() => _QrPage();
}

class _QrPage extends State<QrPage> {

  String _result = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('피그플랜'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 2,
          childAspectRatio: 6/2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          shrinkWrap: true,
          children: [

            Container(
              child: InkWell(
                child: const Text('QR모돈카드'),
                onTap: () {
                  // 권한 체크
                  callPermissions();
                  // rq scan
                  _scan('modoncard');


                  /*
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MatingRecord()
                      ),
                  );
                  */

                },

              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.grey[400],
            ),

            Container(
              child: InkWell(
                child: const Text('QR모돈입력'),
                onTap: () {
                  // 권한 체크
                  callPermissions();
                  // rq scan
                  _scan('childbirth');

                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),

            Container(
              child: InkWell(
                child: const Text('QR 교배기록입력'),
                onTap: () {
                  // 권한 체크
                  callPermissions();
                  // rq scan
                  _scan('mating');
                  
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.red[200],
            ),

            Container(
              child: InkWell(
                child: const Text('QR 임신사고기록입력'),
                onTap: () {
                  // 권한 체크
                  callPermissions();
                  // rq scan
                  _scan('pregnancy');
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[400],
            ),

            Container(
              child: InkWell(
                child: const Text('QR 분만기록입력'),
                onTap: () {
                  // 권한 체크
                  callPermissions();
                  // rq scan
                  _scan('childbirth');
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[200],
            ),

            Container(
              child: InkWell(
                child: const Text('QR 이유기록입력'),
                onTap: () {
                  // 권한 체크
                  callPermissions();
                  // rq scan
                  _scan('weaning');
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.deepPurpleAccent[200],
            ),
          ],
        ),
      ),
    );
  }

  Future _scan(String page) async {
    String? qrcode = "584"; // await scanner.scan();
    //String? qrcode = await scanner.scan();

    // qrcode = 590.toString();

    if(qrcode == null) {
      return;
    }

    //스캔 완료하면 _result 에 문자열을 저장.
    setState(() => _result = qrcode);

    print('scan 값');
    print(_result);

    // _showDialog(context,_result);

    int pPigNo = 0;

    // 페이지 분기
    if(page == "modoncard") {
      // pigNo를 받고 이동 -> 모돈카드
      if(_result.isNotEmpty) {
        pPigNo = int.parse(_result);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ModonCardDetail(pigNo: pPigNo)
            )
        );
      }

    } else if(page == "childbirth") {
      // pigNo를 받고 이동 -> 분만기록
      if(_result.isNotEmpty) {
        pPigNo = int.parse(_result);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChildBirth(pPigNo: pPigNo)
            )
        );
      }

    } else if(page == "mating") {
      // pigNo를 받고 이동 -> 교배기록
      if(_result.isNotEmpty) {
        pPigNo = int.parse(_result);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MatingRecord(pPigNo: pPigNo)
            )
        );
      }

    } else if(page == "pregnancy") {
      // pigNo를 받고 이동 -> 임신사고
      if(_result.isNotEmpty) {
        pPigNo = int.parse(_result);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PregnancyAccidentRecord(pPigNo: pPigNo)
            )
        );
      }

    } else if(page == "childbirth") {

      // pigNo를 받고 이동 -> 분만기록
      if(_result.isNotEmpty) {
        pPigNo = int.parse(_result);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChildBirth(pPigNo: pPigNo)
            )
        );
      }

    } else if(page == "weaning") {
      // pigNo를 받고 이동 -> 이유기록
      if(_result.isNotEmpty) {
        pPigNo = int.parse(_result);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Weaning(pPigNo: pPigNo)
            )
        );
      }

    }

  }

  Future<bool> callPermissions() async {
    PermissionStatus status = await Permission.camera.request();

    if(!status.isGranted) { // 허용이 안된 경우
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


}
