import 'package:flutter/material.dart';
import 'package:flutter_app/model/UserData.dart';
import 'package:flutter_app/services/AccountService.dart';

import '../services/AccountService.dart';


class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  AccountService authService = AccountService();

  @override
  Widget build(BuildContext context) {
    print ("GET USER");
    UserData user =  AccountService.currentUserData;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Utilisateur'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                  user.email
              ),
              Text(
                  user.login
              ),
              Text(
                  user.name
              ),
              Text(
                  user.firstName
              ),
              Text(
                  user.role.toString()
              ),
            ],
          ),
        )
    );
  }
}
