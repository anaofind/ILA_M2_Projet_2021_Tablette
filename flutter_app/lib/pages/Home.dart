import 'package:flutter/material.dart';
import 'package:flutter_app/services/AuthService.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String email, password;

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Acceuil'),
        ),
        body: Center(
          child: Text(
            "Bienvenu"
          ),
        )
    );
  }
}
