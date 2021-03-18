import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserData.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/SitacPage.dart';
import 'package:flutter_app/pages/UserPage.dart';
import 'package:flutter_app/pages/connection/SignInPage.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/pages/intervention/ListInterventionPage.dart';
import 'package:flutter_app/services/NavigatorPage.dart';
import 'package:flutter_app/services/SelectorIntervention.dart';
import 'package:provider/provider.dart';

import 'models/Intervention.dart';
import 'services/AccountService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AccountService.user,
        child: MaterialApp(
            title: 'ILA ISTIC M2 2021 PROJET',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: AppHomePage()
        )
    );
  }
}

class AppHomePage extends StatefulWidget {
  AppHomePage({Key key}) : super(key: key);

  @override
  AppHomePageState createState() => AppHomePageState();
}

class AppHomePageState extends State<AppHomePage> {
  onNavTap(int index) => setState(()=> NavigatorPage.indexSelectedPage = index);

  AppHomePageState() {
    NavigatorPage.refreshFunction = this.refresh;
    SelectorIntervention.selectInterventionFunction = this.selectIntervention;
  }

  Intervention interventionSelected;

  void refresh() {
    this.setState(() {});
  }

  void selectIntervention(Intervention intervention) {
    this.interventionSelected = intervention;
  }

  Widget loadPage(bool isAuth) {
    // print(isAuth);
    if (! isAuth) {
      return SignInPage();
    }
    switch(NavigatorPage.indexSelectedPage){
      case 0:
        return ListInterventionPage();
      case 1:
        if (this.interventionSelected != null) {
          return SitacPage(this.interventionSelected);
        }
        return HomePage();
      case 2:
        return HomePage();
      case 3 :
        return HomePage();
      case 4 :
        return UserPage();
      default:
        return SignInPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final isAuth = user != null;
    Widget body = loadPage(isAuth);
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'Interventions'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'SITAC'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Moyens'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.satellite),
              label: 'Drone'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Utilisateur'
          ),
        ],
        currentIndex: NavigatorPage.indexSelectedPage,
        onTap: onNavTap,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueGrey,
      ),
      floatingActionButton : FloatingActionButton (
        onPressed: () {
          AccountService().signOut();
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
