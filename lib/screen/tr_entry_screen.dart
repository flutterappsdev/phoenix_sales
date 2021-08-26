import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/constants.dart';
import '../models/customer.dart';
import '../network/network.dart';
import '../widgets/rounded_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:string_validator/string_validator.dart';
import '../screen/display_save_tr.dart';

class TrEntryScreen extends StatefulWidget {
  static const id = 'TrEntry';
  @override
  _TrEntryScreenState createState() => _TrEntryScreenState();
}

class _TrEntryScreenState extends State<TrEntryScreen> {
  // GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  final GlobalKey<ScaffoldState> ScafoldKey = new GlobalKey<ScaffoldState>();
  List<String> customerList = [];
  final txtController = TextEditingController();
  final _trDateController = TextEditingController();
  final _trAmountController = TextEditingController();
  final _chqNumberController = TextEditingController();
  final _bandepositDateController = TextEditingController();
  final _hatchDateController = TextEditingController();
  final _chickrateController = TextEditingController();
  final _reamrkController = TextEditingController();

  List<String> added = [];
  List bankName = List();
  String currentText, t = "";
  List<Customer> customerList1 = [];
  String _MobileNumber = '';
  String _TRNumber = '';
  String _TrNumber = 'TR/0000000/';
  DateTime selectedDate = DateTime.now();
  DateTime selectedHatchDate = DateTime.now();
  DateTime bankdepositselectedDate = DateTime.now();
  String _value = 'CHEQUE';
  String _myValuebank = "";
  String _myValuePaymentType = "Current-Payment";
  String _valueChicksType = "Broiler";
  bool _isDropDownFilled = false;

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

