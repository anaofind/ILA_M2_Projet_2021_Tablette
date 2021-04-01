import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Role.dart';
import 'package:flutter_app/models/UserData.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/services/NavigatorPage.dart';


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
              appBar: AppBar(
                title: Text('Utilisateur'),
              ),
              body: Container(
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.blueGrey,
                          child: Column(
                            children: [
                              Flexible(
                                flex : 1,
                                child: Center(
                                  child: Container(
                                      child : Icon(
                                          Icons.account_box,
                                          size: 150,
                                          color: Colors.white
                                      )
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Center(
                                  child: Container(
                                      child: Column(
                                        children: [
                                          Flexible(
                                              flex:1,
                                              child: getOneInfoWidget('Login', userData.login)
                                          ),
                                          Flexible(
                                              flex:1,
                                              child: getOneInfoWidget('Email', userData.email)
                                          ),
                                          Flexible(
                                              flex:1,
                                              child: getOneInfoWidget('Login', userData.name)
                                          ),
                                          Flexible(
                                              flex:1,
                                              child: getOneInfoWidget('Prénom', userData.firstName)
                                          ),
                                          Flexible(
                                            flex:1,
                                            child: getOneInfoWidget('Rôle', userData.role.toString())
                                          ),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: Container(
                          child: Center(
                            child: Column (
                              children: [
                                Flexible(
                                    flex: 10,
                                    child: this.getUpdateRoleWidget(userData)
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Center(
                                            child: FlatButton (
                                                child: Text('Voir Interventions'),
                                              color: Colors.blueGrey,
                                              textColor: Colors.white,
                                              onPressed: () {
                                                  NavigatorPage.navigateTo(0);
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Center(
                                            child: FlatButton(
                                              child: Text('Se Déconnecter'),
                                              color: Colors.red,
                                              textColor: Colors.white,
                                              onPressed: () async{
                                                await AccountService().signOut();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              )
          );
        }
    );
  }


  Widget getOneInfoWidget(String title, String value) {
    return Container(
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
                child : Text(
                    title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white
                    )
                )
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
                child : Text(
                    value,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    )
                )
            ),
          )
        ],
      ),
    );
  }

  Widget getUpdateRoleWidget(UserData userData) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: Container(
                  child : Text(
                    'Changer de rôle',
                    style: TextStyle(
                      fontSize: 30,

                    ),
                  )
              )
          ),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: const Text('Opérateur'),
                  leading: Container(
                    child: Radio(
                      value: Role.Operator,
                      groupValue: userData.role,
                      onChanged: (Role value) {
                        userData.role = value;
                        AccountService.updateUser(userData);
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ListTile(
                    title: const Text('Intervenant'),
                    leading: Container(
                      child: Radio(
                        value: Role.Intervener,
                        groupValue: userData.role,
                        onChanged: (Role value) {
                          userData.role = value;
                          AccountService.updateUser(userData);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
