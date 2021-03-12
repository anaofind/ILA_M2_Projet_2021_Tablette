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
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Danger/CibleAction_Basic.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Danger/Danger_Basic.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/PointEau_Perienne.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Défense/Perimetrale_Basic_Encours.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),)),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: Stack(
            children: <Widget>[
              TabBarView(
                children: [
                  ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png' ),
                        width: 50,
                        height: 50,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png' ),
                        width: 50,
                        height: 50,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png' ),
                        width: 50,
                        height: 50,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png' ),
                        width: 50,
                        height: 50,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
              ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png' ),
                    width: 50,
                    height: 50,
                  ),
                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                    width: 50,
                    height: 50,
                  ),

                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
              ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png' ),
                    width: 50,
                    height: 50,
                  ),
                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                    width: 50,
                    height: 50,
                  ),

                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
              Image(
                image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

}

