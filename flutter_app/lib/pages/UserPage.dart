import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserData.dart';
import 'package:flutter_app/services/AccountService.dart';


class UserPage extends StatefulWidget {
  final UserData userData;
  UserPage({Key key, this.userData}) : super(key: key);

  @override
  UserPageState createState() => UserPageState(this.userData);
}

class UserPageState extends State<UserPage> {

  final UserData userData;
  UserPageState(this.userData);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: AccountService.loadCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data.exists) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        print (snapshot.data.id);
        UserData userData = UserData.fromSnapshot(snapshot.data);
        return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text('Utilisateur'),
            ),
            body: Center(
              child: Column(
                children: [
                  Text(
                      this.userData.email
                  ),
                  Text(
                      this.userData.login
                  ),
                  Text(
                      this.userData.name
                  ),
                  Text(
                      this.userData.firstName
                  ),
                  Text(
                      this.userData.role.toString()
                  ),
                ],
              ),
            )
        );
      }
    );
  }
}
