import 'package:flutter/material.dart';

class QuickMenu extends StatefulWidget {
  const QuickMenu({Key? key}) : super(key: key);
  @override
  _QuickMenu createState() => _QuickMenu();
}

class _QuickMenu extends State<QuickMenu> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Text('Qr scan',)
        ],
      ),
    );

  }




}