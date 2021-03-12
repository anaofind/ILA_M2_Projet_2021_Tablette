import 'package:flutter/material.dart';
import 'package:flutter_app/model/UserData.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:sidenavbar/sidenavbar.dart';
import '../services/AccountService.dart';


class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);

  @override
  TestPageState createState() => TestPageState();
}


class TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text("Hello"),
      ),
    );
  }


}