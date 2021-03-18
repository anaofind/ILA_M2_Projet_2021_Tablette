import 'package:flutter/material.dart';
import 'package:flutter_app/lib-ext/dragmarker.dart';
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

  final Intervention intervention;

  @override
  MapPageState createState() => MapPageState(this.intervention);
}

class MapPageState extends State<MapPage> {

  final interventionService = InterventionService();
  //final List<Marker> markers = [];
  final List<DragMarker> dragMarkers = [];

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
              //createMarker(latLng, SelectorMoyenSymbol.getPathImage());
              createDragMarker(latLng, SelectorMoyenSymbol.getPathImage());
            }
          },
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",//?source=${DateTime.now().millisecondsSinceEpoch}",
              subdomains: ['a', 'b', 'c']
          ),
          /*new MarkerLayerOptions(
              markers: markers
          ),*/
          DragMarkerPluginOptions(
            markers: dragMarkers,
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

  /*createMarker(LatLng latLng, String pathImage) {
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
  }*/

  createDragMarker(LatLng latLng, String pathImage) {
    print("CREATE DRAG MARKER");
    int id = dragMarkers.length;
    Color color = (this.idSymbolSelected == id)? Colors.purple : Colors.red;
    DragMarker dm = DragMarker(
      point: latLng,
      width: 80.0,
      height: 80.0,
      offset: Offset(0.0, -8.0),
      builder: (ctx) => Container(
        child: IconButton(
          icon : this.getImage(pathImage, 60),
          color: color,
          iconSize: 60,
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
        //update intervention and make refresh
        //look for symbol in list of intervention's symbol
        int i=0;
        while(i<this.intervention.symbols.length && SelectorMoyenSymbol.getPathImageByName(this.intervention.symbols[i].nomSymbol) != pathImage) {
          i++;
        }
        this.intervention.symbols[i].position = Position(point.latitude, point.longitude);
        this.interventionService.updateIntervention(intervention);
      },
      onDragUpdate: (details,point) {},
      onTap:        (point) {},
      onLongPress:  (point) {},
      feedbackBuilder: (ctx) => Container(
        child: IconButton(
          icon : this.getImage(pathImage, 60),
          color: color,
          iconSize: 60,
        ),
      ),
      feedbackOffset: Offset(0.0, -18.0),
      updateMapNearEdge: true,
      nearEdgeRatio: 2.0,
      nearEdgeSpeed: 1.0,
    );

    this.setState(() {
      this.dragMarkers.add(dm);
    });
  }

  refreshMarkers() {
    dragMarkers.clear();
    for (int i = 0; i<this.intervention.moyens.length; i++) {
      MoyenIntervention moyen = this.intervention.moyens[i];
      if (this.checkMoyen(moyen)) {
        LatLng position = LatLng(moyen.position.latitude, moyen.position.longitude);
        String pathImage = SelectorMoyenSymbol.getPathImageByName(moyen.moyen.codeMoyen);
        createDragMarker(position, pathImage);
        String pathImage = SymbolDecider.createIconPathRelatedToObject(moyen);
        createMarker(position, pathImage);
      }
    }

    for (int i = 0; i<this.intervention.symbols.length; i++) {
      SymbolIntervention symbol = this.intervention.symbols[i];
      if (this.checkSymbol(symbol)) {
        LatLng position = LatLng(symbol.position.latitude, symbol.position.longitude);
        String pathImage = SelectorMoyenSymbol.getPathImageByName(symbol.nomSymbol);
        createDragMarker(position, pathImage);
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
