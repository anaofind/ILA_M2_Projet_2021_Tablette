import 'package:flutter/material.dart';
import 'package:flutter_app/models/Moyen.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/util/ColorConverter.dart';

import 'NewInterventionPage.dart';


class MissionPage extends StatefulWidget {
  final String mission;
  MissionPage(this.mission);

  @override
  MissionPageState createState() => MissionPageState(this.mission);
}

class MissionPageState extends State<MissionPage> {
  final String mission;

  AccountService authService = AccountService();

  MissionPageState(this.mission);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text(
              mission
          ),
        )
    );
  }
}