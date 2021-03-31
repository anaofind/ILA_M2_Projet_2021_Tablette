
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/lib-ext/dragmarker.dart';
import 'package:flutter_app/models/AddressSuggestion.dart';
import 'package:flutter_app/models/Drone.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/InterestPoint.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/services/AddressService.dart';
import 'package:flutter_app/services/HydrantService.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/services/SelectorMoyenSymbol.dart';
import 'package:flutter_app/services/SelectorSitac.dart';
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
  final List<DragMarker> markersDrone = [];

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
    List<Feature> addresses = await AddressService().fetchSuggestions(this.intervention.adresse);
    if (addresses.length > 0) {
      Feature first = addresses.first;
      return LatLng(first.geometry.coordinates[1], first.geometry.coordinates[0]);
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
                  Position position = Position(latLng.latitude, latLng.longitude);
                  if (SelectorSitac.indexTabBar == 6) {
                    this.intervention.futureMission.interestPoints.add(InterestPoint(position));
                    this.interventionService.updateIntervention(this.intervention);
                  } else {
                    if (SelectorMoyenSymbol.isSelected()) {
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
                      if (this.idSymbolSelected >= 0) {
                        this.setState(() {
                          this.idSymbolSelected = -1;
                        });
                      }
                    }
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
                    markers: this.markersFixed + this.markers + this.markersDrone,
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
                        if (SelectorSitac.indexTabBar == 6) {
                          this.intervention.futureMission.interestPoints.clear();
                        } else {
                          if (SelectorSitac.indexTabBar == 0) {
                            this.intervention.moyens.forEach((element) {
                              element.position.latitude = null;
                              element.position.longitude = null;
                            });
                          } else {
                            this.intervention.symbols.clear();
                          }
                        }
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

  createMarkerInterestPoint(LatLng latLng) {
    print("CREATE DRAG MARKER");
    int num = markersDrone.length+1;
    InterestPoint interestPoint = this.intervention.futureMission.interestPoints[num-1];
    Color color = Colors.purple;
    DragMarker dm = DragMarker(
      point: latLng,
      width: 60.0,
      height: 60.0,
      offset: Offset(0.0, 0.0),
      builder: (ctx) => Container(
        decoration: new BoxDecoration(
          color: (interestPoint.photo)? Colors.yellow.withOpacity(0.5) : Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: IconButton(
            icon : Text(
                "P"+ num.toString(),
              style: TextStyle(
                color: (interestPoint.photo)? Colors.black : Colors.white
              ),
            ),
            color: color,
            iconSize: 60
        ),
      ),
      onDragEnd: (details,point) {
        Position position = Position(point.latitude, point.longitude);
        interestPoint.position = position;
        this.interventionService.updateIntervention(this.intervention);
      }
    );

    this.markersDrone.add(dm);
  }

  createMarkerDrone(LatLng latLng) {
    DragMarker dm = DragMarker(
      point: latLng,
      width: 80,
      height: 80,
      offset: Offset(0.0, 0.0),
      builder: (ctx) => Container(
        child: IconButton(
          icon : Image(
            image : AssetImage('Icone_Png/drone.png'),
            width: 80,
            height: 80,
          ),
          onPressed: () {
          },
        ),
      ),
      onDragEnd:    (details,point) {
        this.setState(() {});
      },
    );

    this.markersDrone.add(dm);
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
    this.markersDrone.clear();
    if (SelectorSitac.indexTabBar == 6) {
      this.intervention.futureMission.interestPoints.forEach((element) {
        LatLng position = LatLng(element.position.latitude, element.position.longitude);
        this.createMarkerInterestPoint(position);
      });
      Drone drone = this.intervention.drone;
      if (drone != null && drone.position != null && drone.position.longitude != null && drone.position.latitude != null) {
        LatLng position = LatLng(drone.position.latitude, drone.position.longitude);
        this.createMarkerDrone(position);
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
    List<DropdownMenuItem<String>> items = <String>["Prevu", "En cours", "Retourne"].map<DropdownMenuItem<String>>((String val) {
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
      case 'Etat.enCours' :
        idValue = 1;
        break;
      case 'Etat.retourne' :
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
                    case "En cours" :
                      moyen.etat = "Etat.enCours";
                      moyen.arriveA = DateTime.now();
                      break;
                    case "Retourne" :
                      moyen.etat = "Etat.retourne";
                      moyen.retourneA = DateTime.now();
                      moyen.position.latitude = null;
                      moyen.position.longitude = null;
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