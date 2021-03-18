import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserData.dart';
import 'package:flutter_app/services/AccountService.dart';


class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: AccountService.loadCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        UserData userData = UserData.fromSnapshot(snapshot.data.docs[0]);
        return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text('Utilisateur'),
            ),
            body: Center(
              child: Column(
                children: [
                  Text(
                      userData.email
                  ),
                  Text(
                      userData.login
                  ),
                  Text(
                      userData.name
                  ),
                  Text(
                      userData.firstName
                  ),
                  Text(
                      userData.role.toString()
                  ),
                ],
              ),
            )
        );
      }
    );
  }
}
