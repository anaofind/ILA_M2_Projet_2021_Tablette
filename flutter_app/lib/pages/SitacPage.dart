import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/pages/MapPage.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/NavigatorPage.dart';
import 'package:flutter_app/services/SelectorMoyenSymbol.dart';
import 'package:intl/intl.dart';


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
    return StreamBuilder<DocumentSnapshot>(
        stream: InterventionService().getInterventionById(_monIntervention.id),
        builder: (context, snapshot) {
          if (! snapshot.hasData) {
            return Center (
              child: CircularProgressIndicator(),
            );
          }
          if (! snapshot.data.exists) {
            return Center (
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    'Intervention indisponible',
                  ),
                  ElevatedButton(
                    child: Text(
                        'Séléctionner une intervention'
                    ),
                    onPressed: () => NavigatorPage.navigateTo(0),
                  ),
                  Spacer(),
                ],
              ),
            );
          }
          print("REFRESH SITAC");
          _monIntervention = Intervention.fromSnapshot(snapshot.data);
          return MaterialApp(
            home: DefaultTabController(
              length: 8,
              child: Scaffold(
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: [
                      Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png'),)),
                      Tab(icon: Image(image: new AssetImage('Icone_Png/Danger/S_Action_Noir_1.png'),)),
                      Tab(icon: Image(image: new AssetImage('Icone_Png/Danger/S_Danger_Noir_1.png'),)),
                      Tab(icon: Image(image: new AssetImage('Icone_Png/PointEau.png'),)),
                      Tab(icon: Image(image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Noir_0.png'),)),
                      Tab(icon: Image(image: new AssetImage('Icone_Png/Chemin/S_Fleche_Noir_1.png'),)),
                      Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png'),)),
                      Tab(icon: Image(image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Basic.png'),)),
                    ],
                  ),
                  title: Text('SITAC ' + '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
                      '' +  DateFormat('yyyy-MM-dd  kk:mm:ss').format(_monIntervention.getDate) +
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
                                ListView.builder(
                                  itemCount: _monIntervention.getMoyens.length,
                                  itemBuilder: (context, index){
                                    MoyenIntervention moyen = _monIntervention.moyens[index];
                                    if (moyen != null && moyen.moyen != null && moyen.moyen.couleurDefaut != null && moyen.etat != null && moyen.position.latitude == null && moyen.position.longitude == null) {
                                      String pathImage = SymbolDecider.createIconPathRelatedToObject(moyen);
                                      return GestureDetector(
                                        onTap: () {
                                          SelectorMoyenSymbol.moyenId = index;
                                          SelectorMoyenSymbol.pathImage = pathImage;
                                        },
                                        child: Image(
                                          image: new AssetImage(pathImage),
                                        ),
                                      );
                                    }
                                    return null;
                                  },
                                ),
                                // MOYEN demandé à partir d'infrastructure
                                ListView(
                                  padding: const EdgeInsets.all(8),
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_Action_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_Action_Rouge_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_Action_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_Action_Vert_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_Action_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_Action_Bleu_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_Action_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_Action_Orange_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_Danger_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_Danger_Rouge_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_PointSensible_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_PointSensible_Rouge_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_Danger_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_Danger_Vert_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_PointSensible_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_PointSensible_Vert_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_Danger_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_Danger_Bleu_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_PointSensible_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_PointSensible_Bleu_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_Danger_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_Danger_Orange_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Danger/S_PointSensible_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Danger/S_PointSensible_Orange_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/S_Perienne_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/S_Perienne_Bleu_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/S_NonPerienne_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/S_NonPerienne_Bleu_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/S_Ravitaillement_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/S_Ravitaillement_Bleu_1.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Defense_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Defense_Rouge_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Defense_Rouge_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Defense_Rouge_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Defense_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Defense_Vert_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Defense_Vert_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Defense_Vert_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Defense_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Defense_Bleu_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Defense_Bleu_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Defense_Bleu_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Defense_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Defense_Orange_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Defense_Orange_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Defense_Orange_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Perimetrale_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Rouge_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Perimetrale_Rouge_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Rouge_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Perimetrale_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Vert_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Perimetrale_Vert_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Vert_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Perimetrale_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Bleu_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Perimetrale_Bleu_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Bleu_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Perimetrale_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Orange_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Defense/S_Perimetrale_Orange_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Defense/S_Perimetrale_Orange_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Noir_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Noir_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Noir_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Noir_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Noir_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Noir_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Noir_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Noir_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Rouge_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Rouge_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Rouge_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Rouge_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Rouge_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Rouge_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Orange_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Orange_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Orange_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Orange_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Orange_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Orange_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Vert_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Vert_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Vert_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Vert_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Vert_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Vert_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Bleu_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Bleu_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Bleu_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Bleu_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Bleu_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Bleu_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Violet_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Violet_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Chemin_Violet_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Chemin_Violet_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Violet_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Violet_1.png'),
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Chemin/S_Fleche_Violet_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Chemin/S_Fleche_Violet_0.png'),
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
                                    GestureDetector(
                                      onTap: () {
                                        SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png';
                                      },
                                      child: Image(
                                        image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png'),
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png';
                                      },
                                      child: Image(
                                        image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png'),
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png';
                                      },
                                      child: Image(
                                        image: new AssetImage('Icone_Png/Infrastructure/Infrastructure_Civil_EnCours.png'),
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  ],
                                ),
                                ListView(
                                  //scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(8),
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Noir_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Noir_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Noir_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Noir_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Orange_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Orange_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Orange_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Vert_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Vert_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Vert_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Bleu_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Bleu_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Bleu_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Violet_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Violet_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Violet_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Violet_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Noir_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Noir_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Noir_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Noir_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Rouge_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Rouge_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Rouge_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Orange_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Orange_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Orange_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Vert_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Vert_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Vert_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Bleu_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Bleu_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Bleu_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Violet_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Violet_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Violet_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Violet_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Noir_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Noir_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Noir_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Noir_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Rouge_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Rouge_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Rouge_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Rouge_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Orange_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Orange_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Orange_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Orange_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Vert_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Vert_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Vert_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Vert_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Bleu_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Bleu_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Bleu_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Bleu_0.png'),
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
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Violet_1.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Violet_1.png'),
                                            width: 90,
                                            height: 90,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            SelectorMoyenSymbol.pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Violet_0.png';
                                          },
                                          child: Image(
                                            image: new AssetImage('Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Violet_0.png'),
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
                                              SelectorMoyenSymbol.pathImage = 'Icone_Png/S_Poste_Violet_1.png';
                                            },
                                            child: Image(
                                              image: new AssetImage('Icone_Png/S_Poste_Violet_1.png'),
                                              width: 90,
                                              height: 90,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              SelectorMoyenSymbol.pathImage = 'Icone_Png/S_Poste_Violet_0.png';
                                            },
                                            child: Image(
                                              image: new AssetImage('Icone_Png/S_Poste_Violet_0.png'),
                                              width: 90,
                                              height: 90,
                                            ),
                                          ),
                                        ]
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
    );
  }
}