import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/services/NavigatorPage.dart';
import 'package:flutter_app/services/SelectorIntervention.dart';
import '../../models/Intervention.dart';
import '../../services/InterventionService.dart';
import '../NewInterventionPage.dart';
import '../SitacPage.dart';
import 'InterventionPage.dart';
import 'package:intl/intl.dart';


class ListInterventionPage extends StatefulWidget {

  @override
  _ListInterventionPage createState() => _ListInterventionPage();
}

class _ListInterventionPage extends State<ListInterventionPage> {
  InterventionService _interventionService;
  _ListInterventionPage(){
    _interventionService = InterventionService();
  }

  int selectedIndex = 0, iLigne = 0;
  List<Intervention> _laListe = []; //retrieve list on firebase
  BuildContext _context;
  bool _isAdmin = true;
  int _currentSortColumn = 3;
  bool _isAscending = true;

  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return  snapshot.map((data) => _buildListItem(context, data)).toList();
  }



  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {

    final intervention = Intervention.fromSnapshot(data);
    return DataRow(cells: [
      DataCell(Text(intervention.nom)),
      DataCell(Text(intervention.codeSinistre)),
      DataCell(Text(intervention.adresse)),
      DataCell(Text(DateFormat('yyyy-MM-dd  kk:mm:ss').format(intervention.date)))
    ],
        onSelectChanged: (ind) {
          setState(() {
            showIntervention(data);
          });
        });
  }


  void showIntervention(DocumentSnapshot doc) {
    Intervention intervention = Intervention.fromSnapshot(doc);
    SelectorIntervention.selectIntervention(intervention);
    NavigatorPage.navigateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    //afficher le + selon le rôle
    _context = context;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Liste des interventions'),
        ),
        body: StreamBuilder<QuerySnapshot>(
        stream: _interventionService.loadAllInterventions(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: DataTable(
                            sortColumnIndex: _currentSortColumn,
                            sortAscending: _isAscending,
                            showCheckboxColumn: false,
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Nom',
                                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Code sinistre',
                                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Adresse',
                                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Date',
                                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                ),)

                            ],
                            rows: _buildList(context, snapshot.data.docs)
                          /*snapshot.data.docs.map((DocumentSnapshot document) {
                      /*_laListe.add(
                          Intervention(document.id, document.data()['nom'],
                              document.data()['adresse'], document.data()['codeSinistre'],
                              document.data()['date'].toDate(), document.data()['moyens'].cast<List<MoyenIntervention>>())
                      );*/
                      return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(document.data()['nom'])),
                            DataCell(Text(document.data()['codeSinistre'])),
                            DataCell(Text(document.data()['adresse'])),
                            DataCell(Text(document.data()['date'].toDate().toString())),
                          ],
                          onSelectChanged: (ind) {
                            setState(() {
                              showIntervention(document);
                            });
                          }
                      );
                    }
                    ).toList(),*/
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

  Container _showAddButton() {
    if(!_isAdmin) {
      return Container();
    } else {
      return Container(

        child: ElevatedButton(
          child: Text('Nouvelle intervention'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewInterventionPage())
            );
          },
        ),
      );
    }
  }
}