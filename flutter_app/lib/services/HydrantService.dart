import 'dart:convert';

import 'package:flutter_app/models/HydrantData.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';

class HydrantService {

  static String queryBase = 'https://data.opendatasoft.com/api/records/1.0/search/?dataset=osm-fr-fire-hydrant%40babel&facet=fire_hydrant_type&facet=fire_hydrant_position&facet=fire_hydrant_pressure';

  static List<HydrantData> hydrants = [];
  static bool finished = false;

  static Future<void> createHydrantsData(LatLng latLng) async {
    finished = false;
    hydrants.clear();
    String query = queryBase;
    query = addGeofilter(query, latLng, 1000);
    query = addRowsFilter(query, 0, 100);
    var url = Uri.parse(query);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      String jsonString = response.body;
      Map<String, dynamic> json = JsonDecoder().convert(jsonString);
      if (json.containsKey('records')) {
        List<dynamic> jsonHydrants = json['records'];
        jsonHydrants.forEach((element) {
          Map<String, dynamic> jsonHydrant = element;
          if (jsonHydrant.containsKey('fields')) {
            Map<String, dynamic> jsonHydrantData = jsonHydrant['fields'];
            HydrantData hydrant = HydrantData.fromJson(jsonHydrantData);
            if (hydrant != null) {
              hydrants.add(hydrant);
            }
          }
        });
      };
    }
    finished = true;
    print ('FINISHED');
  }

  static String addGeofilter(String query, LatLng latLng, int distance) {
    return query + '&geofilter.distance=${latLng.latitude}%2C${latLng.longitude}%2C${distance}';
  }
  static String addRowsFilter(String query, int currentRow, int nbRow) {
    return query + '&rows=${nbRow}&start${currentRow}';
  }
}