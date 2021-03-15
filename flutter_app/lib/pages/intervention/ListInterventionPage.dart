import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/Intervention.dart';
import '../../services/InterventionService.dart';
import 'InterventionPage.dart';


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

  void showIntervention(DocumentSnapshot doc) {
    Navigator.push(_context, MaterialPageRoute(builder: (BuildContext context) {
      return InterventionPage(
          Intervention(doc.id, doc.data()['nom'], doc.data()['adresse'],
              doc.data()['codeSinistre'], doc.data()['date'].toDate(), doc.data()['moyens'])
          );
    }));
  }

  @override
  Widget build(BuildContext context) {
    //afficher le + selon le rôle
    _context = context;
    return StreamBuilder<QuerySnapshot>(
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
                    columns: [
                      DataColumn(label: Text("Nom")),
                      DataColumn(label: Text("Code sinistre")),
                      DataColumn(label: Text("Adresse")),
                      DataColumn(label: Text("Date")),
                    ],
                    rows: snapshot.data.docs.map((DocumentSnapshot document) {

                      _laListe.add(
                          Intervention(document.id, document.data()['nom'],
                              document.data()['adresse'], document.data()['codeSinistre'],
                              document.data()['date'].toDate(), document.data()['moyens'])
                      );

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
                    }).toList(),
                  ),
                ),
                _showAddButton()
              ],
            )
            )
          ],
        );
      }
    );
  }

  Container _showAddButton() {
    if(!_isAdmin) {
      return Container();
    } else {
      return Container(
        child: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: Text('Add'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
}