import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pigplan_mobile/model/profile_model.dart';
import 'package:pigplan_mobile/mypage/notice.dart';

import '../main.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPage createState() => _MyPage();
}

class _MyPage extends State<MyPage> {
  static final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  List<Profile> profiles = [
    Profile.fromMap({'name': 'test', 'image': 'profile_1.PNG'})
  ];

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
        body: ListView(
          children: <Widget>[
            Column(
              children: const <Widget>[
                // ProfileSlider(profiles: profiles,),
                // OutlinedButton(onPressed: () {}, child: Text('프로필 관리')),
              ],
            ),
            /*
            const ListTile(
              //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
              leading: Icon(Icons.person),
              title: Text('프로필 설정'),
            ),
            const ListTile(
              //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
              leading: Icon(Icons.air_outlined),
              title: Text('농장환경정보 설정'),
            ),
            */
            const ListTile(
              //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
              leading: Icon(Icons.perm_identity_rounded),
              title: Text('계정'),
            ),
            ListTile(
              //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
              leading: const Icon(Icons.notification_important),
              title: const Text('공지사항'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Notice(),
                    settings: const RouteSettings(arguments: "")
                  )
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('로그아웃'),
              onTap: () => logOut(),
            ),
          ],
        ),
      ),
    );
  }

  // 로그아웃
  logOut() async {
    storage.delete(key: 'login');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Login())
    );
  }

}
