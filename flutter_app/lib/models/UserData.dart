import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Role.dart';

class UserData {

  final String id;
  final String email;
  final String login;
  final String name;
  final String firstName;
  Role role;

  UserData(this.id, this.email, this.login, this.name, this.firstName, this.role);

  Map<String, dynamic> toMap() {
    return {
      'userID': id,
      'email': email,
      'login': login,
      'name': name,
      'firstName': firstName,
      'role': role.toString(),
    };
  }

  UserData.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.data()['userID'],
        email = snapshot.data()['email'],
        login = snapshot.data()['login'],
        name = snapshot.data()['name'],
        firstName = snapshot.data()['firstName'],
        role = RoleConverter.get(snapshot.data()['role']);


}