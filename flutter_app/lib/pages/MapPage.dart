import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {

  final List<Marker> markers = [];
  final List<Color> colorsMarkers = [];
  Color colorMarker = Colors.red;
  int idMarkerSelected = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(48.0833 , -1.6833),
          zoom: 9.0,
          maxZoom: 18,
          minZoom: 9,
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          onTap:(LatLng latLng) {
            createMarker(latLng, this.colorMarker);
          },
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']
          ),
          new MarkerLayerOptions(
            markers: markers
          ),
        ],
      ),
      floatingActionButton : Row(
        children: [
          Spacer(),
          FloatingActionButton (
            child: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                markers.clear();
                colorsMarkers.clear();
                idMarkerSelected = -1;
              });
            },
          ),
          Spacer(),
          FloatingActionButton (
            backgroundColor: Colors.red,
            onPressed: () {
              colorMarker = Colors.red;
            },
          ),
          FloatingActionButton (
            backgroundColor: Colors.blue,
            onPressed: () {
              colorMarker = Colors.blue;
            },
          ),
          FloatingActionButton (
            backgroundColor: Colors.green,
            onPressed: () {
              colorMarker = Colors.green;
            },
          ),
          FloatingActionButton (
            backgroundColor: Colors.black,
            onPressed: () {
              colorMarker = Colors.black;
            },
          ),
          FloatingActionButton (
            backgroundColor: Colors.white,
            onPressed: () {
              colorMarker = Colors.white;
            },
          ),
        ],
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  createMarker(LatLng latLng, Color color) {
    int id = markers.length;
    Color colorMarker = color;
    colorsMarkers.add(colorMarker);
    Color c = id != this.idMarkerSelected? colorMarker : Colors.deepPurple;
    this.setState(() {
      Marker marker = new Marker(
        width: 45.0,
        height: 45.0,
        point: latLng,
        builder: (context) => new Container(
          child: IconButton(
            icon : Icon(Icons.location_on),
            color: c,
            iconSize: 45,
            onPressed: () {
              print(latLng);
              this.setState(() {
                if (idMarkerSelected == id) {
                  idMarkerSelected = -1;
                } else {
                  idMarkerSelected = id;
                }
                this.refreshMarkers();
              });
            },
          ),
        ),
      );
      this.markers.add(marker);
    });
  }

  refreshMarkers() {
    List<Marker> passedMarkers = [];
    passedMarkers.addAll(markers);
    markers.clear();
    for (int i = 0; i<passedMarkers.length; i++) {
      Marker marker = passedMarkers[i];
      Color color = colorsMarkers[i];
      createMarker(marker.point, color);
    }
  }
}
