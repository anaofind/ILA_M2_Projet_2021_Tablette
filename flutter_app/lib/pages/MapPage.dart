import 'package:flutter/material.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Moyen.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/SelectorMoyenSymbol.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key, this.intervention}) : super(key: key);

  final Intervention intervention;

  @override
  MapPageState createState() => MapPageState(this.intervention);
}

class MapPageState extends State<MapPage> {

  final interventionService = InterventionService();

  final List<Marker> markers = [];
  final Intervention intervention;
  int idSymbolSelected = -1;
  MapPageState(this.intervention);

  double currentZoom = 9.0;
  double maxZoom = 18.0;
  double minZoom = 9.0;
  LatLng currentCenter = LatLng(48.0833 , -1.6833);

  MapController mapController = MapController();

  @override
  void initState() {
    this.refreshMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              if (SelectorMoyenSymbol.type == 'moyen') {

              } else if (SelectorMoyenSymbol.type == 'symbol') {
                SymbolIntervention symbol = SymbolIntervention(
                    SelectorMoyenSymbol.name,
                    Position(latLng.latitude, latLng.longitude)
                );
                if (this.checkSymbol(symbol)) {
                  this.intervention.symbols.add(symbol);
                  this.interventionService.updateIntervention(intervention);
                }
              }
              createMarker(latLng, SelectorMoyenSymbol.getPathImage());
            }
          },
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",//?source=${DateTime.now().millisecondsSinceEpoch}",
              subdomains: ['a', 'b', 'c']
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
                  this.setState(() {
                    this.intervention.symbols.clear();
                    this.interventionService.updateIntervention(this.intervention);
                    this.idSymbolSelected = -1;
                    this.refreshMarkers();
                  });
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

  zoomPlus() {
    this.currentZoom = (this.currentZoom < this.maxZoom)? this.currentZoom + 1 : this.maxZoom;
    this.mapController.move(mapController.center, this.currentZoom);
  }

  zoomMinus() {
    this.currentZoom = (this.currentZoom > this.minZoom)? this.currentZoom - 1 : this.minZoom;
    this.mapController.move(mapController.center, this.currentZoom);
  }

  createMarker(LatLng latLng, String pathImage) {
    print("CREATE MARKER");
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
    this.setState(() {
      this.markers.add(marker);
    });
  }

  refreshMarkers() {
    markers.clear();
    for (int i = 0; i<this.intervention.moyens.length; i++) {
      MoyenIntervention moyen = this.intervention.moyens[i];
      if (this.checkMoyen(moyen)) {
        LatLng position = LatLng(moyen.position.latitude, moyen.position.longitude);
        String pathImage = SelectorMoyenSymbol.getPathImageByName(moyen.moyen.codeMoyen);
        createMarker(position, pathImage);
      }
    }
    for (int i = 0; i<this.intervention.symbols.length; i++) {
      SymbolIntervention symbol = this.intervention.symbols[i];
      if (this.checkSymbol(symbol)) {
        LatLng position = LatLng(symbol.position.latitude, symbol.position.longitude);
        String pathImage = SelectorMoyenSymbol.getPathImageByName(symbol.nomSymbol);
        createMarker(position, pathImage);
      }
    }
  }

  bool checkMoyen(MoyenIntervention moyen) {
    if (moyen != null) {
      Position position = moyen.position;
      if (position != null && position.latitude != null && position.longitude != null) {
        String name = moyen.moyen.codeMoyen;
        if (name != null && SelectorMoyenSymbol.getPathImageByName(name) != null) {
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
        String name = symbol.nomSymbol;
        if (name != null && SelectorMoyenSymbol.getPathImageByName(name) != null) {
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
