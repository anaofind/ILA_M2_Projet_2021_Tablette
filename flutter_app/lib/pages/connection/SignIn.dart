import 'package:flutter/material.dart';
import 'package:flutter_app/services/AuthService.dart';

import 'SignUp.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String email, password;

  AuthService authService = AuthService();

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
                        return 'Il n\'y a pas d\'email';
                      }
                    },
                    onFieldSubmitted: (_) {
                      TextEditingController().clear();
                    },
                    onSaved: (input) => email = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Email'),
                  ),
                  TextFormField(
                    // ignore: missing_return
                    focusNode: passwordNode,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Il n\'y a pas de mot de passe';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: signIn,
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
      formState.save();
      await authService.signInAccount(email, password);
      Navigator.of(context).pop();
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      /*Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(artists: this.artists)));*/
    }
  }
}
