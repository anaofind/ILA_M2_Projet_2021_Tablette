import 'package:flutter/material.dart';

import 'package:flutter_app/services/SelectorIntervention.dart';
import 'package:flutter_app/services/AccountService.dart';

import 'NewInterventionPage.dart';


class MissionPage extends StatefulWidget {

  @override
  MissionPageState createState() => MissionPageState();
}

class MissionPageState extends State<MissionPage> {

  AccountService authService = AccountService();

  @override
  Widget build(BuildContext context) {
    print ('REFRESH MISSION');
    return Scaffold(
        body: Center(
          child: Text(
              'Mission ' + (SelectorIntervention.idMissionSelected+1).toString()
          ),
        )
    );
  }
}