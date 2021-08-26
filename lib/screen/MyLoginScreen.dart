import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../widgets/login.dart';

class MyLoginScreen extends StatefulWidget {
  @override
  _MyLoginScreenState createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Background(),
            LoginUI(),
          ],
        ));
  }
}
