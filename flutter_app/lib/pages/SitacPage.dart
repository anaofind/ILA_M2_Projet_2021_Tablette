import 'package:flutter/material.dart';
import 'package:flutter_app/model/UserData.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:sidenavbar/sidenavbar.dart';
import '../services/AccountService.dart';
import 'TestPage.dart';
import 'package:flutter/material.dart';


class SitacPage extends StatefulWidget {
  SitacPage({Key key}) : super(key: key);

  @override
  SitacPageState createState() => SitacPageState();
}

class SitacPageState extends State<SitacPage> {
  AccountService authService = AccountService();

  List<String> list1 = ["Test1","Test2","Test3"];
  List<String> list2 = ["Rest","Rest2","Rest3"];

  Widget currentItem = TestPage();
  List<String> currentList = ["Test1","Test2","Test3"];
  bool isCollapsed = false;

  void show(List<String>  list) {
    setState(() {
      currentList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.crop_square)),
                Tab(icon: Icon(Icons.arrow_forward_ios)),
                Tab(icon: Icon(Icons.error)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    height: 50,
                    child: const Center(child: Text('Entry A')),
                  ),
                  Container(
                    height: 50,
                    child: const Center(child: Text('Entry B')),
                  ),
                  Container(
                    height: 50,
                    child: const Center(child: Text('Entry C')),
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    height: 50,
                    child: const Center(child: Text('Entry A')),
                  ),
                  Container(
                    height: 50,
                    child: const Center(child: Text('Entry B')),
                  ),
                  Container(
                    height: 50,
                    child: const Center(child: Text('Entry C')),
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    height: 50,
                    child:  const Center(child: Text('Entry C')),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                          // Load image from assets
                            image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                            // Make the image cover the whole area
                            fit: BoxFit.cover)),
                    ),

                  Container(
                    height: 50,
                    child: const Center(child: Text('Entry C')),
                  ),
                ],
              ),
            ],
          ),

        ),
      ),
    );
  }

}