  void fillBank() async {
    String url = '$Url/Bankname?AreaCode=$AreaCode';
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();

    for (var c in data['Bank']) {
      if (c['bank'].toString() != 'null') {
        // print(c['customer'].toString());
        bankName.add(c['bank'].toString());
        //customerList1.add(Customer(customerName: c['customer'].toString()));
      }
      _myValuebank = c['bank'];
      setState(() {
        _isDropDownFilled = true;
      });
    }

    print(bankName);
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: selectedDate,
      lastDate: selectedDate,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _trDateController.text = selectedDate.toString().split(' ')[0];
      });
    } else {
      _trDateController.text = selectedDate.toString().split(' ')[0];
    }
  }

  _bankdepositselectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: bankdepositselectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != bankdepositselectedDate) {
      setState(() {
        bankdepositselectedDate = picked;
        _bandepositDateController.text =
            bankdepositselectedDate.toString().split(' ')[0];
      });
    } else {
      _bandepositDateController.text =
          bankdepositselectedDate.toString().split(' ')[0];
    }
  }

  //_selectHatchDate
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

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('customerName', added[0]);
    prefs.setString('customerCode', added[1]);
    prefs.setString('mobile', _MobileNumber);
    prefs.setString('trno', _TRNumber);
    prefs.setString('trdate', _trDateController.text);
    prefs.setString('tramount', _trAmountController.text);
    prefs.setString('paymode',_value);
    prefs.setString('ddno',_chqNumberController.text);
    prefs.setString('bank_det',_myValuebank);
    prefs.setString('pay_type',_myValuePaymentType);
    prefs.setString('hatch_date',_hatchDateController.text);
    prefs.setString('chicks_type',_valueChicksType);
    prefs.setString('rate',_chickrateController.text);
    prefs.setString('remark',_reamrkController.text);
    prefs.setString('bankdate',_bandepositDateController.text);
    print(prefs.getString('paymode'));
  }

  void fetchTRNumber() async {
    try {
      String url = '$Url/GetTRNumber?AreaCode=$AreaCode';
      NetworkHelper networkHelper = NetworkHelper(url);
      var data = await networkHelper.getData();
    // print(data);
      setState(() {
        if (data['TrNo'].length > 0) {
          _TRNumber = data['TrNo'][0]['trno'];
          print('trno' + _TRNumber);
        } else {
          _TRNumber = '-';
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        _TRNumber = '-';
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    filCustomer();
    fillBank();
    fetchTRNumber();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScafoldKey,
      appBar: AppBar(
        title: Text('TR Creation'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/img6.png',
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
                height: 25,
              ),
              //Customer Selection
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
                height: 8,
              ),
              Text('Mobile: ' + _MobileNumber),
              SizedBox(
                height: 10,
              ),
              Text(
                'TR: ' + _TRNumber,
                style: TextStyle(fontSize: 18),
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
                      controller: _trDateController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select TR Date'),
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
              TextField(
                keyboardType: TextInputType.number,
                controller: _trAmountController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'Enter TR Amount'),
              ),
              SizedBox(
                height: 10,
              ),
              //bnak Payment mode
              Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: DropdownButton(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        dropdownColor: Colors.white,
                        value: _value,
                        items: [
                          DropdownMenuItem(
                            child: Text("CHEQUE"),
                            value: 'CHEQUE',
                          ),
                          DropdownMenuItem(
                            child: Text("CASH"),
                            value: 'CASH',
                          ),
                          DropdownMenuItem(
                            child: Text("TRANSFER"),
                            value: 'TRANSFER',
                          ),
                          DropdownMenuItem(
                            child: Text("RTGS"),
                            value: 'RTGS',
                          ),
                          DropdownMenuItem(
                            child: Text("NEFT"),
                            value: 'NEFT',
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        }),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 6,
                    child: TextField(
                      controller: _chqNumberController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'CHQ/NEFT/RTGS NUMBER'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //Bank Names
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
                        items: bankName.map((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e.toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _myValuebank = newVal;
                          });
                        },
                        value: _myValuebank,
                      ),
                    ),

              SizedBox(
                height: 10,
              ),
              //Bank Deposir Date
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextField(
                      readOnly: true,
                      controller: _bandepositDateController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select Deposit Date'),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _bankdepositselectDate(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //PAymeny type
              DropdownButton(
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  dropdownColor: Colors.white,
                  value: _myValuePaymentType,
                  items: [
                    DropdownMenuItem(
                      child: Text("Old-Payment"),
                      value: 'Old-Payment',
                    ),
                    DropdownMenuItem(
                      child: Text("Current-Payment"),
                      value: 'Current-Payment',
                    ),
                    DropdownMenuItem(
                      child: Text("Advance-Payment"),
                      value: 'Advance-Payment',
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _myValuePaymentType = value;
                    });
                  }),
              SizedBox(
                height: 10,
              ),
              //HAtch date selection type
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
              //Chick type and rate
              Row(
                children: [
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
                  Flexible(
                    flex: 20,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _chickrateController,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Enter Chick Rate'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _reamrkController,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration:
                    kTextFieldDecoration.copyWith(labelText: 'Enter Remarks'),
              ),

              SizedBox(
                height: 30,
              ),
              RoundedButton(
                  title: 'Next...',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    var connectivityResult =
                    await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi) {
                      showSnackBar('No internet connectivity');
                      return;
                    }
                    if (txtController.text.length <= 0) {
                       showSnackBar('Please provide a valid customer');
                       return;
                     }
                    if (_trDateController.text.length <= 0) {
                      showSnackBar('Please provide a valid TR date');
                      return;
                    }
                    if (_trAmountController.text.length <= 0) {
                      showSnackBar('Please provide a valid amount');
                      return;
                    }
                    else{
                      if(isNumeric(_trAmountController.text)== true)
                      {        }
                      else
                      {
                        showSnackBar('Please provide a valid amount');
                      }
                    }
                    if (_bandepositDateController.text.length <= 0) {
                      showSnackBar('Please provide a valid bank deposit date');
                      return;
                    }
                    if (_hatchDateController.text.length <= 0) {
                      showSnackBar('Please provide a valid bank hatch date');
                      return;
                    }
                    if ( _chickrateController.text.length<=0 ) {
                      showSnackBar('Please provide a valid  chicks rate');
                      return;
                    }
                    else{
                      if(isNumeric(_chickrateController.text)== true)
                      {        }
                      else
                      {
                        showSnackBar('Please provide a valid chicks rate');
                      }
                    }
                    addStringToSF();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisplayAndSaveTR()),
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
