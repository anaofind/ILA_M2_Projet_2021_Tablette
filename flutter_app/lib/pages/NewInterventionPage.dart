import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Moyen.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/MoyenService.dart';
import 'package:flutter_app/services/SinistreService.dart';
import 'package:flutter_app/util/ColorConverter.dart';
import 'package:fluttertoast/fluttertoast.dart';


class NewInterventionPage extends StatefulWidget {
  NewInterventionPage({Key key}) : super(key: key);

  @override
  NewInterventionPageState createState() => NewInterventionPageState();
}

class NewInterventionPageState extends State<NewInterventionPage> {
  AccountService accountService = AccountService();
  SinistreService sinistreService = SinistreService();
  MoyenService moyenService = MoyenService();
  InterventionService interventionService = InterventionService();
  List<MoyenIntervention> moyensIntervention = new List<MoyenIntervention>();


  @override
  Future<void> initState() {
    super.initState();
  }

  Future<List<MoyenIntervention>> selectionMoyen() async {
    List<DropdownMenuItem<Moyen>> _dropdownMenuItems = List();
    List<MoyenIntervention> newMoyens = new List<MoyenIntervention>();
    moyensIntervention.forEach((element) {
      newMoyens.add(element);
    });
    Moyen _selectedMoyen;
    Color _selectedColor;
    List<Color> colors = [
      Colors.black,
      Colors.green,
      Colors.red,
      Colors.blue,
      Colors.orange,
      Colors.purple
    ];
    List<Widget> chColors = [];
    double initSize = 30.0;

    Future<List<MoyenIntervention>> futureValue = showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Moyens'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(moyensIntervention);
                    },
                    child: Text('Annuler'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(newMoyens);
                    },
                    child: Text('OK'),
                  ),
                ],
                content: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 300,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height - 300,
                  child:
                  StreamBuilder(
                      stream: moyenService.loadAllMoyens(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          _dropdownMenuItems.isEmpty ?
                          snapshot.data.docs.forEach((val) {
                            _dropdownMenuItems.add(DropdownMenuItem<Moyen>(

                              value: Moyen.fromSnapshot(val),
                              child: new Text(val.data()['codeMoyen']),
                            ));
                          }) : _dropdownMenuItems = _dropdownMenuItems;
                          _selectedMoyen = _selectedMoyen == null
                              ? _dropdownMenuItems[0].value
                              : _selectedMoyen;
                          _selectedColor =
                          _selectedColor == null ? ColorConverter
                              .colorFromString(_selectedMoyen.couleurDefaut)
                              : _selectedColor;
                          chColors.isEmpty ? colors.forEach((element) {
                            chColors.add(
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedColor = element;
                                      });
                                    },
                                    child: CircleAvatar(
                                        backgroundColor: element,
                                        radius: initSize)
                                )
                            );
                          }) : chColors = chColors;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new DropdownButton<Moyen>(
                                    // hint: Text('Séléctionnez un moyen'),
                                    value: _selectedMoyen,
                                    items: _dropdownMenuItems,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedMoyen = value;
                                        _selectedColor =
                                            ColorConverter.colorFromString(
                                                _selectedMoyen.couleurDefaut);
                                        print('_selectedMoyen ' +
                                            _selectedMoyen.codeMoyen);
                                      });
                                    },
                                  ),
                                  //Text('Selected: ${_selectedColor}'),
                                  CircleAvatar(backgroundColor: _selectedColor)
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: chColors
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    tooltip: 'Ajouter le moyen sélectionné',
                                    onPressed: () {
                                      setState(() {
                                        //ici ajouter le moyen + couleur à la liste
                                        newMoyens.add(MoyenIntervention(
                                            _selectedMoyen,
                                            Etat.enCours.toString(), null, null,
                                            null, _selectedColor));
                                        Fluttertoast.showToast(
                                            msg: "Moyen ajouté",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
              );
            },
          );
        });
    Stream<List<MoyenIntervention>> stream = futureValue.asStream();
    stream.listen((List<MoyenIntervention> data) {
      List<MoyenIntervention> m = new List<MoyenIntervention>();
      m = data != null ? data : moyensIntervention;
      this.setState(() {
        this.moyensIntervention = m;
      });
    }, onDone: () {
      print("Done!");
    }, onError: (error) {
      print("Error! " + error.toString());
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 25.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            mini: true,
            onPressed: () {
              selectionMoyen();
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Acceuil'),
      ),
      body: Container(
        //alignment: Alignment.center,
        child: Row(
            children: <Widget>[
              Expanded(
                flex: 7, // 70%
                child: Container(//color: Colors.grey,
                  child:   ElevatedButton(
                    child: Text('Commencer l\'intervention'),
                    onPressed: () {
                      setState(() {
                        moyensIntervention.isEmpty?Fluttertoast.showToast(
                            msg: "Veuillez ajouter des moyens",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        ):{interventionService.addIntervention("Mission Incendie gare",
                            "19 Place de la Gare, 35005 Rennes", "INC", moyensIntervention),
                          Fluttertoast.showToast(
                              msg: "Intervention créée",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0
                          ),
                          moyensIntervention.clear()};
                      });
                    },

                  ),
                ),
              ),
              Expanded(
                flex: 3, // 30%
                child:
                Column(
                  children: [
                    Expanded(
                      child: moyensIntervention.isEmpty?Center(child: Text('Pas de moyens séléctionnés')):ListView.builder
                        (
                          itemCount: moyensIntervention.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: moyensIntervention[index].couleur,
                              ),
                              title:Text(moyensIntervention[index].moyen.codeMoyen),
                              //subtitle: Text('1'),
                              trailing:IconButton(
                                icon: const Icon(Icons.remove_circle, size: 30,),
                                color: Colors.red,
                                tooltip: 'Supprimer le moyen',
                                onPressed: () {
                                  setState(() {
                                    moyensIntervention.removeAt(index);
                                  });
                                },
                              ),

                            );
                          }
                      ),
                    ),
                  ],
                ),


              ),

            ]
        ),
      ),


    );
  }
}