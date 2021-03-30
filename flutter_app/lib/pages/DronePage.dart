import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/pages/MissionPage.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/MissionService.dart';
import 'package:flutter_app/services/NavigatorPage.dart';
import 'package:flutter_app/services/SelectorIntervention.dart';
import 'package:flutter_app/services/SelectorSitac.dart';


class DronePage extends StatefulWidget {
  DronePage(this.intervention);

  final Intervention intervention;

  @override
  DronePageState createState() => DronePageState(this.intervention);
}

class DronePageState extends State<DronePage> {

  Intervention intervention;
  final InterventionService interventionService = InterventionService();

  DronePageState(this.intervention);

  @override
  Widget build(BuildContext context) {
    final String idIntervention = (this.intervention != null)? this.intervention.id : ' ';
    return StreamBuilder<DocumentSnapshot>(
        stream: this.interventionService.getInterventionById(idIntervention),
        builder: (context, snapshot) {
          print("REFRESH DRONE");
          if (!snapshot.hasData || snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (! snapshot.data.exists) {
            return Center (
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    (idIntervention != ' ')? 'Intervention indisponible' : 'Aucune intervention séléctionnée',
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
          this.intervention = Intervention.fromSnapshot(snapshot.data);
          if (this.intervention.missions.length == 0) {
            return Center (
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    'Aucune mission associée à cette intervention : ' + this.intervention.nom,
                  ),
                  ElevatedButton(
                    child: Text(
                        'Créer une mission'
                    ),
                    onPressed: () {
                      SelectorSitac.indexTabBar = 6;
                      NavigatorPage.navigateTo(1);
                    },
                  ),
                  Spacer(),
                ],
              ),
            );
          }

          return Scaffold(
              appBar: AppBar(
                title: Text('Drone'),
              ),
              body: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: this.intervention.missions.length,
                      itemBuilder: (context, index) {
                        String idMission = this.intervention.missions[index];
                        return GestureDetector(
                          child: Container(
                              padding: new EdgeInsets.symmetric(vertical: 40.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                color: (SelectorIntervention.idMissionSelected == idMission)? Colors.black12: Colors.white,
                              ),
                              child : Center(
                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: MissionService.getMissionById(idMission),
                                    builder: (context, snapshot) {
                                      if (! snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      Mission mission = Mission.fromSnapshot(snapshot.data.docs[0]);
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            mission.name,
                                            style: TextStyle(
                                              fontSize: 30,
                                            ),
                                          ),
                                          this.getIconState(mission),
                                        ],
                                      );
                                    }
                                  )
                              )
                          ),
                          onTap: () {
                            this.setState(() {
                              SelectorIntervention.idMissionSelected = idMission;
                              print(index);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child : Center(
                        child: Container(
                            margin: EdgeInsets.all(15),
                            child: (SelectorIntervention.idMissionSelected != null)? MissionPage() :
                            Center (
                              child: Text(
                                'Séléctionnez une mission',
                              ),
                            ),
                        )
                    ),
                  )
                ],
              )
          );
        }
    );
  }

  Widget getIconState(Mission mission) {
    IconData iconData;
    Color color;
    switch (mission.state) {
      case StateMission.Waiting :
        iconData = Icons.not_started_sharp;
        color = Colors.blue;
        break;
      case StateMission.Running :
        return CircularProgressIndicator();
        break;
      case StateMission.Ending :
        iconData = Icons.flag;
        color = Colors.green;
        break;
    }

    return Icon (
      iconData,
      color: color,
    );
  }
}