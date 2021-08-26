import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'login_screen.dart';
import 'MyLoginScreen.dart';

class SplashScreenForApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new MyLoginScreen(),
      title: new Text(
        'Welcome To Phoenix',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
      ),
      image:  Image.asset('assets/images/logo.JPG'),
      backgroundColor: Colors.white,
      loaderColor: Colors.lightBlueAccent,
      photoSize: 100.0,
    );
  }
}
