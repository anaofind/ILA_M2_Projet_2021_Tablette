import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/pages/MissionPhotosPage.dart';
import 'package:flutter_app/pages/MissionVideoPage.dart';
import 'package:flutter_app/services/MissionService.dart';
import 'package:flutter_app/services/NavigatorPage.dart';
import 'package:flutter_app/services/SelectorSitac.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app/services/SelectorIntervention.dart';

class MissionPage extends StatefulWidget {

  @override
  MissionPageState createState() => MissionPageState();
}

class MissionPageState extends State<MissionPage> {

  @override
  Widget build(BuildContext context) {
    print ('REFRESH MISSION');
    return StreamBuilder<QuerySnapshot> (
        stream: MissionService.getMissionById(SelectorIntervention.missionSelected.id),
        builder: (context, snapshot) {
          if (! snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.data.size == 0) {
            return Center(
              child: Text('Cette mission est introuvable')
            );
          }
          Mission mission = Mission.fromSnapshot(snapshot.data.docs[0]);
          return Scaffold(
              body: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: this.getTitleWidget(mission),
                  ),
                  Flexible(
                    flex: 6,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 20,
                                right: 20
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: this.getPhotosWidget(mission),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 20,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child : this.getVideoWidget(mission),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
          );
        }
    );
  }

  Future<List<InfoPhoto>> searchInfoPhotos(Mission mission) async{
    List<InfoPhoto> infoPhotos = [];
    if (mission.photos != null) {
      for (int i = 0; i<mission.photos.length; i++) {
        String link = mission.photos[i];
        Reference reference = await MissionService.getPhotoByLink(link);
        FullMetadata metadata = await reference.getMetadata();
        DateTime date = convertToDateLocal(metadata.timeCreated);
        String name = metadata.name;
        double longitude = double.parse(metadata.customMetadata['longitude']);
        double latitude = double.parse(metadata.customMetadata['latitude']);
        Position position = Position(latitude, longitude);
        int size = metadata.size;
        InfoPhoto info = InfoPhoto (
            name: name,
            link: link,
            position: position,
            date: date,
            size: size,
            missionName: mission.name
        );
        infoPhotos.add(info);
      }
    }
    return infoPhotos;
  }

  DateTime convertToDateLocal(DateTime date) {
    return date.add(Duration(hours: 2));
  }


  Widget getTitleWidget(Mission mission) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          color: Colors.white
      ),
      child: Row(
        children: [
          Flexible(
              flex: 1,
              child: Center(
                child: Text(
                  mission.name,
                  style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
          ),
          Flexible (
            flex: 1,
            child : Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: 10,
                  ),
                  child: FlatButton(
                      child: Text(
                          'Suivre',
                          style : TextStyle(color: Colors.white)
                      ),
                      onPressed: () {
                        if (mission.state == StateMission.Running) {
                          SelectorIntervention.missionSelected = mission;
                          SelectorSitac.indexTabBar = 6;
                          NavigatorPage.navigateTo(1);
                        }
                      },
                      color: Colors.blue
                  ),
                ),
              ],
            ),
          ),
          Flexible (
            flex: 2,
            child : Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: 5,
                  ),
                  child: FlatButton(
                      child: Text(
                          'Nouvelle',
                          style : TextStyle(color: Colors.white)
                      ),
                      onPressed: () async{
                        SelectorIntervention.missionSelected = null;
                        DocumentSnapshot doc = await InterventionService().getInterventionById(mission.idIntervention).first;
                        if (doc.exists) {
                          Intervention intervention = Intervention.fromSnapshot(doc);
                          intervention.futureMission = Mission();
                          await InterventionService().updateIntervention(intervention);
                        }
                        SelectorSitac.indexTabBar = 6;
                        NavigatorPage.navigateTo(1);
                      },
                      color: Colors.green
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 5,
                  ),
                  child: FlatButton(
                    child: Text(
                        'Dupliquer',
                        style : TextStyle(color: Colors.white)
                    ),
                    onPressed: () async{
                      DocumentSnapshot doc = await InterventionService().getInterventionById(mission.idIntervention).first;
                      if (doc.exists) {
                        Intervention intervention = Intervention.fromSnapshot(doc);
                        intervention.futureMission = mission.duplicate();
                        await InterventionService().updateIntervention(intervention);
                        SelectorSitac.indexTabBar = 6;
                        NavigatorPage.navigateTo(1);
                      }
                    },
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 5,
                  ),
                  child: FlatButton(
                      child: Text(
                          'Supprimer',
                          style : TextStyle(color: Colors.white)
                      ),
                      onPressed: () async {
                        SelectorIntervention.missionSelected = null;
                        await MissionService.removeMission(mission);
                      },
                      color: Colors.red
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget getVideoWidget(Mission mission) {
    return Column (
      children: [
        Flexible(
          flex: 1,
          child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.white
              ),
              child: Center(child: Text('Vidéo'))
          ),
        ),
        Flexible(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(
                  bottom: 15,
                  right: 15,
                  left: 15
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
              ),
              child: FractionallySizedBox(
                  child: MissionVideoPage()
              ),
            )
        ),
      ],
    );
  }

  Widget getPhotosWidget(Mission mission) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.white
              ),
              child: Center(child: Text('Nombre de photos : ${mission.photos.length}'))
          ),
        ),
        Flexible(
            flex: 4,
            child: FutureBuilder (
                future: this.searchInfoPhotos(mission),
                builder: (context, snapshot) {
                  if (! snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  List<InfoPhoto> infoPhotos = snapshot.data;
                  return ListView.builder (
                      shrinkWrap: true,
                      itemCount: infoPhotos.length,
                      itemBuilder: (BuildContext context, int index) {
                        InfoPhoto infoPhoto = infoPhotos[index];
                        return Row(
                          children: [
                            Flexible (
                              flex: 1,
                              child: Container(
                                margin: new EdgeInsets.only(
                                  bottom: 15,
                                  left: 15,
                                ),
                                height: 160,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    color: Colors.white
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    child: Image.network(
                                      infoPhoto.link,
                                      width: 160,
                                      height: 160,
                                    ),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => MissionPhotosPage(infoPhotos, index))
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                  margin: new EdgeInsets.only(
                                      bottom: 15,
                                      left: 15,
                                      right: 15
                                  ),
                                  height: 160,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                      color: Colors.white
                                  ),
                                  child: Column (
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Text(infoPhoto.name.toString())),
                                      Center(child: Text(infoPhoto.date.toString())),
                                      Center(child: Text(infoPhoto.position.toString())),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        );
                      }
                  );
                }
            )
        ),
      ],
    );
  }

}


class InfoPhoto {
  final String name;
  final String link;
  final Position position;
  final DateTime date;
  final String missionName;
  final int size;
  InfoPhoto({this.missionName, this.size, this.name, this.link, this.position, this.date});
}