import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:phoenix_sales/screen/display_save_dm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import '../constant/constants.dart';
import '../network/network.dart';
import '../models/customer.dart';
import '../widgets/rounded_button.dart';
import '../screen/supply_entry_screen.dart';

class SupplyEntryScreen extends StatefulWidget {
  static const String id = 'SupplyEntryScreen';

  @override
  _SupplyEntryScreenState createState() => _SupplyEntryScreenState();
}

class _SupplyEntryScreenState extends State<SupplyEntryScreen> {
  final GlobalKey<ScaffoldState> ScafoldKey = new GlobalKey<ScaffoldState>();
  double height = 10;

  final txtController = TextEditingController();
  final _supplyDateController = TextEditingController();
  final _hatchDateController = TextEditingController();
  final _totalChicksController = TextEditingController();
  final _transitMortalityController = TextEditingController();
  final _chickRateController = TextEditingController();
  final _remarksController = TextEditingController();

  bool _isDropDownFilled = false;
  List<String> added = [];
  List hatcheryName = List();
  List<String> customerList = [];
  List<Customer> customerList1 = [];
  DateTime selectedDate = DateTime.now();
  DateTime selectedHatchDate = DateTime.now();
  String _dMNumber = '';
  String _valueChicksType = "Broiler";
  String _myValueHatchery = '';
  String _MobileNumber = '';

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: selectedDate.subtract(Duration(days: 5, hours: 2)),
      lastDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _supplyDateController.text = selectedDate.toString().split(' ')[0];
      });
    } else {
      _supplyDateController.text = selectedDate.toString().split(' ')[0];
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

  void fetchDMNumber() async {
    try {
      String url = '$Url/GetDMNumber?AreaCode=$AreaCode';
      NetworkHelper networkHelper = NetworkHelper(url);
      var data = await networkHelper.getData();
      // print(data);
      setState(() {
        if (data['DmNo'].length > 0) {
          _dMNumber = data['DmNo'][0]['DmNo'];
          print('dmno' + _dMNumber);
        } else {
          _dMNumber = '-';
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        _dMNumber = '-';
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

  void fillHatchery() async {
    String url = '$Url/GetHatchriesList?AreaCode=$AreaCode';
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    //print(data);

    for (var c in data['Hatchries']) {
      if (c['Hatcheryies'].toString() != 'null') {
        // print(c['customer'].toString());
        hatcheryName.add(c['Hatcheryies'].toString());
        //customerList1.add(Customer(customerName: c['customer'].toString()));
      }
      _myValueHatchery = c['Hatcheryies'];
      setState(() {
        _isDropDownFilled = true;
      });
    }
  }

  void fetchCustomerMobile(String code) async {
    try {
      String url = '$Url/GetMobileNumber?Code=$code';
      NetworkHelper networkHelper = NetworkHelper(url);
      var data = await networkHelper.getData();
      setState(() {
        if (data['MobileNo'].length > 0) {
          _MobileNumber = data['MobileNo'][0]['phone'];
          print('mobile' + _MobileNumber);
        } else {
          _MobileNumber = '-';
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        _MobileNumber = '-';
      });
    }
  }

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

  addSupplyData() async {
    SharedPreferences shpSypply = await SharedPreferences.getInstance();
    shpSypply.setString('customerName', added[0]);
    shpSypply.setString('customerCode', added[1]);
    shpSypply.setString('mobile', _MobileNumber);
    shpSypply.setString('dmno', _dMNumber);
    shpSypply.setString('dmdate', _supplyDateController.text);
    shpSypply.setString('totalchicks', _totalChicksController.text);
    shpSypply.setString('transit_mortality',_transitMortalityController.text);
    shpSypply.setString('hatch_date',_hatchDateController.text);
    shpSypply.setString('hatchery',_myValueHatchery);
    shpSypply.setString('chicks_type',_valueChicksType);
    shpSypply.setString('rate',_chickRateController.text);
    shpSypply.setString('remark',_remarksController.text);
    print(shpSypply.getString('customerName'));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    fetchDMNumber();
    filCustomer();
    fillHatchery();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScafoldKey,
      appBar: AppBar(
        title: Text('Supply Information'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/img2.png',
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
                      readOnly: true,
                      controller: _supplyDateController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select Chicks Supply Date'),
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
                'DM No.: ' + _dMNumber,
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
                      readOnly: true,
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
                  });
                  fetchCustomerMobile(added[1]);
                  print('Customer' + added[1]);
                },
                itemBuilder: (context, item) {
                  // ui for the autocomplete row
                  return row(item);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text('Mobile: ' + _MobileNumber),
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
                            child: Text("Broiler(M)"),
                            value: 'Broiler(M)',
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
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _totalChicksController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Total Chicks'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _transitMortalityController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Transit Mortality'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _chickRateController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Chick Rate'),
              ),
              SizedBox(
                height: 10,
              ),
              !_isDropDownFilled
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                  : Container(
                      height: 40.0,
                      width: double.infinity,
                      child: DropdownButton(
                        isExpanded: true,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        items: hatcheryName.map((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e.toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _myValueHatchery = newVal;
                          });
                        },
                        value: _myValueHatchery,
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _remarksController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: kTextFieldDecoration.copyWith(labelText: 'Remarks'),
              ),
              SizedBox(
                height: 20,
              ),
              RoundedButton(
                  title: 'Next...',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    if (txtController.text.length <= 0) {
                      showSnackBar('Please provide a valid customer');
                      return;
                    }
                    if (_supplyDateController.text.length <= 0) {
                      showSnackBar('Please provide a valid Supply date');
                      return;
                    }
                    if (_hatchDateController.text.length <= 0) {
                      showSnackBar('Please provide a valid Hatch date');
                      return;
                    }

                    if (_totalChicksController.text.length <= 0) {
                      showSnackBar('Please provide a valid number of chicks');
                      return;
                    }
                    else{
                      if(isNumeric(_totalChicksController.text)== true)
                      {        }
                      else
                      {
                        showSnackBar('Please provide a valid number of chicks');
                      }
                    }

                    if (_transitMortalityController.text.length <= 0) {
                      showSnackBar('Please provide a valid transit mortality');
                      return;
                    }
                    else{
                      if(isNumeric(_transitMortalityController.text)== true)
                      {        }
                      else
                      {
                        showSnackBar('Please provide a valid transit mortality');
                      }
                    }

                    if (_chickRateController.text.length <= 0) {
                      showSnackBar('Please provide a valid rate');
                      return;
                    }
                    else{
                      if(isNumeric(_chickRateController.text)== true)
                      {        }
                      else
                      {
                        showSnackBar('Please provide a valid rate');
                      }
                    }
                    addSupplyData();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SaveSupply()),
                    );
                  })
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
