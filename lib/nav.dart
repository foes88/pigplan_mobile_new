import 'package:flutter/material.dart';
import 'package:pigplan_mobile/record/matingrecord.dart';
import 'package:pigplan_mobile/record/poyou_jadon_died.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              '메뉴',
              style: TextStyle(color: Colors.white, fontSize: 20),

            ),
            decoration: BoxDecoration(
                color: Colors.lightBlueAccent,

                ),
          ),
          ExpansionTile(leading: const Icon(Icons.verified_user),title: const Text("기록"),
            children: <Widget> [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 50),
                leading: const Icon(Icons.verified_user),
                title: const Text('임신사고기록'),
                onTap: () => {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => PoyouJadonDied())
                  )
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(left: 50),
                leading: const Icon(Icons.verified_user),
                title: const Text(' 교배기록'),
                onTap: () => {Navigator.of(context).pop()},
              ),
              ]
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('모돈보고서'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}