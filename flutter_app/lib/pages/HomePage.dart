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
            )
          ],
        )
    );
  }
}