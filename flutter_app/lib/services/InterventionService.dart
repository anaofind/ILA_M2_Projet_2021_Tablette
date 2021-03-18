import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Moyen.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';

class InterventionService {
  CollectionReference interventions = FirebaseFirestore.instance.collection('interventions');

  Future<void> addIntervention(String nom, String adresse, String codeSinistre, List<MoyenIntervention> moyens) {
    DateTime date = DateTime.now();
    /*List<MoyenIntervention> moyensIntervention = List<MoyenIntervention>();
    moyens.forEach((moyen) {
      moyensIntervention.add(new MoyenIntervention(moyen, Etat.enCours.toString(), date, null, null));
    });*/
    moyens.forEach((moyen) {
      moyen.demandeA = date;
    });
    Intervention intervention = Intervention(null, nom, adresse, codeSinistre, date, moyens);
    return  interventions.add(intervention.toMap());
  }

  Stream<QuerySnapshot> loadAllInterventions(){
    return interventions.snapshots();
  }

  List<MoyenIntervention> loadAllMoyensIntervention(String idIntervention){
    List<MoyenIntervention> moyensInterventionList = List();
    interventions.doc(idIntervention).get().then(
            (document) {
          moyensInterventionList = List();
          List.from(document.data()['moyens']).forEach((element) {
            MoyenIntervention data = MoyenIntervention.fromMap(element);
            moyensInterventionList.add(data);
          });
        });
    return moyensInterventionList;
  }

  Future<void> addMoyenToIntervention(String idIntervention, MoyenIntervention moyen) {
    Intervention i;
    List<MoyenIntervention> moyens;
    interventions.doc(idIntervention).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        i = Intervention.fromSnapshot(doc);
        moyens = i.moyens;
        moyens.add(moyen);
        return interventions.doc(idIntervention)
            .update({'moyens': i.ConvertMoyensToMap(moyens)});
      }
    });
  }

  Future<void> addSymbolToIntervention(String idIntervention, SymbolIntervention symbol) {
    Intervention i;
    List<SymbolIntervention> symbols;
    interventions.doc(idIntervention).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        i = Intervention.fromSnapshot(doc);
        symbols = i.symbols;
        symbols.add(symbol);
        return interventions.doc(idIntervention)
            .update({'symbols': i.ConvertSymbolsToMap(symbols)});
      }
    });
  }

  Future<void> addMoyenOrSymbolToIntervention(String idIntervention, dynamic object) {

    if (object is MoyenIntervention){addMoyenToIntervention(idIntervention, object);};
    if (object is SymbolIntervention){addSymbolToIntervention(idIntervention, object);};

  }

  Future<void> updatePositionSymbolIntervention(String idIntervention, idSymbol, Position newPosition) {
    Intervention i;
    List<SymbolIntervention> symbols;
    interventions.doc(idIntervention).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        i = Intervention.fromSnapshot(doc);
        symbols = i.symbols;
        symbols.forEach((symbol) {
          if(symbol.id == idSymbol){
            symbol.position= newPosition;
          }
        });
        return interventions.doc(idIntervention)
            .update({'symbols': i.ConvertSymbolsToMap(symbols)});
      }
    });
  }

  Future<void> updateEtatSymbolIntervention(String idIntervention, idSymbol, Etat newEtat) {
    Intervention i;
    List<SymbolIntervention> symbols;
    interventions.doc(idIntervention).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        i = Intervention.fromSnapshot(doc);
        symbols = i.symbols;
        symbols.forEach((symbol) {
          if(symbol.id == idSymbol){
            symbol.etat= newEtat.toString();
          }
        });
        return interventions.doc(idIntervention)
            .update({'symbols': i.ConvertSymbolsToMap(symbols)});
      }
    });
  }

  Future<void> updateCouleurSymbolIntervention(String idIntervention, idSymbol, Color newCouleur) {
    Intervention i;
    List<SymbolIntervention> symbols;
    interventions.doc(idIntervention).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        i = Intervention.fromSnapshot(doc);
        symbols = i.symbols;
        symbols.forEach((symbol) {
          if(symbol.id == idSymbol){
            symbol.couleur= newCouleur;
          }
        });
        return interventions.doc(idIntervention)
            .update({'symbols': i.ConvertSymbolsToMap(symbols)});
      }
    });
  }
  /*
  Future<List<String>> loadAllSinistres() async{
    QuerySnapshot snapshots = await sinistres.get();
    return snapshots.docs.map((doc) => doc.data()['codeSinistre'])
    .toList();
  }
  */

  void updateIntervention(Intervention intervention) {
    DocumentReference reference = interventions.doc(intervention.id);
    reference.set(intervention.toMap());
  }

  Stream<DocumentSnapshot> getInterventionById(String id) {
    return interventions.doc(id).get().asStream();
  }

  Future<DocumentSnapshot> getInterventionByName(String nom) {
    return  interventions.where(
        "nom", isEqualTo: nom)
        .get()
        .then((querySnapshot) {
      if(querySnapshot.size!=0) {
        return querySnapshot.docs[0];
      }
      else{
        return null;
      }
    });
  }
}