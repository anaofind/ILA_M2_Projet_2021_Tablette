import 'package:flutter/material.dart';
import 'package:flutter_app/models/Moyen.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/util/ColorConverter.dart';

import 'NewInterventionPage.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String email, password;

  AccountService authService = AccountService();
  //////
  InterventionService interventionService = InterventionService();
  //////

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Acceuil'),
        ),
        body: Column(
          children: [
            Text(
                "Bienvenu"
            ),
            ElevatedButton(
              child: Text('Nouvelle intervention'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewInterventionPage())
                );
              },
            ),
            ///////
            ElevatedButton(
              child: Text('ajout symbol'),
              onPressed: () {

               /* interventionService.addSymbolToIntervention('TNnDbK1vCdwfYTGIkKgg',
                    SymbolIntervention('nomSymbol', Position(1,1), ColorConverter
                        .colorFromString('Colors.green'), Etat.prevu.toString()));*/
                //interventionService.updatePositionSymbolIntervention('TNnDbK1vCdwfYTGIkKgg',
                //'984fc28f-8917-434b-8d69-59a29d8eea59', Position(1.6, 1.6));
                //interventionService.updateEtatSymbolIntervention('TNnDbK1vCdwfYTGIkKgg',
                    //'984fc28f-8917-434b-8d69-59a29d8eea59', Etat.enCours);

                interventionService.addMoyenOrSymbolToIntervention('TNnDbK1vCdwfYTGIkKgg',
                    SymbolDecider.createObjectRelatedToSymbol("Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_1.png", Position(1.5,1.5)));

                    //interventionService.addMoyenOrSymbolToIntervention('TNnDbK1vCdwfYTGIkKgg',
                    //SymbolDecider.createObjectRelatedToSymbol("Icone_Png/Danger/S_Danger_Noir_1.png", Position(1.5,1.5)));
              },
            )
            ///////
          ],
        )
    );
  }
}