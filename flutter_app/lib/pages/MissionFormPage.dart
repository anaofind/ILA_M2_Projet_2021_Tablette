import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/InterestPoint.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/MissionService.dart';
import 'package:flutter_app/services/NavigatorPage.dart';
import 'package:flutter_app/services/SelectorIntervention.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class MissionFormPage extends StatefulWidget {
  final Intervention intervention;

  MissionFormPage(this.intervention);

  @override
  MissionFormPageState createState() => MissionFormPageState(this.intervention);
}

class MissionFormPageState extends State<MissionFormPage> {

  Intervention intervention;
  InterventionService interventionService = InterventionService();

  MissionFormPageState(this.intervention);


  final _editableKey = GlobalKey<EditableState>();

  String nameMission;
  bool segment = false;
  bool stream = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //TODO: pour la table -> List<PointDrone> points = [];
  List headers = [
    {"title": 'Point', 'index': 1, 'key': 'point'},
    {"title": 'Photo', 'index': 2, 'key': 'photo'}
  ];

  List rows = [];

  void _addNewRow() {
    setState(() {
      _editableKey.currentState.createRow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: interventionService.getInterventionById(this.intervention.id),
        builder: (context, snapshot) {
          if (! snapshot.hasData) {
            return CircularProgressIndicator();
          }
          this.intervention = Intervention.fromSnapshot(snapshot.data);

          return ListView(
            //TODO : SHERVIN SOUFIANE
            padding: const EdgeInsets.all(8),
            children: [
              /*SizedBox(
                height: 200,
                width: 150,
                child: Editable(
                  key: _editableKey,
                  rows: this.rows,
                  columns: headers,
                  columnRatio: 0.08,
                  trHeight: 40,
                  zebraStripe: true,
                  stripeColor2: Colors.lightGreen[200],
                  borderColor: Colors.blueGrey,
                  thStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.red),
                  thAlignment: TextAlign.center,
                  tdEditableMaxLines:20,
                  tdStyle: TextStyle(fontWeight: FontWeight.normal),
                  thVertAlignment: CrossAxisAlignment.end,
                  //showCreateButton: true,
                  tdAlignment: TextAlign.center,
                ),
              ), */
              Center(
                child: Text(
                  "Points d'intérêt :",
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: new EdgeInsets.symmetric(vertical: 10.0),
                child: Table(
                  children : InterestPointRows(),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Vidéo en direct',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Checkbox(
                            value: this.stream,
                            onChanged: (value) {
                              this.setState(() {
                                this.stream = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        'Nom de la mission :',
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.wysiwyg_outlined),
                          hintText: 'Donner un nom à la mission du drone',
                          labelText: 'Nom de la mission',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Veillez saisir le nom de l\'intervention';
                          }
                        },
                        onSaved: (value) {
                          nameMission = value;
                        },
                      ),
                      Row(children: <Widget>[
                        Text("Segment"),
                        Switch(
                          value: ! this.intervention.futureMission.segment,
                          onChanged: (value) {
                            this.intervention.futureMission.segment = ! value;
                            print (this.intervention.futureMission.segment);
                            this.interventionService.updateIntervention(intervention);
                            setState(() {});
                          },
                          inactiveTrackColor:
                          Colors.lightGreenAccent,
                          inactiveThumbColor:
                          Colors.lightGreen,
                          activeTrackColor:
                          Colors.lightBlue, // red
                          activeColor: Colors
                              .lightBlueAccent, // yellow
                        ),
                        Text("Zone"),
                      ]),
                      FlatButton(
                        child: Text('Démarrer', style: TextStyle(fontSize: 20.0),),
                        color: Colors.greenAccent,
                        textColor: Colors.white,
                        onPressed: () async {
                          final formState = _formKey.currentState;
                          if (formState.validate()) {
                            formState.save();
                            this.intervention.futureMission.name = nameMission;
                            if (this.intervention.futureMission.interestPoints.isNotEmpty) {
                              String idMission = this.intervention.futureMission.id;
                              await MissionService.addMission(this.intervention);
                              SelectorIntervention.idMissionSelected = idMission;
                              NavigatorPage.navigateTo(3);
                            }
                          }
                        },
                      ),
                      FlatButton(
                        child: Text('Annuler', style: TextStyle(fontSize: 20.0),),
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        onPressed: () {
                          this.intervention.futureMission = Mission();
                          InterventionService().updateIntervention(this.intervention);
                        },
                      ),
                    ]),
              )
            ],
          );
        }
    );
  }

  List<TableRow> InterestPointRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        TableCell(
          child: Container(
              padding: new EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                color: Colors.black12,
              ),
              child: Center(child: Text('Points'))
          ),
        ),
        TableCell(
          child: Container(
            padding: new EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              color: Colors.black12,
            ),
            child: Center(
                child: Text('Photos')
            ),
          ),
        ),
      ],
    ),);
    for (int i = 0; i<this.intervention.futureMission.interestPoints.length; i++) {
      InterestPoint interestPoint = this.intervention.futureMission.interestPoints[i];
      bool photo = interestPoint.photo;
      rows.add(TableRow(
        children: [
          TableCell(
            child: Container(
              height: 30,
              padding: new EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text((i+1).toString()),
              ),
            ),
          ),
          TableCell(
              child: GestureDetector(
                child: Container(
                  padding: new EdgeInsets.symmetric(vertical: 5.0),
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                        Icons.photo_camera,
                      color: (photo)? Colors.blue: Colors.grey,
                    ),
                  ),
                ),
                onTap: () {
                  interestPoint.photo = ! photo;
                  this.interventionService.updateIntervention(this.intervention);
                },
              )
          )
        ]
      ));
    }
    return rows;
  }
}