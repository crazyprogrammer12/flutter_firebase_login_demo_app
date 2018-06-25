import 'package:flutter/material.dart';
import 'auth.dart';

class HomePage extends StatelessWidget {

  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async{
    try{
      await auth.signOut();
      onSignedOut();
    }catch(e){
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Welcome Home'),
        actions: <Widget>[
          new FlatButton(
              onPressed: _signOut,
              child: new Text('Logout', style: new TextStyle(fontSize: 17.0,color: Colors.blue)),
          )
        ],
      ),
      body: new Container(
        child: new Center(
          child: new Text('Welcome', style: new TextStyle(fontSize: 32.0)),
        ),
      ),
    );
  }
}