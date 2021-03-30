import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/services/MissionService.dart';
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
        stream: MissionService.getMissionById(SelectorIntervention.idMissionSelected),
        builder: (context, snapshot) {
          if (! snapshot.hasData) {
            return CircularProgressIndicator();
          }
          Mission mission = Mission.fromSnapshot(snapshot.data.docs[0]);
          return Scaffold(
              body: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          color: Colors.white
                      ),
                      child: Center(
                          child: Text(
                              mission.name,
                            style: TextStyle(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,

                            ),
                          )
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
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
                            child: Column(
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
                                    child: this.getPhotosWidget(mission)
                                ),
                              ],
                            ),
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
                                child : Column(
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
                                              color: Colors.black
                                          ),
                                        )
                                    ),
                                  ],
                                )
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
        InfoPhoto info = InfoPhoto(name, link, position, date);
        infoPhotos.add(info);
      }
    }
    return infoPhotos;
  }

  DateTime convertToDateLocal(DateTime date) {
    return date.add(Duration(hours: 2));
  }

  Widget getPhotosWidget(Mission mission) {
    return FutureBuilder (
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
                        child: Image.network(
                          infoPhoto.link,
                          width: 160,
                          height: 160,
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
                          Center(child: Text('( ${infoPhoto.position.latitude} , ${infoPhoto.position.longitude} )')),
                        ],
                      )
                    ),
                  ),
                ],
              );
            }
        );
      }
    );
  }

}


class InfoPhoto {
  final String name;
  final String link;
  final Position position;
  final DateTime date;
  InfoPhoto(this.name, this.link, this.position, this.date);
}