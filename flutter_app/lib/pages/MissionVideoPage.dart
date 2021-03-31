import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/services/MissionService.dart';

class MissionVideoPage extends StatefulWidget {

  final Mission mission;

  MissionVideoPage(this.mission);

  @override
  MissionVideoPageState createState() => MissionVideoPageState(this.mission);
}

class MissionVideoPageState extends State<MissionVideoPage> {

  Mission mission;

  MissionVideoPageState(this.mission);

  @override
  Widget build(BuildContext context) {
    // this.linkVideo = 'https://firebasestorage.googleapis.com/v0/b/projet-istic-ila.appspot.com/o/images%2F5bb10da0-c9e5-4334-95b1-97a012f75f1d%2Fphoto10.png?alt=media&token=5a555fd4-0adc-4e8c-835c-91cb960c3151';
    return StreamBuilder<QuerySnapshot>(
      stream: MissionService.getMissionById(mission.id),
      builder: (context, snapshot) {
        if (! snapshot.hasData) {
          return CircularProgressIndicator();
        }
        Mission mission = Mission.fromSnapshot(snapshot.data.docs[0]);
        return Scaffold(
          body: (mission.video != null)? this.getVideoWidget(mission): this.getEmptyWidget()
        );
      }
    );
  }
  
  Widget getVideoWidget(Mission mission) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage(
              mission.video
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget getEmptyWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          'Aucune vidéo disponible',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}