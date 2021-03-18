import 'package:flutter/material.dart';
import 'package:flutter_app/services/AccountService.dart';
import 'package:flutter_app/validator/DataValidator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String email, login, password, name, familyName;

  AccountService accountService = AccountService();

  @override
  Widget build(BuildContext context) {

    final FocusNode nomNode = FocusNode();

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Inscription'),
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
                      if(input.isEmpty){
                        return 'email obligatoire';
                      }
                      if (! DataValidator.isEmail(input)) {
                        return 'email non valide';
                      }
                    },
                    onFieldSubmitted: (_) {
                      TextEditingController().clear();
                    },
                    onSaved: (input) => email = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email'
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (input) {
                      if(input.isEmpty){
                        return 'Il n\'y a pas de login';
                      }
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    onSaved: (input) => login = input,
                    decoration: InputDecoration(
                        icon: Icon(Icons.login),
                        labelText: 'Identifiant'
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
                    onSaved: (input) => password = input,
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
                    onSaved: (input) => name = input,
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
                    onSaved: (input) => familyName = input,
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
    final formState = formkey.currentState;
    String errorMessage;
    if (formState.validate()) {
      formState.save();
      errorMessage = await accountService.signUp(email, login, password, familyName, name);
      if (errorMessage != null) {
        Alert(
            context: context,
            title: "Inscription",
            desc: errorMessage
        ).show();
      } else {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    }
  }
}
