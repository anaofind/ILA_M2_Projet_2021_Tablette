import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/Intervention.dart';
import 'InterventionPage.dart';


class ListInterventionPage extends StatefulWidget {

  @override
  _ListInterventionPage createState() => _ListInterventionPage();
}

class _ListInterventionPage extends State<ListInterventionPage> {
  _ListInterventionPage(){
    _laListe.add(new Intervention("Intervention 1", "I1", "Ici", DateTime.now()));
    _laListe.add(new Intervention("Intervention 2", "I2", "Istic", DateTime.now()));
    _laListe.add(new Intervention("Intervention 3", "I1", "Ici", DateTime.now()));
    _laListe.add(new Intervention("Intervention 4", "I2", "Istic", DateTime.now()));
    _laListe.add(new Intervention("Intervention 5", "I1", "Ici", DateTime.now()));
    _laListe.add(new Intervention("Intervention 6", "I2", "Istic", DateTime.now()));
  }

  int selectedIndex = 0;
  List<Intervention> _laListe = []; //retieve list on firebase
  BuildContext _context;
  bool _isAdmin = true;
  DataRow getRow(int numLigne) {
    return DataRow(
      selected: selectedIndex == numLigne,
      cells: <DataCell>[
        DataCell(Text(_laListe[numLigne].getNom)),
        DataCell(Text(_laListe[numLigne].getCode)),
        DataCell(Text(_laListe[numLigne].getAdresse)),
        DataCell(Text(_laListe[numLigne].getDate.toString())),
      ],
      onSelectChanged: (index) {
        setState(() {
          selectedIndex = numLigne;
          showIntervention(numLigne);
        });
      }
    );
  }

  void showIntervention(int numI) {
      Navigator.push(_context, MaterialPageRoute(builder: (BuildContext context) {
        return InterventionPage(_laListe[numI]);
      }));
  }

  @override
  Widget build(BuildContext context) {
    //afficher le + selon le rôle
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Interventions"),
      ),
      body: SingleChildScrollView(
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
                rows: List.generate(_laListe.length, (index) => getRow(index)),
              ),
            ),
            _showAddButton()
          ],
        )
      )
    );
  }

  Container _showAddButton() {
    if(_isAdmin) {
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
    } else {
      return Container();
    }
  }
}