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
import 'package:latlong/latlong.dart';

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
  final List<dynamic> moyensOrSymbols = [];
  Intervention intervention;
  int idSymbolSelected = -1;
  MapPageState(this.intervention) {
    HydrantService.createHydrantsData(this.currentCenter).then((value) => this.setState(() {}));
  }

  double currentZoom = 18.0;
  double maxZoom = 18.0;
  double minZoom = 9.0;
  LatLng currentCenter = LatLng(48.0833 , -1.6833);

  MapController mapController = MapController();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: this.interventionService.getInterventionById(intervention.id),
        builder: (context, snapshot) {
          print("REFRESH MAP");
          if (!snapshot.hasData || snapshot.hasError) {
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
                    markers: this.markersFixed + this.markers,
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

  createMarker(LatLng latLng, String pathImage) {
    print("CREATE DRAG MARKER");
    int id = markers.length;
    Color color = (this.idSymbolSelected == id)? Colors.purple : Colors.red;
    DragMarker dm = DragMarker(
      point: latLng,
      width: 80.0,
      height: 80.0,
      offset: Offset(0.0, 0.0),
      builder: (ctx) => Container(
        child: IconButton(
          icon : this.getImage(pathImage, 80),
          color: color,
          iconSize: 80,
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
      feedbackBuilder: (ctx) => Container(
        child: IconButton(
          icon : this.getImage(pathImage, 120),
          color: color,
          iconSize: 120,
        ),
      ),
      feedbackOffset: Offset(0.0, 0.0),
      updateMapNearEdge: true,
      nearEdgeRatio: 2.0,
      nearEdgeSpeed: 1.0,
    );

    this.markers.add(dm);
  }

  refreshMarkers() {
    markersFixed.clear();
    HydrantService.hydrants.forEach((element) {
      LatLng position = LatLng(element.position.latitude, element.position.longitude);
      String pathImage = SymbolDecider.createIconPathRelatedToObject(element.getSymbol());
      this.createMarkerFixed(position, pathImage);
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