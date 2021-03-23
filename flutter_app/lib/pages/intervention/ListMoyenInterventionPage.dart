import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Moyen.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/MoyenService.dart';
import 'package:flutter_app/util/ColorConverter.dart';
import 'package:flutter_app/util/IconBasePathGetter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ListMoyenInterventionPage extends StatefulWidget {
  Intervention intervention;
  ListMoyenInterventionPage(Intervention uneI) {
    this.intervention = uneI;
  }
  @override
  _ListMoyenInterventionPage createState() => _ListMoyenInterventionPage(this.intervention);
}

class _ListMoyenInterventionPage extends State<ListMoyenInterventionPage> {
  Intervention intervention;
  _ListMoyenInterventionPage(Intervention uneI) {
    this.intervention = uneI;
  }

  MoyenService moyenService = MoyenService();
  InterventionService interventionService = InterventionService();
  List<MoyenIntervention> moyensIntervention = new List<MoyenIntervention>();
  List<MoyenIntervention> moyens = new List<MoyenIntervention>();
  ////
  List<DataRow> _buildList(BuildContext context, List<MoyenIntervention> moyens) {
    return  moyens.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, MoyenIntervention data) {
    String depart = data.departA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.departA);
    String arrivee = data.arriveA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.arriveA);
    //String checked = data.etat;
    bool checked = true;
    return DataRow(
            cells: [
              DataCell(Text(data.moyen.codeMoyen + "\n" + data.moyen.description)),
              DataCell(Text(DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.demandeA))),
              DataCell(Text(depart)),
              DataCell(Text(arrivee)),
              DataCell(
                  Checkbox(
                    value: data.etat == Etat.enCours.toString() ? true : false,
                  )
              )
            ],
            onSelectChanged: (ind) {
              setState(() {
              });
            });
  }

  Future<List<MoyenIntervention>> selectionMoyen() async {
    List<DropdownMenuItem<Moyen>> _dropdownMenuItems = List();
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
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(

                title: Text('Moyens'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Annuler'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(moyensIntervention);
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
                                        moyensIntervention.add(MoyenIntervention(
                                            _selectedMoyen,
                                            Etat.enAttente.toString(), DateTime.now(), null,
                                            null, _selectedColor, IconBasePathGetter.getImageBasePath(_selectedMoyen.codeMoyen)));
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
        interventionService.addListMoyensToIntervention(this.intervention.id, moyensIntervention);
        this.moyensIntervention = List();
      });
    }, onDone: () {
      print("Done!");
    }, onError: (error) {
      print("Error! " + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Moyens de l'intervention " + this.intervention.getNom),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: interventionService.getInterventionById(this.intervention.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              moyens = Intervention.fromSnapshot(snapshot.data).moyens;
              return ListView(
                padding: EdgeInsets.all(20.0),
                children: <Widget>[
                  SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: DataTable(
                                showCheckboxColumn: false,
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'Moyen',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Date de demande',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Date de validation',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Date engagement',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Etat',
                                      style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                ],
                                rows: _buildList(context, moyens)
                            ),
                          ),
                          _showAddButton()
                        ],
                      )
                  )
                ],
              );
            }
        )
    );
  }
  Widget _showAddButton() {
    return Center(
      child: ElevatedButton(
        child: Text('Ajouter moyens'),
        onPressed: () {
          selectionMoyen();
        },
      ),
    );
  }
}