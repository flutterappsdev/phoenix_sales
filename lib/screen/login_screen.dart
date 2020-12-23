import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connectivity/connectivity.dart';
import '../constant/constants.dart';
import '../widgets/rounded_button.dart';
import '../network/network.dart';
import '../screen/menu_sales_screen.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> ScafoldKey = new GlobalKey<ScaffoldState>();

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
    ScafoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScafoldKey,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(child: Image.asset('assets/images/logo.JPG')),
              Container(child: Image.asset('assets/images/chimg.jpg')),
              TextFormField(
                controller: _userNameTextController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    icon: Icon(FontAwesomeIcons.userAlt),
                    labelText: 'Enter your username.'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordTextController,
                obscureText: true,
                onChanged: (value) {
                  //password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    icon: Icon(FontAwesomeIcons.lockOpen),
                    labelText: 'Enter your password.'),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                child: RoundedButton(
                    title: 'Log In',
                    colour: Colors.lightBlueAccent,
                    onPressed: () async {

                      final connResult =
                      await Connectivity().checkConnectivity();
                      if (connResult != ConnectivityResult.mobile &&
                          connResult != ConnectivityResult.wifi) {
                        showSnackBar('Please check you internet connection');
                        return;
                      }

                      if (_userNameTextController.text== "") {
                        showSnackBar('Please enter a valid user name');
                        return;
                      }

                      if (_passwordTextController.text =="") {
                        showSnackBar('Please enter a valid password');
                        return;
                      }

                      showDialog(context: context,
                          barrierDismissible: false,
                          builder: (BuildContext blidcontext)=>ProgressDialog('Logging in you...')
                      );
                      String _url =
                          'http://117.240.18.180:91/mynew.asmx/Login?User=${_userNameTextController.text}&Password=${_passwordTextController.text}';
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
                       if(UserType == 'Sales') {
                         Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(
                             builder: (context) => SalesMenuGrid(),
                           ),
                         );
                       }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
