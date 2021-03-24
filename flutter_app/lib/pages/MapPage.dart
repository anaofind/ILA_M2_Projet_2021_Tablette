
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/lib-ext/dragmarker.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/services/HydrantService.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/SelectorMoyenSymbol.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';
import 'package:smart_select/smart_select.dart';

import '../models/MoyenIntervention.dart';
import '../services/HydrantService.dart';



class MapPage extends StatefulWidget {
  MapPage({Key key, this.intervention}): super(key: key);

  Intervention intervention;

  @override
  MapPageState createState() => MapPageState(this.intervention);
}

class MapPageState extends State<MapPage> {
  final interventionService = InterventionService();

  final List<DragMarker> markers = [];
  final List<DragMarker> markersFixed = [];
  final List<DragMarker> markersDialog = [];
  final List<dynamic> moyensOrSymbols = [];
  Intervention intervention;
  int idSymbolSelected = -1;

  MapPageState(this.intervention) {
    adressFound = false;
    center(this.intervention).then((value) {
      if (value != null) {
        this.currentCenter = value;
      }
      adressFound = true;
      HydrantService.createHydrantsData(this.currentCenter).then((value) {
        this.setState(() {});
      });
    });
  }

  double currentZoom = 18.0;
  double maxZoom = 18.0;
  double minZoom = 9.0;
  LatLng currentCenter = LatLng(48.0833 , -1.6833);
  bool adressFound = false;
  MapController mapController = MapController();

