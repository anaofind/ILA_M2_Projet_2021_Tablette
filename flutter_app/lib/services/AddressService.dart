import 'dart:convert';

import 'package:flutter_app/models/AddressSuggestion.dart';
import 'package:http/http.dart';

class AddressService {
  final client = Client();

  AddressService();

  Future<List<Feature>> fetchSuggestions(String input) async {
    final request ='https://api-adresse.data.gouv.fr/search/?q=$input&limit=15&autocomplete=1';
    final response = await client.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
        return result['features']
            .map<Feature>((p) => Feature.fromJson(p))
            .toList();
    } else {
      print('Code retour '+ response.statusCode.toString());
      return [];
    }
  }

}