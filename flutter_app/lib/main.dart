import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/connection/SignIn.dart';
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
              primarySwatch: Colors.deepPurple,
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
    switch(selectedIndex){
      case 1:
        // return MapPage.Map(artists: artists);
      case 2:
        // return isAuth ? ProfilePage(artists: artists) : LogInPage();
      case 0:
      default:
        return SignInPage();
    }
  }

  void dirtyBuild(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    // final isAuth = user != null;
    final isAuth = true;
    return Scaffold(
      body: loadPage(isAuth),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Missions"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: isAuth ? "User" :"Login"
          )
        ],
        currentIndex: selectedIndex,
        onTap: onNavTap,
        selectedItemColor: Colors.deepPurple,
      ),
    );
  }
}
