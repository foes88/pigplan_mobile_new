import 'dart:developer';

import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:pigplan_mobile/page/home_page.dart';
import 'package:pigplan_mobile/page/my_page.dart';
import 'package:pigplan_mobile/page/qr_page.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:pigplan_mobile/widget/bottom_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController controller;
  @override
  void initState() {
    super.initState();

    controller = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      allowFontScaling: false,
      builder: () => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: const Scaffold(
          body: DefaultTabController(
            length: 4,
            initialIndex: 1,
            child: Scaffold(
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                // 사용자가 직접 손가락 모션을 통해 탭을 움직이지 않도록
                children: [
                  HomePage(),
                  QuickPage(),
                  QrPage(),
                  MyPage(),
                ],
              ),
              bottomNavigationBar: BottomBar(),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('PigPlan'),
        ),
        bottomNavigationBar: const BottomBar(),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(

                  // 컨테이너 내부 상하좌우에 32픽셀만큼의 패딩 삽입
                  padding: const EdgeInsets.all(32),
                  // 자식으로 로우를 추가
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // 로우에 위젯들(Expanded, Icon, Text)을 자식들로 추가
                    children: <Widget>[
                      const Text("농가 위험 현황", textAlign: TextAlign.start),

                      OutlinedButton(onPressed: () {}, child: Text('대시보드')),

                    ],
                  ),
                ),
                SfCartesianChart(),
                //environmentSection,
                //reportSection
              ],
              ),
          ],
        )
    );
  }

  final List _widgetOptions = [
    const Text(
      'Favorites',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
    const Text(
      'Music',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
    const Text(
      'Places',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
    const Text(
      'News',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
  ];

  Widget monitoringSection = Container(
    // 컨테이너 내부 상하좌우에 32픽셀만큼의 패딩 삽입
    padding: const EdgeInsets.all(32),
    // 자식으로 로우를 추가
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // 로우에 위젯들(Expanded, Icon, Text)을 자식들로 추가
      children: <Widget>[
        const Text("농가 현황", textAlign: TextAlign.start),
        OutlinedButton(onPressed: () {
        }, child: Text('위험탐지  17건>')),
        OutlinedButton(onPressed: () {}, child: Text('질병탐지  13건>')),
        OutlinedButton(onPressed: () {}, child: Text('환경이상탐지  2건>')),
      ],
    ),
  );

  Widget environmentSection = Container(
    // 컨테이너 내부 상하좌우에 32픽셀만큼의 패딩 삽입
    padding: const EdgeInsets.all(32),
    // 자식으로 로우를 추가
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // 로우에 위젯들(Expanded, Icon, Text)을 자식들로 추가
      children: <Widget>[
        Text("돈사-1 환경정보", textAlign: TextAlign.start),
        //Graph()
      ],
    ),
  );

  Widget reportSection = Container(
    // 컨테이너 내부 상하좌우에 32픽셀만큼의 패딩 삽입
    padding: const EdgeInsets.all(32),
    // 자식으로 로우를 추가
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // 로우에 위젯들(Expanded, Icon, Text)을 자식들로 추가
      children: <Widget>[
        Text("새로운 리포트", textAlign: TextAlign.start),
        OutlinedButton(onPressed: () {}, child: Text('8월 1주차 리포트>')),
      ],
    ),
  );
}



