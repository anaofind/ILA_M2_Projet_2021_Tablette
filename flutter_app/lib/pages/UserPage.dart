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
              body: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Column(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                                child : Icon(
                                    Icons.account_box,
                                    size: 120,
                                    color: Colors.blueGrey
                                )
                            ),
                          ),
                          Flexible(
                              flex: 3,
                              child: Container()
                          )
                        ],
                      ),
                      color: Colors.green
                    ),
                  ),
                  Flexible(
                      flex: 3,
                      child: Container(
                        color: Colors.red,
                      )
                  )
                ],
              )
          );
        }
    );
  }


  Widget getOneInfoWidget(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(
                right: 15,
                left: 15
            ),
            child : Text(
                title,
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic
                )
            )
        ),
        Container(
            child : Text(
                value,
                style: TextStyle(
                  fontSize: 25,
                )
            )
        )
      ],
    );
  }
}
