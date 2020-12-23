import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './screen/login_screen.dart';
import 'screen/tr_entry_screen.dart';
import './screen/menu_screen.dart';
import './screen/List_tr_data.dart';
import './screen/supply_entry_screen.dart';
import './screen/List_dm_data.dart';
import './screen/imgae_upload_screen.dart';
import './screen/trip_screen.dart';

 Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phoenix Sales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NamBold',
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.black
          )
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {
        TrEntryScreen.id : (context)=>TrEntryScreen(),
        ListTrData.id :(context)=>ListTrData(),
        SupplyEntryScreen.id : (context)=>SupplyEntryScreen(),
        ListDmData.id : (context)=>ListDmData(),
        ImageUploadScreen.id : (context)=>ImageUploadScreen(),
        TripScreen.id : (context)=>TripScreen(),
      },
    );
  }
}
