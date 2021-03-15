import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:sidenavbar/sidenavbar.dart';
import '../services/AccountService.dart';
import 'package:flutter/material.dart';


class SitacPage extends StatefulWidget {
  //SitacPage({Key key}) : super(key: key);

  Intervention intervention;
  SitacPage(Intervention uneInter) {
    intervention = uneInter;
  }

  @override
  SitacPageState createState() => SitacPageState(intervention);
}

class SitacPageState extends State<SitacPage> {
  AccountService authService = AccountService();
  bool isCollapsed = false;

  Intervention _monIntervention;

  SitacPageState(Intervention uneI) {
  _monIntervention = uneI;
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
            title: Text('SITAC ' + '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
                '' +  _monIntervention.getDate.toString() +
                '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' + _monIntervention.getNom +
                '\n\t\t\t\t\t\t\t\t\t\t\t\t' + '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
                '' + _monIntervention.getAdresse),
            backgroundColor: Colors.red,
          ),

          body: Column(
            children: [
              Expanded(
                child: Row(
                  children:  <Widget>[
                    Flexible(
                      flex: 1,
                      child: TabBarView(
                        children: [
                          ListView(
                            //scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/FPT_Unique_Encours.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/FPT_Unique_Prevue.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Rouge_Encours.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Rouge_Prevue.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Vert_Encours.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Vert_Prevue.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/VSAV_Unique_Encours.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/VSAV_Unique_Prevue.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                  children: [
                                    Image(
                                      image: new AssetImage('Icone_Png/PosteCommandement_Seul_Encours.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                    Image(
                                      image: new AssetImage('Icone_Png/PosteCommandement_Seul_Prevue.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ]
                              ),

                            ],
                          ),
                          ListView(
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/CibleAction_Incendie.png' ),
                                    width: 100,
                                    height: 100,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/CibleAction_Civil.png' ),
                                    width: 100,
                                    height: 100,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/CibleAction_Eau.png'),
                                    width: 100,
                                    height: 100,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/CibleAction_Particulier.png'),
                                    width: 100,
                                    height: 100,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ListView(
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/Danger_Incendie.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/PointSensible_Incendie.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/Danger_Civil.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/PointSensible_Civil.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/Danger_Eau.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/PointSensible_Eau.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/Danger_Particulier.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/PointSensible_Particulier.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ListView(
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/PointEau_Perienne.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/PointEau_NonPerienne.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/PointEau_Ravitaillement.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ListView(
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Defense_Incendie_Encours.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Defense_Incendie_Prevue.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Defense_Civil_Encours.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Defense_Civil_Prevue.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Defense_Eau_Encours.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Defense_Eau_Prevue.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Defense_Particulier_Encours.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Defense_Particulier_Prevue.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Incendie_Encours.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Incendie_Prevue.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Civil_Encours.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Civil_Prevue.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Eau_Encours.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Eau_Prevue.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Particulier_Encours.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/Perimetrale_Particulier_Prevue.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          ListView(
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/Chemin_Encours.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/Chemin_Prevue.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
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
                    ),
                    Flexible(
                      flex: 4,
                      child: Image(
                        image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                        width: 50,
                        height: 50,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),


        ),
      ),
    );
  }

}

