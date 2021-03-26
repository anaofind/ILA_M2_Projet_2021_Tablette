import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/services/MissionService.dart';

import 'package:flutter_app/services/SelectorIntervention.dart';
import 'package:flutter_app/services/AccountService.dart';

class MissionPage extends StatefulWidget {

  @override
  MissionPageState createState() => MissionPageState();
}

class MissionPageState extends State<MissionPage> {

  AccountService authService = AccountService();

  @override
  Widget build(BuildContext context) {
    print ('REFRESH MISSION');
    return StreamBuilder<QuerySnapshot> (
        stream: MissionService.getMissionById(SelectorIntervention.idMissionSelected),
        builder: (context, snapshot) {
          if (! snapshot.hasData) {
            return CircularProgressIndicator();
          }
          Mission mission = Mission.fromSnapshot(snapshot.data.docs[0]);
          return Scaffold(
              body: Center(
                child: Text(
                    mission.name,
                ),
              )
          );
      }
    );
  }
}