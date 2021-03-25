import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/pages/MissionPage.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/NavigatorPage.dart';


class DronePage extends StatefulWidget {
  DronePage(this.intervention);

  final Intervention intervention;

  @override
  DronePageState createState() => DronePageState(this.intervention);
}

class DronePageState extends State<DronePage> {

  Intervention intervention;
  final InterventionService interventionService = InterventionService();

  int idMissionSelected = 0;
  List<String> missions = [];

  DronePageState(this.intervention) {
    for (int i = 0; i<10; i++) {
      this.missions.add('Mission ' + (i+1).toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    final String idIntervention = (this.intervention != null)? this.intervention.id : ' ';
    return StreamBuilder<DocumentSnapshot>(
        stream: this.interventionService.getInterventionById(idIntervention),
        builder: (context, snapshot) {
          print("REFRESH MAP");
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

          if (this.missions.length == 0) {
            return Center (
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    'Aucune mission associée à cette intervention',
                  ),
                  ElevatedButton(
                    child: Text(
                        'Créer une mission'
                    ),
                    onPressed: () => NavigatorPage.navigateTo(1),
                  ),
                  Spacer(),
                ],
              ),
            );
          }
          this.intervention = Intervention.fromSnapshot(snapshot.data);

          return Scaffold(
              appBar: AppBar(
                title: Text('Drone'),
              ),
              body: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: this.missions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                              padding: new EdgeInsets.symmetric(vertical: 40.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                color: (this.idMissionSelected == index)? Colors.black12: Colors.white,
                              ),
                              child : Center(
                                  child: Text(
                                      this.missions[index],
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  )
                              )
                          ),
                          onTap: () {
                            this.setState(() {
                              this.idMissionSelected = index;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child : MissionPage(this.missions[this.idMissionSelected]),
                  )
                ],
              )
          );
        }
    );
  }
}