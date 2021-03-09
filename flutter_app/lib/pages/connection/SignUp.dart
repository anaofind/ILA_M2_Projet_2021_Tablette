import 'package:flutter/material.dart';
import 'package:flutter_app/services/AuthService.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _email, _password, _name, _familyName;

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {

    final FocusNode nomNode = FocusNode();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Inscription'),
        ),
        body: Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    // ignore: missing_return
                    validator: (input) {
                      if(input.isEmpty){
                        return 'Il n\'y a pas d\'email';
                      }
                    },
                    onFieldSubmitted: (_) {
                      TextEditingController().clear();
                    },
                    onSaved: (input) => _email = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email'
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    // ignore: missing_return
                    validator: (input) {
                      if(input.isEmpty){
                        return 'Il n\'y a pas de mot de passe';
                      }
                      if (input.length < 6) {
                        return 'Le mot de passe doit avoir au minimum 6 caractères';
                      }
                    },
                    onFieldSubmitted: (_) {
                      TextEditingController().clear();
                    },
                    onSaved: (input) => _password = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Mot de passe'
                    ),
                    obscureText: true,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    // ignore: missing_return
                    validator: (input) {
                      if(input.isEmpty){
                        return 'Il n\'y a pas de prénom';
                      }
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onSaved: (input) => _name = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: 'Prénom'
                    ),
                  ),
                  TextFormField(

                    focusNode: nomNode,
                    // ignore: missing_return
                    validator: (input) {
                      if(input.isEmpty){
                        return 'Il n\'y a pas de nom de famille';
                      }
                    },
                    onFieldSubmitted: (_) async {
                      FocusScope.of(context).unfocus();
                      TextEditingController().clear();
                      signUp();
                    },
                    onSaved: (input) => _familyName = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: 'Nom de famille'
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: signUp,
                          child: Text('S\'inscrire'),
                        )
                      ]
                  ),
                ],
              ),
            )
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> signUp() async {
    final formState = _formkey.currentState;
    if (formState.validate()) {
      formState.save();
      authService.createAccount(_email, _password, _familyName, _name);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
}
