import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../network/network.dart';
import '../models/customer.dart';
import '../constant/constants.dart';

class MenuGrid extends StatefulWidget {
  @override
  _MenuGridState createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  List<String> customerList = [];
  final txtController = TextEditingController();
  List<String> added = [];
  String currentText, t = "";

  List<Customer> customerList1 = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedCity;

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  String url =
                      'http://117.240.18.180:91/mynew.asmx/Customer?AreaCode=BH';
                  NetworkHelper networkHelper = NetworkHelper(url);
                  var data = await networkHelper.getData();
                  // print(data['Customer'][1]['customer']);
                  //print(data);

                  for (var c in data['Customer']) {
                    if (c['customer'].toString() != 'null') {
                      print(c['customer'].toString());
                      setState(() {
                        customerList.add(c['customer'].toString());
                        customerList1.add(
                            Customer(customerName: c['customer'].toString()));
                      });

                    }
                  }
                  print(customerList);
                },
                child: Text('Show'),
              ),
//              SimpleAutoCompleteTextField(
//                key: key,
//                decoration: InputDecoration(
//                  hintText: 'Enter a value',
//                  contentPadding:
//                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                  ),
//                  enabledBorder: OutlineInputBorder(
//                    borderSide:
//                        BorderSide(color: Colors.blueAccent, width: 1.0),
//                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                  ),
//                  focusedBorder: OutlineInputBorder(
//                    borderSide:
//                        BorderSide(color: Colors.blueAccent, width: 2.0),
//                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
//                  ),
//                ),
//
//
//                suggestions: customerList,
//                textChanged: (text) => currentText = text,
//                clearOnSubmit: true,
//                textSubmitted: (text) => setState(() {
//                  if (text != "") {
//                    added.add(text);
//                  }
//                }),
//              ),
              Text(txtController.text),
              AutoCompleteTextField<Customer>(
                controller: txtController,
                clearOnSubmit: false,
                suggestions: customerList1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.w700,
                ),
                // decoration: InputDecoration(
                //   contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                //   hintText: "",
                //   hintStyle: TextStyle(color: Colors.black),
                //   // prefixIcon: Icon(Icons.check ),
                //   errorText: null,
                // ),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter your password.',
                ),

                itemFilter: (item, query) {
                  return item.customerName
                      .toLowerCase()
                      .startsWith(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.customerName.compareTo(b.customerName);
                },
                itemSubmitted: (item) {
                  setState(() {
                    txtController.text = item.customerName;
                    added = txtController.text.split('#');
                  });
                  print(added[0]);
                },
                itemBuilder: (context, item) {
                  // ui for the autocomplete row
                  return row(item);
                },
              ),
              MaterialButton(
                child: Text('Press me'),
                onPressed: () {
                  print(txtController.text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget row(Customer maker) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10),
          child: Text(
            maker.customerName,
            style: TextStyle(color: Colors.blue, fontSize: 25),
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
    ],
  );
}
