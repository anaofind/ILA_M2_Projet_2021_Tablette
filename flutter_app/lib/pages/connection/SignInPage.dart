import 'package:flutter/material.dart';
import 'package:flutter_app/models/Role.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/validator/DataValidator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'SignUpPage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String loginEmail, password;
  Role role = Role.Intervener;

  AccountService accountService = AccountService();

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Connexion'),
        ),
        body: Form(
            key: formkey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    // ignore: missing_return
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'identifiant ou email obligatoire';
                      }
                    },
                    onFieldSubmitted: (_) {
                      TextEditingController().clear();
                    },
                    onSaved: (input) => loginEmail = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_box_rounded), labelText: 'Identifiant / Email'),
                  ),
                  TextFormField(
                    // ignore: missing_return
                    focusNode: passwordNode,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'mot de passe obligatoire';
                      } else {return null;}
                    },
                    onFieldSubmitted: (_) async {
                      FocusScope.of(context).unfocus();
                      TextEditingController().clear();
                      signIn();
                    },
                    onSaved: (input) => password = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: const Text('Opérateur'),
                    leading: Radio(
                      value: Role.Operator,
                      groupValue: role,
                      onChanged: (Role value) {
                        setState(() {
                          role = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Intervenant'),
                    leading: Radio(
                      value: Role.Intervener,
                      groupValue: role,
                      onChanged: (Role value) {
                        setState(() {
                          role = value;
                        });
                      },
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          await signIn();
                        },
                        child: Text('Se connecter'),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                        },
                        child: Text(
                          'S\'incrire',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
        )
    );
  }

  Future<void> signIn() async {
    final formState = formkey.currentState;
    if (formState.validate()) {
      String errorMessage;
      formState.save();
      if (DataValidator.isEmail(loginEmail)) {
        errorMessage = await accountService.signIn(loginEmail, password, role);
      } else {
        errorMessage = await accountService.signInWithLogin(loginEmail, password, role);
      }
      if (errorMessage != null) {
        Alert(
            context: context,
            title: "Connexion",
            desc: errorMessage
        ).show();
      }
    }
  }
}