  Future<LatLng> center(Intervention inter) async {
    List<Address> addresses = await Geocoder.local.findAddressesFromQuery(inter.adresse);
    if (addresses.length > 0) {
      Address first = addresses.first;
      return LatLng(first.coordinates.latitude, first.coordinates.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: this.interventionService.getInterventionById(intervention.id),
        builder: (context, snapshot) {
          print("REFRESH MAP");
          if (!snapshot.hasData || snapshot.hasError || ! adressFound || ! HydrantService.finished) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          this.intervention = Intervention.fromSnapshot(snapshot.data);
          this.refreshMarkers();
          return Scaffold(
            body: FlutterMap(
              mapController: this.mapController,
              options: MapOptions(
                plugins: [
                  DragMarkerPlugin(),
                ],
                center: this.currentCenter,
                zoom: this.currentZoom,
                maxZoom: this.maxZoom,
                minZoom: this.minZoom,
                interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                onTap:(LatLng latLng) async{
                  if (SelectorMoyenSymbol.isSelected()) {
                    Position position = Position(latLng.latitude, latLng.longitude);
                    if (SelectorMoyenSymbol.moyenId > -1) {
                      if (SelectorMoyenSymbol.moyenId < this.intervention.moyens.length) {
                        MoyenIntervention moyen = this.intervention.moyens[SelectorMoyenSymbol.moyenId];
                        this.intervention.moyens.removeAt(SelectorMoyenSymbol.moyenId);
                        moyen.position = position;
                        this.intervention.moyens.add(moyen);
                        this.interventionService.updateIntervention(this.intervention);
                      }
                    } else {
                      dynamic symbolOrMoyen = SymbolDecider.createObjectRelatedToSymbol(SelectorMoyenSymbol.pathImage, position);
                      this.interventionService.addMoyenOrSymbolToIntervention(this.intervention.id, symbolOrMoyen);
                    }
                    SelectorMoyenSymbol.deselect();
                  } else {
                    this.idSymbolSelected = -1;
                    this.setState(() {});
                  }
                },
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png?osm_id=216165",
                  subdomains: ['a', 'b', 'c'],
                  keepBuffer: 6,
                  tileSize: 256,
                ),
                DragMarkerPluginOptions(
                    markers: this.markersFixed + this.markers + this.markersDialog,
                ),
              ],
            ),
            floatingActionButton: Row(
              children: [
                Column(
                  children: [
                    Spacer(),
                    FloatingActionButton(
                      child: Icon(Icons.clear),
                      backgroundColor: Colors.redAccent,
                      onPressed: () {
                        this.idSymbolSelected = -1;
                        this.intervention.symbols.clear();
                        this.intervention.moyens.forEach((element) {
                          element.position.latitude = null;
                          element.position.longitude = null;
                        });
                        this.interventionService.updateIntervention(this.intervention);
                      },
                    ),
                  ],
                ),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
                Spacer(),
                Column(
                  children: [
                    Spacer(),
                    FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: zoomPlus,
                      backgroundColor: Colors.lightGreen,
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.remove),
                      onPressed: zoomMinus,
                      backgroundColor: Colors.green,
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          );
        }
    );
  }

  zoomPlus() {
    this.currentZoom = (this.currentZoom < this.maxZoom)? this.currentZoom + 1 : this.maxZoom;
    this.mapController.move(mapController.center, this.currentZoom);
  }

  zoomMinus() {
    this.currentZoom = (this.currentZoom > this.minZoom)? this.currentZoom - 1 : this.minZoom;
    this.mapController.move(mapController.center, this.currentZoom);
  }

  createMarkerFixed(LatLng latLng, String pathImage) {
    DragMarker m = DragMarker(
      point: latLng,
      width: 80.0,
      height: 80.0,
      builder: (ctx) => Container(
        child: IconButton(
          icon : this.getImage(pathImage, 80),
          iconSize: 80,
        ),
      ),
      onDragEnd:    (details,point) {
        this.setState(() {});
      }
    );
    this.markersFixed.add(m);
  }

  createMarkerDialog(LatLng latLng, MoyenIntervention moyen) {
    print("CREATE DIALOG MARKER");
    int id = markersDialog.length;
    DragMarker dm = DragMarker(
      point: latLng,
      width: 90,
      height: 90,
      builder: (ctx) => Container(
        child: SmartSelect<String>.single(
            title: 'Etat moyen : ' + moyen.moyen.codeMoyen,
            value: moyen.etat,
            choiceItems: [
              S2Choice<String>(value: "Etat.prevu", title: 'Prevu'),
              S2Choice<String>(value: 'Etat.enAttente', title: 'En attente'),
              S2Choice<String>(value: 'Etat.enCours', title: 'En cours'),
            ],
            onChange: (state) => setState(() {
              this.interventionService.updateIntervention(this.intervention);
              this.markersDialog.clear();
            })
        ),
      ),
    );
    this.markersDialog.add(dm);
  }

  createMarker(LatLng latLng, String pathImage) {
    print("CREATE DRAG MARKER");
    int id = markers.length;
    double widthMarker = (id != this.idSymbolSelected)? 80.0 : 300.0;
    double heightMarker = (id != this.idSymbolSelected)? 80.0 : 300.0;
    Color color = (this.idSymbolSelected == id)? Colors.purple : Colors.red;
    DragMarker dm = DragMarker(
      point: latLng,
      width: widthMarker,
      height: heightMarker,
      offset: Offset(0.0, 0.0),
      builder: (ctx) => Container(
        child: IconButton(
          icon : this.getSymbolWidget(id, widthMarker),
          onPressed: () {
            print("if moyen change etat on click");
            this.setState(() {
              if (idSymbolSelected == id) {
                idSymbolSelected = -1;
              } else {
                idSymbolSelected = id;
              }
              this.refreshMarkers();
            });
          },
        ),
      ),
      onDragStart:  (details,point) => print("Start point $point"),
      onDragEnd:    (details,point) {
        dynamic symbolOrMoyen = this.moyensOrSymbols[id];
        Position position = Position(point.latitude, point.longitude);
        this.interventionService.updatePositionMoyenOrSymbolIntervention(this.intervention.id, symbolOrMoyen, position);
        SelectorMoyenSymbol.deselect();
      },
    );

    this.markers.add(dm);
  }

  refreshMarkers() {
    markersFixed.clear();
    print(HydrantService.hydrants.length);
    HydrantService.hydrants.forEach((element) {
      LatLng position = LatLng(element.position.latitude, element.position.longitude);
      SymbolIntervention symbol = element.getSymbol();
      if (symbol != null) {
        String pathImage = SymbolDecider.createIconPathRelatedToObject(element.getSymbol());
        this.createMarkerFixed(position, pathImage);
      }
    });
    markers.clear();
    moyensOrSymbols.clear();
    for (int i = 0; i<this.intervention.moyens.length; i++) {
      MoyenIntervention moyen = this.intervention.moyens[i];
      if (this.checkMoyen(moyen)) {
        moyensOrSymbols.add(moyen);
        LatLng position = LatLng(moyen.position.latitude, moyen.position.longitude);
        String pathImage = SymbolDecider.createIconPathRelatedToObject(moyen);
        this.createMarker(position, pathImage);
      }
    }
    for (int i = 0; i<this.intervention.symbols.length; i++) {
      SymbolIntervention symbol = this.intervention.symbols[i];
      if (this.checkSymbol(symbol)) {
        moyensOrSymbols.add(symbol);
        LatLng position = LatLng(symbol.position.latitude, symbol.position.longitude);
        String pathImage = SymbolDecider.createIconPathRelatedToObject(symbol);
        this.createMarker(position, pathImage);
      }
    }
  }

  bool checkMoyen(MoyenIntervention moyen) {
    if (moyen != null) {
      Position position = moyen.position;
      if (position != null && position.latitude != null && position.longitude != null) {
        if (moyen != null && SymbolDecider.createIconPathRelatedToObject(moyen) != null) {
          return true;
        }
      }
    }
    return false;
  }

  bool checkSymbol(SymbolIntervention symbol) {
    if (symbol != null) {
      Position position = symbol.position;
      if (position != null && position.latitude != null && position.longitude != null) {
        if (symbol != null && SymbolDecider.createIconPathRelatedToObject(symbol) != null) {
          return true;
        }
      }
    }
    return false;
  }


  Widget getSymbolWidget(int idMarker, double size) {
    print("if moyen change etat on click");
    if (idMarker >= 0 && idMarker < this.moyensOrSymbols.length) {
      dynamic moyenOrSymbol = this.moyensOrSymbols[idMarker];
      String pathImage = SymbolDecider.createIconPathRelatedToObject(moyenOrSymbol);
      if (idMarker == this.idSymbolSelected && moyenOrSymbol is MoyenIntervention && this.checkMoyen(moyenOrSymbol)) {
        return this.getMoyenSelectedWidget(moyenOrSymbol, pathImage);
      }
      return getImage(pathImage, size);
    }
  }

  Widget getMoyenSelectedWidget(MoyenIntervention moyen, String pathImage) {
    List<DropdownMenuItem<String>> items = <String>["Prevu", "En attente", "En cours"].map<DropdownMenuItem<String>>((String val) {
      return DropdownMenuItem<String>(
        value: val,
        child: Text(val),
      );
    }).toList();
    int idValue = 0;
    switch (moyen.etat) {
      case 'Etat.prevu' :
        idValue = 0;
        break;
      case 'Etat.enAttente' :
        idValue = 1;
        break;
      case 'Etat.enCours' :
        idValue = 2;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Column(
        children: [
          Flexible(
              flex: 1,
              child: this.getImage(pathImage, 100)
          ),
          Flexible(
            flex: 5,
            child: AlertDialog(
              title: Center(child: Text("Etat du moyen", style: TextStyle(fontSize: 20),)),
              content: DropdownButton<String>(
                items: items,
                value: items[idValue].value,
                onChanged: (String newVal) {
                  switch(newVal) {
                    case "Prevu" :
                      moyen.etat = "Etat.prevu";
                      break;
                    case "En attente" :
                      moyen.etat = "Etat.enAttente";
                      break;
                    case "En cours" :
                      moyen.etat = "Etat.enCours";
                      break;
                  }
                  this.interventionService.updateIntervention(intervention);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Image getImage(String pathImage, double size) {
    if (pathImage != null) {
      return Image(
        image: new AssetImage(pathImage),
        width: size,
        height: size,
      );
    }
  }
}