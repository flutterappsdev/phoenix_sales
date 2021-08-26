import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
import '../constant/constants.dart';
import '../widgets/rounded_button.dart';
import '../network/network.dart';
import '../screen/menu_sales_screen.dart';
import '../widgets/progress_dialog.dart';
import 'round_button.dart';


class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {

  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  void showSnackBar(String tittle) {
    final snackBar = SnackBar(
      content: Text(
        tittle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(

        child: Padding(
          padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height /2.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 60,right: 60),
                child: TextFormField(
                  controller: _userNameTextController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    //email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      suffixIcon: Icon(Icons.account_circle_rounded),
                      labelText: 'Enter your username.'),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 60,right: 60),
                child: TextFormField(
                  controller: _passwordTextController,
                  obscureText: true,
                  onChanged: (value) {
                    //password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      suffixIcon: Icon(Icons.https_rounded),
                      labelText: 'Enter your password.'),
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25),
              ),
              RoundButton("Login", signUpGradients, false,()
              async {
                print("from login");

                {
                  final connResult =
                      await Connectivity().checkConnectivity();
                  if (connResult != ConnectivityResult.mobile &&
                      connResult != ConnectivityResult.wifi) {
                    showSnackBar('Please check you internet connection');
                    return;
                  }

                  if (_userNameTextController.text == "") {
                    showSnackBar('Please enter a valid user name');
                    return;
                  }

                  if (_passwordTextController.text == "") {
                    showSnackBar('Please enter a valid password');
                    return;
                  }

                   showDialog(
                       context: context,
                       barrierDismissible: false,
                       builder: (BuildContext blidcontext) =>
                           ProgressDialog('Logging in you...'));
                  String _url =
                      'http://117.240.18.180:91/mynew.asmx/Login?User=${_userNameTextController.text}&Password=${_passwordTextController.text}';
                 print(_url);
                  NetworkHelper networkHelper = NetworkHelper(_url);
                  var _userData = await networkHelper.getData();
                  UserName = _userData['Login'][0]['UserName'];
                  UserType = _userData['Login'][0]['UserType'];
                  AreaCode = _userData['Login'][0]['AreaCode'];
                  AreaName = _userData['Login'][0]['AreaName'];

                  if (_userData['Login'].length == 0) {
                    print(_userData['Login'].lenght);
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                          title: Text('Alert'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Invalid username or password'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ]),
                    );
                  } else {
                    if (UserType == 'Sales') {
                      Navigator.pushNamedAndRemoveUntil(
                          context, SalesMenuGrid.id, (route) => false);
                    }
                  }
                }


              }),
              RoundButton("Create an Account", signInGradients, false,(){
                print("from Create account");
              }),
            ],
          ),
        ),
      );
     }
}


