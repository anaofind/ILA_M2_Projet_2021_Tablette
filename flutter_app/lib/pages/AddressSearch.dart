import 'package:flutter/material.dart';
import 'package:flutter_app/models/AddressSuggestion.dart';
import 'package:flutter_app/services/AddressService.dart';

class AddressSearch extends SearchDelegate<Feature> {
  AddressService addressService;
  AddressSearch() {
    addressService = AddressService();
  }

  @override
  String get searchFieldLabel => "Commencez à saisir une adresse";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Supprimer',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Retour',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: query == ""
          ? null
          : addressService.fetchSuggestions(query),
      builder: (context, snapshot) => query == ''
          ? Container()
          : snapshot.hasData
          ? ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title:
                Text((snapshot.data[index] as Feature).properties.label),
                onTap: () {
                  close(context, snapshot.data[index]);
                },
              ),
        itemCount: snapshot.data.length,
      )
          : Container(child: Row(
            children: [
              Text('Chargement...'),
              CircularProgressIndicator()
            ],
          )),
    );
  }
}