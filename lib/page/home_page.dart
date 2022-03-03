import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pigplan_mobile/home/daily_report.dart';
import 'package:pigplan_mobile/home/grade_graph.dart';
import 'package:pigplan_mobile/home/iot_page.dart';
import 'package:pigplan_mobile/home/pig_info.dart';

import 'package:pigplan_mobile/page/my_page.dart';
import 'package:pigplan_mobile/page/qr_page.dart';
import 'package:pigplan_mobile/page/quick_page.dart';
import 'package:pigplan_mobile/widget/bottom_bar.dart';

import 'package:pigplan_mobile/home/daily_report.dart';
import 'package:pigplan_mobile/home/grade_graph.dart';
import 'package:pigplan_mobile/home/iot_page.dart';
import 'package:pigplan_mobile/home/pig_info.dart';
import 'package:pigplan_mobile/home/quick_menu.dart';

import '../main.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 4,
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
            // automaticallyImplyLeading: false,
            centerTitle: true,
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                SizedBox(
                  width: 30,
                  child: Tab(text: "일보"),
                ),
                SizedBox(
                  width: 30,
                  child: Tab(text: "IOT"),
                ),
                SizedBox(
                  width: 65,
                  child: Tab(text: "성적그래프"),
                ),
                SizedBox(
                  width: 55,
                  child: Tab(text: "양돈정보"),
                ),
                /*
                SizedBox(
                  width: 40,
                  child: Tab(text: "퀵메뉴"),
                ),
                */
              ],
            ),
          ),
          body: const TabBarView(
          children: [
            DailyReport(),
            IotPage(),
            GradeGraph(),
            PigInfo(),
            // QuickMenu(),
          ],
        ),
     ),
    );





}