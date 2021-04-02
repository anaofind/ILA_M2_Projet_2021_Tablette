import 'package:flutter/material.dart';
import 'package:flutter_app/pages/MissionPage.dart';
import 'package:flutter_app/services/AccountService.dart';


class MissionPhotosPage extends StatefulWidget {
  final List<InfoPhoto> infoPhotos;
  int photoSelected;

  MissionPhotosPage(this.infoPhotos, this.photoSelected);


  @override
  MissionPhotosPageState createState() => MissionPhotosPageState(this.infoPhotos, this.photoSelected);
}

class MissionPhotosPageState extends State<MissionPhotosPage> {

  final List<InfoPhoto> infoPhotos;
  int photoSelected;

  MissionPhotosPageState(this.infoPhotos, this.photoSelected);

  @override
  Widget build(BuildContext context) {
    InfoPhoto infoPhoto = this.infoPhotos[this.photoSelected];
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Photos : ' + infoPhoto.missionName),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                      height: 100,
                      child : Center(
                        child: Text(
                          (this.photoSelected+1).toString() + ' - ' + infoPhoto.name,
                          style : TextStyle(fontSize: 30),
                        ),
                      )
                  )
              ),
              Flexible (
                flex: 6,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: GestureDetector(
                          child: Container(
                              child: Icon(Icons.navigate_before, size: 180)
                          ),
                          onTap: () {
                            this.setState(() {
                              this.photoSelected = (this.photoSelected - 1) % this.infoPhotos.length;
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1
                          ),
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: NetworkImage(
                                infoPhoto.link
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: GestureDetector(
                          child: Container(
                              child: Icon(Icons.navigate_next, size: 180)
                          ),
                          onTap: () {
                            this.setState(() {
                              this.photoSelected = (this.photoSelected + 1) % this.infoPhotos.length;
                            });
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                      height: 80,
                      child : Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(),
                            getOneInfoWidget('Date de création', infoPhoto.date.toString()),
                            Spacer(),
                            getOneInfoWidget('Coordonnées', infoPhoto.position.toString()),
                            Spacer(),
                            getOneInfoWidget('Taille', (infoPhoto.size / 1000).toString() + ' Ko'),
                            Spacer(),
                          ],
                        ),
                      )
                  )
              ),
            ],

          ),
        )
    );
  }

  Widget getOneInfoWidget(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style : TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}