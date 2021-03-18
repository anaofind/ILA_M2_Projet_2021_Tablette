import 'dart:developer';

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

  ListView test(){

    for(int i=0; i<_monIntervention.getMoyens.length; i++){
      log(_monIntervention.getMoyens[i].id);
    }

    return ListView.builder(
      itemCount: _monIntervention.getMoyens.length,
      itemBuilder: (context, index){
        return Container(
          child: new Text('Icone_Png/'+'${_monIntervention.getMoyens[index].toString()}'+"/"+'${_monIntervention.getMoyens[index].couleur}'"/"+'${_monIntervention.getMoyens[index].etat}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Basic.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Danger/S_Action_Noir_1.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Danger/S_Danger_Noir_1.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/PointEau.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Noir_0.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Chemin/S_Fleche_Noir_1.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure/Aerien/M_Aerien_Noir_1.png'),)),
                Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure/Moyen.png'),)),
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
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Noir_1.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Noir_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_1.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Orange_1.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Orange_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Vert_1.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Vert_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Bleu_1.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Bleu_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Violet_1.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Violet_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Noir_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Noir_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Rouge_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Rouge_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Orange_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Orange_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Vert_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Vert_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Bleu_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Bleu_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Violet_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Violet_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Noir_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Noir_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Rouge_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Rouge_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Orange_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Orange_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Vert_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Vert_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Bleu_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Bleu_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Violet_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Violet_0.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                  children: [
                                    Image(
                                      image: new AssetImage('Icone_Png/S_Poste_Violet_1.png'),
                                      width: 90,
                                      height: 90,
                                    ),
                                    Image(
                                      image: new AssetImage('Icone_Png/S_Poste_Violet_0.png'),
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
                                    image: new AssetImage('Icone_Png/Danger/S_Action_Rouge_1.png' ),
                                    width: 100,
                                    height: 100,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_Action_Vert_1.png' ),
                                    width: 100,
                                    height: 100,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_Action_Bleu_1.png'),
                                    width: 100,
                                    height: 100,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_Action_Orange_1.png'),
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
                                    image: new AssetImage('Icone_Png/Danger/S_Danger_Rouge_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_PointSensible_Rouge_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_Danger_Vert_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_PointSensible_Vert_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_Danger_Bleu_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_PointSensible_Bleu_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_Danger_Orange_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Danger/S_PointSensible_Orange_1.png'),
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
                                    image: new AssetImage('Icone_Png/S_Perienne_Bleu_1.png' ),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/S_NonPerienne_Bleu_1.png'),
                                    width: 90,
                                    height: 90,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/S_Ravitaillement_Bleu_1.png'),
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
                                    image: new AssetImage('Icone_Png/Defense/S_Defense_Rouge_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Defense_Rouge_0.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Defense_Vert_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Defense_Vert_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Defense_Bleu_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Defense_Bleu_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Defense_Orange_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Defense_Orange_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Rouge_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Rouge_0.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Vert_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Vert_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Bleu_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Bleu_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Orange_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Orange_1.png'),
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
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Noir_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Noir_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Noir_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Noir_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Rouge_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Rouge_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Rouge_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Rouge_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Orange_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Orange_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Orange_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Orange_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Vert_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Vert_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Vert_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Vert_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Bleu_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Bleu_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Bleu_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Bleu_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Violet_1.png' ),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Chemin_Violet_0.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Violet_1.png'),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Image(
                                    image: new AssetImage('Icone_Png/Chemin/S_Fleche_Violet_0.png'),
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
                              Image(
                                image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png' ),
                                width: 100,
                                height: 100,
                              ),
                              Image(
                                image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png'),
                                width: 100,
                                height: 100,
                              ),

                              Image(
                                image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png'),
                                width: 100,
                                height: 100,
                              ),
                            ],
                          ),

                          // MOYEN demandé à partir d'infrastructure

                          ListView.builder(
                            itemCount: _monIntervention.getMoyens.length,
                            itemBuilder: (context, index){
                              return Image(
                                image: new AssetImage('Icone_Png/Infrastructure/Vehicule/'+'${_monIntervention.getMoyens[index].moyen.id}'+"/M_"+'${_monIntervention.getMoyens[index].moyen.id}'+"_"+'${_monIntervention.getMoyens[index].moyen.couleurDefaut}'"_"+'${_monIntervention.getMoyens[index].etat}'+".png"),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Image(
                        image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png'),
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

