import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/Home.dart';
import 'package:flutter_app/pages/connection/SignIn.dart';
import 'package:flutter_app/pages/intervention/ListInterventionPage.dart';
import 'package:flutter_app/services/AuthService.dart';
import 'package:provider/provider.dart';

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
        value: AuthService().user,
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
  int selectedIndex = 0;
  onNavTap(int index) => setState(()=> selectedIndex = index);

  AppHomePageState() {
  }

  Widget loadPage(bool isAuth){
    // print(isAuth);
    if (! isAuth) {
      return SignInPage();
    }
    switch(selectedIndex){
      case 0:
        return ListInterventionPage();
      case 1:
        return HomePage();
      case 2:
        return HomePage();
      case 3 :
        return HomePage();
      default:
        return SignInPage();
    }
  }

  void dirtyBuild(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final isAuth = user != null;
    return Scaffold(
      body: loadPage(isAuth),
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
              icon: Icon(Icons.pan_tool),
              label: 'Moyens'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.move_to_inbox),
              label: 'Drone'
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onNavTap,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueGrey,
      ),
    );
  }
}
