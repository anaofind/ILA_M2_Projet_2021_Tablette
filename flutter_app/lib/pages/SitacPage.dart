import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/pages/MapPage.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/services/SelectorMoyenSymbol.dart';
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
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'FPT_Unique_Encours';
                                      SelectorMoyenSymbol.type = 'moyen';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/FPT_Unique_Encours.png' ),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'FPT_Unique_Prevue';
                                      SelectorMoyenSymbol.type = 'moyen';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/FPT_Unique_Prevue.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'VLGC_Unique_Rouge_Encours';
                                      SelectorMoyenSymbol.type = 'moyen';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Rouge_Encours.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'VLGC_Unique_Rouge_Prevue';
                                      SelectorMoyenSymbol.type = 'moyen';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Rouge_Prevue.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'VLGC_Unique_Vert_Encours';
                                      SelectorMoyenSymbol.type = 'moyen';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Vert_Encours.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'VLGC_Unique_Vert_Prevue';
                                      SelectorMoyenSymbol.type = 'moyen';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Vert_Prevue.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'VSAV_Unique_Encours';
                                      SelectorMoyenSymbol.type = 'moyen';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/VSAV_Unique_Encours.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'VSAV_Unique_Prevue';
                                      SelectorMoyenSymbol.type = 'moyen';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/VSAV_Unique_Prevue.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        SelectorMoyenSymbol.name = 'PosteCommandement_Seul_Encours';
                                        SelectorMoyenSymbol.type = 'symbol';
                                      },
                                      child: Image(
                                        image: new AssetImage('Icone_Png/PosteCommandement_Seul_Encours.png'),
                                        width: 90,
                                        height: 90,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        SelectorMoyenSymbol.name = 'PosteCommandement_Seul_Prevue';
                                        SelectorMoyenSymbol.type = 'symbol';
                                      },
                                      child: Image(
                                        image: new AssetImage('Icone_Png/PosteCommandement_Seul_Prevue.png'),
                                        width: 90,
                                        height: 90,
                                      ),
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
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Cible_Action_Incendie';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/CibleAction_Incendie.png' ),
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Cible_Action_Civil';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/CibleAction_Civil.png' ),
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Cible_Action_Eau';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/CibleAction_Eau.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Cible_Action_Particulier';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/CibleAction_Particulier.png'),
                                      width: 100,
                                      height: 100,
                                    ),
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
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Danger_Incendie';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/Danger_Incendie.png' ),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'PointSensible_Incendie';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/PointSensible_Incendie.png' ),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Danger_Civil';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/Danger_Civil.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'PointSensible_Civil';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/PointSensible_Civil.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Danger_Eau';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/Danger_Eau.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'PointSensible_Eau';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/PointSensible_Eau.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Danger_Particulier';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/Danger_Particulier.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'PointSensible_Particulier';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Danger/PointSensible_Particulier.png'),
                                      width: 80,
                                      height: 80,
                                    ),
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
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'PointEau_Perienne';
                                      SelectorMoyenSymbol.type = 'symbol';

                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/PointEau_Perienne.png' ),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'PointEau_NonPerienne';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/PointEau_NonPerienne.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'PointEau_Ravitaillement';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/PointEau_Ravitaillement.png'),
                                      width: 90,
                                      height: 90,
                                    ),
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
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Defense_Incendie_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Defense_Incendie_Encours.png' ),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Defense_Incendie_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Defense_Incendie_Prevue.png' ),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Defense_Civil_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Defense_Civil_Encours.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Defense_Civil_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Defense_Civil_Prevue.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Defense_Eau_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Defense_Eau_Encours.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Defense_Eau_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Defense_Eau_Prevue.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Defense_Particulier_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Defense_Particulier_Encours.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Defense_Particulier_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Defense_Particulier_Prevue.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Perimetrale_Incendie_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Perimetrale_Incendie_Encours.png' ),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Perimetrale_Incendie_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Perimetrale_Incendie_Prevue.png' ),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Perimetrale_Civil_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Perimetrale_Civil_Encours.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Perimetrale_Civil_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Perimetrale_Civil_Prevue.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Perimetrale_Eau_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Perimetrale_Eau_Encours.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Perimetrale_Eau_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Perimetrale_Eau_Prevue.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Perimetrale_Particulier_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Perimetrale_Particulier_Encours.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Perimetrale_Particulier_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Defense/Perimetrale_Particulier_Prevue.png'),
                                      width: 80,
                                      height: 80,
                                    ),
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
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Chemin_Encours';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Chemin/Chemin_Encours.png' ),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SelectorMoyenSymbol.name = 'Chemin_Prevue';
                                      SelectorMoyenSymbol.type = 'symbol';
                                    },
                                    child: Image(
                                      image: new AssetImage('Icone_Png/Chemin/Chemin_Prevue.png'),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8),
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  SelectorMoyenSymbol.name = 'Infrastructure_Civil_EnCours';
                                  SelectorMoyenSymbol.type = 'symbol';
                                },
                                child: Image(
                                  image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png' ),
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  SelectorMoyenSymbol.name = 'Infrastructure_Civil_EnCours';
                                  SelectorMoyenSymbol.type = 'symbol';
                                },
                                child: Image(
                                  image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                                  width: 100,
                                  height: 100,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  SelectorMoyenSymbol.name = 'Infrastructure_Civil_EnCours';
                                  SelectorMoyenSymbol.type = 'symbol';
                                },
                                child: Image(
                                  image: new AssetImage('Icone_Png/Infrastructure_Civil_EnCours.png'),
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: MapPage(
                          intervention: this._monIntervention
                      )
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

