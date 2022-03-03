import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pigplan_mobile/dashboard.dart';
import 'package:pigplan_mobile/model/menu_model.dart';
import 'package:pigplan_mobile/record/child_birth.dart';

import 'package:pigplan_mobile/record/matingrecord.dart';
import 'package:pigplan_mobile/record/md_died_sell.dart';
import 'package:pigplan_mobile/record/md_movein.dart';
import 'package:pigplan_mobile/record/poyou_jadon_died.dart';
import 'package:pigplan_mobile/record/pregnancy_accident_record.dart';
import 'package:pigplan_mobile/record/ud_movein.dart';
import 'package:pigplan_mobile/record/weaning_record.dart';
import 'package:pigplan_mobile/report/modon_card.dart';
import 'package:pigplan_mobile/widget/bottom_bar.dart';

import '../main.dart';

class QuickPage extends StatefulWidget {
  const QuickPage({Key? key}) : super(key: key);

  @override
  _QuickPage createState() => _QuickPage();
}

class _QuickPage extends State<QuickPage> with TickerProviderStateMixin {

  late TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: 4);
  }

  // final JavascriptRuntime jsRuntime = getJavascriptRuntime();

  // 모바일 메뉴 정의(추후 db에서 조회)
  final menu = {
    "record": [
      {"name": "교배기록"},
      {"name": "임신 사고기록"},
      {"name": "분만기록"},
      {"name": "이유기록"},
      {"name": "포유자돈폐사기록"},
      {"name": "도폐사기록"},
      {"name": "모돈전입기록"},
      {"name": "웅돈전입기록"},
    ],
    "report": [
      {"name":"모돈카드"},
      {"name":"작업대장"},
      {"name":"작업예정돈"},
      {"name":"관리대상돈"},
      {"name":"예정작업표"},
      {"name":"종합일보"},
    ],
  };

  MenuModel? menuList;

  @override
  Widget build(BuildContext context) {

    // 메뉴 리스트 생성
    menuList = MenuModel.fromJson(menu);

    return GestureDetector(
      onTap: () {
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
                    builder: (context) => const Login())
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 3,
          childAspectRatio: 7/2,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          shrinkWrap: true,

          children: [
            const SizedBox(height: 2),
            Container(
              alignment: Alignment.center,
              child: const SizedBox(
                child: Text('기록'),
              ),
            ),
            const SizedBox(height: 2),

            Container(
              child: InkWell(
                child: const Text('교배기록'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MatingRecord(pPigNo: 0,)
                      )
                  );
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),
            Container(
              child: InkWell(
                child: const Text('임신 사고기록'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PregnancyAccidentRecord(pPigNo: 0,))
                  );
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[200],
            ),
            Container(
              child: InkWell(
                child: const Text('분만기록'),
                onTap: () {
                  int pPigNo = 0;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChildBirth(
                            pPigNo :pPigNo,
                          ),
                      ));
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.cyanAccent[400],
            ),
            Container(
              child: InkWell(
                child: const Text('이유기록'),
                onTap: () {
                  int pPigNo = 0;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Weaning(
                        pPigNo :pPigNo,

                      )));
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[400],
            ),
            Container(
              child: InkWell(
                child: const Text('포유자돈폐사기록'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PoyouJadonDied()));
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[700],
            ),
            Container(
              child: InkWell(
                child: const Text('도폐사기록'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MdDiedSell()));
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[700],
            ),
            Container(
              child: InkWell(
                child: const Text('모돈전입기록'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Mdmovein())
                  );
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.lightBlue[900],
            ),
            Container(
              child: InkWell(
                child: const Text('웅돈전입기록'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Udmovein()));
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.lightBlue[900],
            ),

            const SizedBox(height: 2),

            const SizedBox(height: 2),
            Container(
              alignment: Alignment.center,
              child: const SizedBox(
                child: Text('모돈보고서'),
              ),
            ),
            const SizedBox(height: 2),

            Container(
              child: InkWell(
                child: const Text('모돈카드'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ModonCard())
                  );
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),
            Container(
              child: InkWell(
                child: const Text('작업대장'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PoyouJadonDied())
                  );
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),
            Container(
              child: InkWell(
                child: const Text('작업예정돈'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PoyouJadonDied())
                  );
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),
            Container(
              child: InkWell(
                child: const Text('관리대상돈'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PoyouJadonDied())
                  );
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),
            Container(
              child: InkWell(
                child: const Text('예정작업표'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PoyouJadonDied())
                  );
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),
            Container(
              child: InkWell(
                child: const Text('종합일보'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PoyouJadonDied()
                      )
                  );
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),
            // DefaultTabController(length: length, child: child)
          ],
          
        ),



/*
      Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            RaisedButton(
              textColor: Colors.blue,
              child: const Text('교배기록'),
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const MatingRecord())
                );
              },
            ),
            RaisedButton(
              textColor: Colors.blue,
              child: const Text('임신 사고기록'),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PregnancyAccidentRecord())
                );
              },
            ),
            RaisedButton(
              textColor: Colors.blue,
              child: const Text('분만기록'),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PregnancyAccidentRecord())
                );

              },
            ),
            RaisedButton(
              textColor: Colors.blue,
              child: const Text('이유기록'),
              onPressed: (){

                //final jsResult = jsRuntime.evaluate();


                Navigator.push(context, MaterialPageRoute(builder: (context) => const PregnancyAccidentRecord())


                );

              },
            ),
          ],
        ),
      ),
      */
      ),
    );
  }

}
/*

Future<void> addFromJs(JavascriptRuntime jsRuntime) async {

  String blocJs = await rootBundle.loadString("assets/crownix-viewer.min.js");

  final jsResult = jsRuntime.evaluate(blocJs + "");
}*/
