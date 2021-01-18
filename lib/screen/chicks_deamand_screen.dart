import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:string_validator/string_validator.dart';
import '../constant/constants.dart';
import '../network/network.dart';
import '../models/customer.dart';
import '../widgets/rounded_button.dart';

class ChicksDemandScreen extends StatefulWidget {
  static const id = 'ChicksDemandScreen';
  @override
  _ChicksDemandScreenState createState() => _ChicksDemandScreenState();
}

class _ChicksDemandScreenState extends State<ChicksDemandScreen> {
  final _demadDateController = TextEditingController();
  final _hatchDateController = TextEditingController();
  final txtController = TextEditingController();
  final _demadQty1Controller = TextEditingController();
  final _demadQty2Controller = TextEditingController();
  final _remarksController = TextEditingController();

  bool _isDropDownFilled = false;
  List<String> added = [];
  List<String> customerList = [];
  List<Customer> customerList1 = [];
  DateTime selectedDate = DateTime.now();
  DateTime selectedHatchDate = DateTime.now();
  String _demandNumber = '';
  String _valueChicksType = "Broiler";
  String CCode = '';
  String CName = '';

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _demadDateController.text = selectedDate.toString().split(' ')[0];
      });
    } else {
      _demadDateController.text = selectedDate.toString().split(' ')[0];
    }
  }

  _selectHatchDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedHatchDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedHatchDate) {
      setState(() {
        selectedHatchDate = picked;
        _hatchDateController.text = selectedHatchDate.toString().split(' ')[0];
      });
    } else {
      _hatchDateController.text = selectedHatchDate.toString().split(' ')[0];
    }
  }

  void fetchDemandNumber() async {
    try {
      String url = '$Url/GetDemandNo?AreaCode=$AreaCode';
      NetworkHelper networkHelper = NetworkHelper(url);
      var data = await networkHelper.getData();
      // print(data);
      setState(() {
        if (data['DemandNo'].length > 0) {
          _demandNumber = data['DemandNo'][0]['DemandNo'];
          print('dmno' + _demandNumber);
        } else {
          _demandNumber = '-';
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        _demandNumber = '-';
      });
    }
  }

  void filCustomer() async {
    String url = '$Url/Customer?AreaCode=$AreaCode';
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();

    for (var c in data['Customer']) {
      if (c['customer'].toString() != 'null') {
        // print(c['customer'].toString());
        customerList.add(c['customer'].toString());
        customerList1.add(Customer(customerName: c['customer'].toString()));
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    fetchDemandNumber();
    filCustomer();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chicks Demand'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/img4.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello: $UserName   Area:$AreaName',
                style: TextStyle(fontSize: 19),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 3,
                thickness: 1.5,
                color: Colors.blue,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextField(
                      controller: _demadDateController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select Entry Date'),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Demand: ' + _demandNumber,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextField(
                      controller: _hatchDateController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select Hatch Date'),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectHatchDate(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
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
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Select Customer.',
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
                    CCode = added[1];
                    CName = added[0];
                  });
                },
                itemBuilder: (context, item) {
                  // ui for the autocomplete row
                  return row(item);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 20,
                    child: DropdownButton(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        dropdownColor: Colors.white,
                        value: _valueChicksType,
                        items: [
                          DropdownMenuItem(
                            child: Text("Broiler"),
                            value: 'Broiler',
                          ),
                          DropdownMenuItem(
                            child: Text("Broiler(M+)"),
                            value: 'Broiler(M+)',
                          ),
                          DropdownMenuItem(
                            child: Text("Layer"),
                            value: 'Layer',
                          ),
                          DropdownMenuItem(
                            child: Text("Cockrel"),
                            value: 'Cockrel',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _valueChicksType = value;
                          });
                        }),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _demadQty1Controller,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Select Demanded Qty-1'),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _demadQty2Controller,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Select Demanded Qty-2'),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _remarksController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(labelText: 'Remarks'),
              ),
              SizedBox(
                height: 25,
              ),
              RoundedButton(
                  title: 'Save',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    var connectivityResult =
                    await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi) {
                      Toast.show("No internet connectivity...", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      return;
                    }
                    if (txtController.text.length <= 0) {

                      Toast.show("Please provide a valid customer", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      return;
                    }
                    if (_demadDateController.text.length <= 0) {
                      Toast.show("Please provide a valid demand date", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      return;
                    }
                    if (_hatchDateController.text.length <= 0) {
                      Toast.show("Please provide a valid hatch date", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      return;
                    }
                    if (_demadQty1Controller.text.length <= 0) {
                      Toast.show("Please provide a valid Quantity", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      return;
                    }
                    else{
                      if(isNumeric(_demadQty1Controller.text)== true)
                      {        }
                      else
                      {
                        Toast.show("Please provide a valid Quantity", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      }
                    }


                    try {
                      String url =
                          '$Url/InsertDemandData?AreaCode=$AreaCode&Area=$AreaName&DMNo=${_demandNumber}&';
                      url +=
                      "DMDate=${_demadDateController.text}&HatchDate=${_hatchDateController.text}&uname=$UserName&Code=$CCode&CName=$CName&";
                      url +=
                      "Chick_type=$_valueChicksType&";
                      url +=
                      "CihckRate=0&Remarks=${_remarksController.text}&TotalChicks=${_demadQty1Controller.text}&Mortality=${_demadQty2Controller.text}";
                      print(url);
                      NetworkHelper networkHelper = NetworkHelper(url);
                      var data = await networkHelper.getData();
                      print(data);
                    } catch (e) {
                      print(e);
                    }
                    // showToast("Show Long Toast", duration: Toast.LENGTH_LONG);
                    Toast.show("Demand Information Saved...", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

                    Navigator.of(context).pop();
                  }),
              SizedBox(
                height: 5,
              ),
              RoundedButton(
                  title: 'Back',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    Navigator.of(context).pop();

                  }),
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
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
    ],
  );
}
