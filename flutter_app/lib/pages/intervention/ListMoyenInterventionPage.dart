import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Moyen.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/Role.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/models/UserData.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/MoyenService.dart';
import 'package:flutter_app/services/NavigatorPage.dart';
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
  List<MoyenIntervention> moyensEnAttente = new List<MoyenIntervention>();
  Map<MoyenIntervention, bool> mapMoyens=Map<MoyenIntervention, bool>();
  Map<MoyenIntervention, bool> mapM=Map<MoyenIntervention, bool>();


  List<DataColumn> columnsList() {
  return const <DataColumn>[
    DataColumn(
      label: Text(
        'Moyen',
        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'Date demande',
        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'Date validation',
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
        'Date retour',
        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      ),
    ),
    DataColumn(
      label: Text(
        'Etat',
        style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
      ),
    ),

  ];
  }

  List<DataRow> _buildListWithoutSelect(BuildContext context, List<MoyenIntervention> m) {
    return  moyens.map((data) => _buildListItemWithoutSelect(context, data)).toList();
  }

  DataRow _buildListItemWithoutSelect(BuildContext context, MoyenIntervention data) {
    String depart = data.departA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.departA);
    String arrivee = data.arriveA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.arriveA);
    String retour = data.retourneA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.retourneA);
    return DataRow(cells: [
      DataCell(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.moyen.codeMoyen),
              CircleAvatar(backgroundColor: data.couleur, radius: 10,)
            ],
          )
      ),
      DataCell(Text(DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.demandeA))),
      DataCell(Text(depart)),
      DataCell(Text(arrivee)),
      DataCell(Text(retour)),
      DataCell(Text(data.etat)),
    ]);
  }

  List<DataRow> _buildList(BuildContext context, List<MoyenIntervention> m) {

    List<DataRow> rows = List();
    Map<MoyenIntervention, bool> mapMoyensWhendel=Map<MoyenIntervention, bool>();
    bool bol;MoyenIntervention moy;

    mapM.length==0?m.forEach((mo) { mapM[mo] = false;}): {
      if(mapM.length<m.length){
        m.asMap().forEach((index, value) {
          bol =false;
          mapM.forEach((k,v) {
            if(k.id == value.id){bol = true; moy = k;
            }});
          if(bol == true){mapMoyensWhendel[value] = mapM[moy];}
          else{mapMoyensWhendel[value] =false;}

        })
      }
      else{
        mapM.forEach((key, value) {
          bol =false;
          m.forEach((md) { if(key.id == md.id){bol = true; moy = md;}});
          if(bol == true){mapMoyensWhendel[moy] = value;}
        }),

      },
      mapM = mapMoyensWhendel
    };
    mapM.forEach((k,v) {rows.add(_buildListItem(context, k, v));});
    return rows;
    //return  moyens.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, MoyenIntervention data, bool s) {
    String depart = data.departA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.departA);
    String arrivee = data.arriveA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.arriveA);
    String retour = data.retourneA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.retourneA);
    return (data.etat == Etat.enCours.toString())?DataRow(cells: [
      DataCell(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(data.moyen.codeMoyen),
            CircleAvatar(backgroundColor: data.couleur, radius: 10,)
        ],
      )
      ),
      DataCell(Text(DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.demandeA))),
      DataCell(Text(depart)),
      DataCell(Text(arrivee)),
      DataCell(Text(retour)),
      DataCell(Text(data.etat)),
    ],selected: s,
        onSelectChanged: (bool value) {

          setState(() {
            mapM[data] = value;
          });
        }):DataRow(cells: [
      DataCell(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.moyen.codeMoyen),
              CircleAvatar(backgroundColor: data.couleur, radius: 10,)
            ],
          )
      ),
      DataCell(Text(DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.demandeA))),
      DataCell(Text(depart)),
      DataCell(Text(arrivee)),
      DataCell(Text(retour)),
      DataCell(Text(data.etat)),
    ],);
  }


  List<DataRow> _buildListWithSelect(BuildContext context, List<MoyenIntervention> m) {
    List<DataRow> rows = List();
    Map<MoyenIntervention, bool> mapMoyensWhendel=Map<MoyenIntervention, bool>();
    bool bol;MoyenIntervention moy;

    mapMoyens.length==0?m.forEach((mo) { mapMoyens[mo] = false;}): {
      if(mapMoyens.length<m.length){
        m.asMap().forEach((index, value) {
          bol =false;
          mapMoyens.forEach((k,v) {
            if(k.id == value.id){bol = true; moy = k;
            }});
          if(bol == true){mapMoyensWhendel[value] = mapMoyens[moy];}
          else{mapMoyensWhendel[value] =false;}

        })
      }
      else{
        mapMoyens.forEach((key, value) {
          bol =false;
          m.forEach((md) { if(key.id == md.id){bol = true; moy = md;}});
          if(bol == true){mapMoyensWhendel[moy] = value;}
        }),

      },
      mapMoyens = mapMoyensWhendel
    };
    mapMoyens.forEach((k,v) {rows.add(_buildListItemWithSelect(context, k, v));});
    return rows;
  }
  DataRow _buildListItemWithSelect(BuildContext context, MoyenIntervention data, bool s){
    String depart = data.departA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.departA);
    String arrivee = data.arriveA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.arriveA);
    String retour = data.retourneA == null ? "Pas encore" : DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.retourneA);

    return DataRow(cells: [
      DataCell(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.moyen.codeMoyen),
              CircleAvatar(backgroundColor: data.couleur, radius: 10,)
            ],
          )
      ),
      DataCell(Text(DateFormat('yyyy-MM-dd  kk:mm:ss').format(data.demandeA))),
      DataCell(Text(depart)),
      DataCell(Text(arrivee)),
      DataCell(Text(retour)),
      DataCell(Text(data.etat)),
    ],
        selected: s,
        onSelectChanged: (bool value) {

          setState(() {
            mapMoyens[data] = value;
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
                                            null, null, _selectedColor, IconBasePathGetter.getImageBasePath(_selectedMoyen.codeMoyen)));
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
    String id = (this.intervention != null)? this.intervention.id: ' ';
    return StreamBuilder<DocumentSnapshot>(
      stream: InterventionService().getInterventionById(id),
        builder: (context, snapshot) {
          if (! snapshot.hasData) {
            return Center (
              child: CircularProgressIndicator(),
            );
          }
          if (! snapshot.data.exists) {
            return Center (
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    (id != ' ')? 'Intervention indisponible' : 'Aucune intervention séléctionnée',
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
          //
          List<MoyenIntervention> moyensEnAttenteNotif = new List<MoyenIntervention>();
          List<MoyenIntervention> moyensTous =this.intervention.moyens;
          moyensTous.forEach((m) { if(m.etat == Etat.enAttente.toString()) {moyensEnAttenteNotif.add(m);}});
          int nbEnAttente = moyensEnAttenteNotif.length;
          //
      return StreamBuilder<QuerySnapshot>(
          stream: AccountService.loadCurrentUser(),
          builder: (context, snapshot) {
            if (! snapshot.hasData) {
              return CircularProgressIndicator();
            }else{
              UserData userData = UserData.fromSnapshot(snapshot.data.docs[0]);

              return userData.role == Role.Operator?operatorVue(userData , context, nbEnAttente):intervenerVue(userData, context);

            }

          }
      );
  }
    );


  }
  Widget _showButtons(UserData userData) {
    return userData.role == Role.Intervener? Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text('Renvoyer'),
            onPressed: () {
              List<MoyenIntervention> toUpdate=List();
              //ici traitement pour renvoyer
              mapM.forEach((k,v) {
                if(v==true && k.etat==Etat.enCours.toString()){toUpdate.add(k);}
              });
              if(toUpdate.length>0) {
                interventionService
                    .updateEtatMoyensInterventionToRetourne(
                    this.intervention.id, toUpdate);
              }else{
                Fluttertoast.showToast(
                    msg: "Au moins un moyen en cours doit être séléctionné",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            },
          ),
          SizedBox(
            width: 60,
          ),
          ElevatedButton(
            child: Text('Demander des moyens'),
            onPressed: () {
              selectionMoyen();
            },
          ),
        ],
      ),
    ):Container();
  }

  Widget operatorVue(UserData userData, BuildContext context, int nbMoyensEnAttente) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Moyens' + '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
                '' +  DateFormat('yyyy-MM-dd  kk:mm:ss').format(this.intervention.getDate) +
                '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' + this.intervention.getNom +
                '\n\t\t\t\t\t\t\t\t\t\t\t\t' + '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
                '' + this.intervention.getAdresse),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Tous les moyens'),
                Tab(text: 'Moyens  à valider', icon: new Stack(
                  children: <Widget>[
                    new Icon(Icons.notifications),
                    new Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: nbMoyensEnAttente==0?Colors.grey:Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: new Text(
                          nbMoyensEnAttente.toString(),
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),),

              ],
            ),
          ),
          body: TabBarView(
            children: [
              StreamBuilder<DocumentSnapshot>(
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                        columnSpacing: 40,
                                        showCheckboxColumn: false,
                                        columns: columnsList(),
                                        rows: _buildListWithoutSelect(context, moyens)

                                    ),
                                  ),
                                ),
                                _showButtons(userData)
                              ],
                            )
                        )
                      ],
                    );
                  }
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: interventionService.getInterventionById(this.intervention.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    moyens = Intervention.fromSnapshot(snapshot.data).moyens;
                    moyensEnAttente=List();
                    moyens.forEach((m) { if(m.etat == Etat.enAttente.toString()) {moyensEnAttente.add(m);}});
                    return moyensEnAttente.length>0? ListView(
                      padding: EdgeInsets.all(20.0),
                      children: <Widget>[
                        SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 40,
                                      //showCheckboxColumn: false,
                                        columns: columnsList(),
                                        rows: _buildListWithSelect(context, moyensEnAttente)

                                    ),
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    child: Text('Valider'),
                                    onPressed: () {
                                      List<MoyenIntervention> toUpdate=List();
                                      //ici traitement pour valider
                                      mapMoyens.forEach((k,v) {
                                      if(v==true){toUpdate.add(k);}
                                      });
                                      if(toUpdate.length>0) {
                                        interventionService
                                            .updateEtatMoyensInterventionToPrevu(
                                            this.intervention.id, toUpdate);
                                      }else{
                                        Fluttertoast.showToast(
                                            msg: "Au moins un moyen doit être séléctionné",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.TOP,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            )
                        )
                      ],
                    ):Center(child: Text('Pas de moyens à valider'),);
                  }
              )

            ],
          )
      ),
    );
  }
  Widget intervenerVue(UserData userData, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moyens' + '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
            '' +  DateFormat('yyyy-MM-dd  kk:mm:ss').format(this.intervention.getDate) +
            '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' + this.intervention.getNom +
            '\n\t\t\t\t\t\t\t\t\t\t\t\t' + '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t' +
            '' + this.intervention.getAdresse),
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columnSpacing: 40,
                                //showCheckboxColumn: false,
                                columns: columnsList(),
                                rows: _buildList(context, moyens)

                            ),
                          ),
                        ),
                        _showButtons(userData)
                      ],
                    )
                )
              ],
            );
          }
      ),
    );
  }

}