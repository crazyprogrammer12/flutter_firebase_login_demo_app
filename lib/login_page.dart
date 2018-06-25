import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {

  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LoginPageState();
  }
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
         // FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('$userId Signed In Successfully');
        } else {
          String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
          //FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('$userId Registered Successfully');
        }
        widget.onSignedIn();
      }
      catch (e) {
        print('Error; $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Login Demo"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        margin: new EdgeInsets.all(15.0),
        child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            )
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Email',
          hintText: 'Enter Your Email',
          border: InputBorder.none,
        ),
        validator: (value) => value.isEmpty ? 'Email Cannot be Empty!!' : null,
        onSaved: (value) => _email = value,
      ),

      new TextFormField(
        decoration: new InputDecoration(
          labelText: 'Password',
          hintText: 'Enter Your Password',
          border: InputBorder.none,
        ),
        validator: (value) => value.isEmpty ? 'Password Cannot be Empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
            child: new Text('Login', style: new TextStyle(fontSize: 20.0),),
            onPressed: validateAndSubmit
        ),
        new FlatButton(
          onPressed: moveToRegister,
          child: new Text(
              'Create an account', style: new TextStyle(fontSize: 20.0)),
        ),
      ];
    } else {
      return [
        new RaisedButton(
            child: new Text(
              'Create an account', style: new TextStyle(fontSize: 20.0),),
            onPressed: validateAndSubmit
        ),
        new FlatButton(
          onPressed: moveToLogin,
          child: new Text('Have an account?Login Here',
              style: new TextStyle(fontSize: 20.0)),
        ),
      ];
    }
  }
}

