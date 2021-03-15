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
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure_Basic.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Danger/CibleAction_Basic.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Danger/Danger_Basic.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/PointEau.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Defense/Perimetrale_Basic_Prevue.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Chemin/Chemin_Encours.png'),)),
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
                        image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/FPT_Unique_Encours.png' ),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/FPT_Unique_Prevue.png'),
                        width: 100,
                        height: 100,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Rouge_Encours.png'),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Rouge_Prevue.png'),
                        width: 100,
                        height: 100,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Vert_Encours.png'),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Vert_Prevue.png'),
                        width: 100,
                        height: 100,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/VSAV_Unique_Encours.png'),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/VSAV_Unique_Prevue.png'),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/PosteCommandement_Seul_Encours.png'),
                        width: 75,
                        height: 75,
                      ),
                    ],
                  ),
                  ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Image(
                        image: new AssetImage('Icone_Png/Danger/CibleAction_Incendie.png' ),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Danger/CibleAction_Civil.png' ),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Danger/CibleAction_Eau.png'),
                        width: 100,
                        height: 100,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Danger/CibleAction_Particulier.png'),
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Image(
                        image: new AssetImage('Icone_Png/Danger/Danger_Incendie.png' ),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Danger/Danger_Civil.png'),
                        width: 100,
                        height: 100,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Danger/Danger_Eau.png'),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Danger/Danger_Particulier.png'),
                        width: 100,
                        height: 100,
                      ),

                      //Point Sensible
                      Image(
                        image: new AssetImage('Icone_Png/Danger/PointSensible_Incendie.png' ),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Danger/PointSensible_Civil.png'),
                        width: 100,
                        height: 100,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/Danger/PointSensible_Eau.png'),
                        width: 100,
                        height: 100,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/Danger/PointSensible_Particulier.png'),
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Image(
                        image: new AssetImage('Icone_Png/PointEau_Perienne.png' ),
                        width: 75,
                        height: 75,
                      ),
                      Image(
                        image: new AssetImage('Icone_Png/PointEau_NonPerienne.png'),
                        width: 75,
                        height: 75,
                      ),

                      Image(
                        image: new AssetImage('Icone_Png/PointEau_Ravitaillement.png'),
                        width: 75,
                        height: 75,
                      ),
                    ],
                  ),
              ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Image(
                    image: new AssetImage('Icone_Png/Defense/Defense_Incendie_Encours.png' ),
                    width: 100,
                    height: 100,
                  ),

                  Image(
                    image: new AssetImage('Icone_Png/Defense/Defense_Civil_Encours.png'),
                    width: 100,
                    height: 100,
                  ),
                  Image(
                    image: new AssetImage('Icone_Png/Defense/Defense_Eau_Encours.png'),
                    width: 100,
                    height: 100,
                  ),
                  Image(
                    image: new AssetImage('Icone_Png/Defense/Defense_Particulier_Encours.png'),
                    width: 100,
                    height: 100,
                  ),
                  //Perimetrale
                  Image(
                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Incendie_Encours.png' ),
                    width: 100,
                    height: 100,
                  ),
                  Image(
                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Civil_Encours.png'),
                    width: 100,
                    height: 100,
                  ),
                  Image(
                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Eau_Encours.png'),
                    width: 100,
                    height: 100,
                  ),
                  Image(
                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Particulier_Encours.png'),
                    width: 100,
                    height: 100,
                  ),
                ],
              ),

                  ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Image(
                        image: new AssetImage('Icone_Png/Chemin/Chemin_Encours.png' ),
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 10),
                      Image(
                        image: new AssetImage('Icone_Png/Chemin/Chemin_Prevue.png'),
                        width: 100,
                        height: 100,
                      ),

                    ],
                  ),

              ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png' ),
                    width: 100,
                    height: 100,
                  ),
                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                    width: 100,
                    height: 100,
                  ),

                  Image(
                    image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                    width: 100,
                    height: 100,
                  ),
                ],
              ),


            ],
          ),
              Positioned(
                bottom: 0,
                child: Image(
                  image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                  width: 50,
                  height: 50,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}

