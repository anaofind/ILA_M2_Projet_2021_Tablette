import 'package:flutter/cupertino.dart';

import 'Role.dart';

class UserData {

  final String email;
  final String login;
  final String name;
  final String firstName;
  Role role;

  UserData({
    @required this.email,
    @required this.login,
    @required this.name,
    @required this.firstName,
    @required this.role
  });

}