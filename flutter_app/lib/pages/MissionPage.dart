import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/services/MissionService.dart';

import 'package:flutter_app/services/SelectorIntervention.dart';

class MissionPage extends StatefulWidget {

  @override
  MissionPageState createState() => MissionPageState();
}

class MissionPageState extends State<MissionPage> {

  List<String> linkImages = [];

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
          this.searchLinksPhoto(mission);

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
                                      child: Center(child: Text('Nombre de photos : ${this.linkImages.length}'))
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: this.getPhotosWidget()
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

  Future<void> searchLinksPhoto(Mission mission) async{
    this.linkImages.clear();
    if (mission.photos != null) {
      mission.photos.forEach((element) {
        this.linkImages.add(element);
      });
    }
    /*
    this.linkImages.add('https://d1fmx1rbmqrxrr.cloudfront.net/cnet/optim/i/edit/2019/04/eso1644bsmall__w770.jpg');
    this.linkImages.add('https://d1fmx1rbmqrxrr.cloudfront.net/cnet/optim/i/edit/2019/04/eso1644bsmall__w770.jpg');
    this.linkImages.add('https://d1fmx1rbmqrxrr.cloudfront.net/cnet/optim/i/edit/2019/04/eso1644bsmall__w770.jpg');
    this.linkImages.add('https://d1fmx1rbmqrxrr.cloudfront.net/cnet/optim/i/edit/2019/04/eso1644bsmall__w770.jpg');
    this.linkImages.add('https://d1fmx1rbmqrxrr.cloudfront.net/cnet/optim/i/edit/2019/04/eso1644bsmall__w770.jpg');
    this.linkImages.add('https://d1fmx1rbmqrxrr.cloudfront.net/cnet/optim/i/edit/2019/04/eso1644bsmall__w770.jpg');
     */
  }

  Widget getPhotosWidget() {
    return ListView.builder (
        shrinkWrap: true,
        itemCount: this.linkImages.length,
        itemBuilder: (BuildContext context, int index) {
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
                      this.linkImages[index],
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
                ),
              ),
            ],
          );
        }
    );
  }

}