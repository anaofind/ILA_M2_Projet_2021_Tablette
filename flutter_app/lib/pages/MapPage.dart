import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/SelectorMoyenSymbol.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.intervention}) : super(key: key);

  Intervention intervention;

  @override
  MapPageState createState() => MapPageState(this.intervention);
}

class MapPageState extends State<MapPage> {

  final interventionService = InterventionService();

  final List<Marker> markers = [];
  Intervention intervention;
  int idSymbolSelected = -1;
  MapPageState(this.intervention);

  double currentZoom = 9.0;
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
                center: this.currentCenter,
                zoom: this.currentZoom,
                maxZoom: this.maxZoom,
                minZoom: this.minZoom,
                interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                onTap:(LatLng latLng) async{
                  if (SelectorMoyenSymbol.isSelected()) {
                    Position position = Position(latLng.latitude, latLng.longitude);
                    dynamic symbolOrMoyen = SymbolDecider.createObjectRelatedToSymbol(SelectorMoyenSymbol.pathImage, position);
                    this.interventionService.addMoyenOrSymbolToIntervention(this.intervention.id, symbolOrMoyen);
                    SelectorMoyenSymbol.deselect();
                  }
                },
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  keepBuffer: 6,
                  tileSize: 256,
                ),
                new MarkerLayerOptions(
                    markers: markers
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

  createMarker(LatLng latLng, String pathImage) {
    int id = markers.length;
    Color color = (this.idSymbolSelected == id)? Colors.purple : Colors.red;
    Marker marker = new Marker(
      width: 60.0,
      height: 60.0,
      point: latLng,
      builder: (context) => new Container(
        child: IconButton(
          icon : this.getImage(pathImage, 60),
          color: color,
          iconSize: 60,
          onPressed: () {
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
    );

    this.markers.add(marker);
  }

  refreshMarkers() {
    markers.clear();
    for (int i = 0; i<this.intervention.moyens.length; i++) {
      MoyenIntervention moyen = this.intervention.moyens[i];
      if (this.checkMoyen(moyen)) {
        LatLng position = LatLng(moyen.position.latitude, moyen.position.longitude);
        String pathImage = SymbolDecider.createIconPathRelatedToObject(moyen);
        createMarker(position, pathImage);
      }
    }
    for (int i = 0; i<this.intervention.symbols.length; i++) {
      SymbolIntervention symbol = this.intervention.symbols[i];
      if (this.checkSymbol(symbol)) {
        LatLng position = LatLng(symbol.position.latitude, symbol.position.longitude);
        String pathImage = SymbolDecider.createIconPathRelatedToObject(symbol);
        createMarker(position, pathImage);
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