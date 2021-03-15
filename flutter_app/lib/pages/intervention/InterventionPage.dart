import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Intervention.dart';

class InterventionPage extends StatefulWidget {
  Intervention _monIntervention;
  InterventionPage(Intervention uneInter) {
    _monIntervention = uneInter;
  }
  @override
  _InterventionPage createState() => _InterventionPage(_monIntervention);
}

class _InterventionPage extends State<InterventionPage> {
  Intervention _monIntervention;

  _InterventionPage(Intervention uneI) {
    _monIntervention = uneI;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_monIntervention.getNom),
      ),
      body: Container(),
    );
  }
}