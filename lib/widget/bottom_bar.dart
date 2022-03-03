import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: const SizedBox(
          height: 55,
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(icon: Icon(Icons.home, size: 23,),
                  child: Text('홈', style: TextStyle(fontSize: 13,))
              ),
              Tab(icon: Icon(Icons.menu, size: 23,),
                  child: Text('퀵메뉴', style: TextStyle(fontSize: 13,))
              ),
              Tab(icon: Icon(Icons.qr_code, size: 23,),
                  child: Text('QR', style: TextStyle(fontSize: 13,))
              ),
              Tab(icon: Icon(Icons.person, size: 23,),
                  child: Text('마이페이지', style: TextStyle(fontSize: 13,))
              ),
            ],
          ),
      ),
    );
  }
}