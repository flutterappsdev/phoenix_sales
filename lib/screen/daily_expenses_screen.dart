import 'dart:convert';
import 'package:flutter/material.dart';
import '../constant/constants.dart';
import 'package:http/http.dart' as http;
import '../widgets/rounded_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:toast/toast.dart';
import 'package:string_validator/string_validator.dart';
import '../network/network.dart';

class DailyExpensesScreen extends StatefulWidget {
  static const id = 'DailyExpensesScreen';
  @override
  _DailyExpensesScreenState createState() => _DailyExpensesScreenState();
}

class _DailyExpensesScreenState extends State<DailyExpensesScreen> {
  final _expDateController = TextEditingController();
  final _expAmountController = TextEditingController();
  final _expRemarkController = TextEditingController();
  List dataExpenses = List();
  String _expNumber = '';
  String _myValue = '124';
  bool _isDropDownFilled = false;
  DateTime selectedDate = DateTime.now();

  void getExpensesNo() async {
    try {
      String url = '$Url/GetExpNo?AreaCode=$AreaCode';
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      setState(() {
        if (data['ExpenseNo'].length > 0) {
          _expNumber = data['ExpenseNo'][0]['EXPNo'];
          print('trno' + _expNumber);
        } else {
          _expNumber = '-';
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void fillExpensesType() async {
    try {
      String url = '$Url/GetExpsType?AreaCode=$AreaCode';
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body);
      for (var c in extractedData['Area_Expenses_Master']) {
        setState(() {
          dataExpenses.add(c['Expense_head']);
        });
        print(c['Expense_head']);
      }

      print(dataExpenses);
      setState(() {
        _myValue = dataExpenses[0];
      });
      _isDropDownFilled = true;
    } catch (e) {}
  }
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
        _expDateController.text = selectedDate.toString().split(' ')[0];
      });
    } else {
      _expDateController.text = selectedDate.toString().split(' ')[0];
    }
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    getExpensesNo();
    fillExpensesType();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Expenses'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      controller: _expDateController,
                      style: TextStyle(color: Colors.black, fontSize: 19),
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: 'Select Entry Date'),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        print('in date fields');
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
                'Exp:' + _expNumber,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              !_isDropDownFilled
                  ? CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                  : DropdownButton(
                      isExpanded: true,
                      style: TextStyle(fontSize: 19, color: Colors.black),
                      items: dataExpenses.map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _myValue = newVal;
                        });
                      },
                      value: _myValue,
                    ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _expAmountController,
                style: TextStyle(color: Colors.black, fontSize: 19),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Amount Expenses'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _expRemarkController,
                style: TextStyle(color: Colors.black, fontSize: 19),
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter Expenses Remarks'),
              ),
              SizedBox(
                height: 30,
              ),
              RoundedButton(
                  title: 'SAVE',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    var connectivityResult =
                    await Connectivity().checkConnectivity();
                    if (connectivityResult != ConnectivityResult.mobile &&
                        connectivityResult != ConnectivityResult.wifi) {
                      Toast.show("Please check Network Connectivity", context,duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      return;
                    }

                    if (_expDateController.text.length <= 0) {
                      Toast.show('Please provide a valid expense date', context,duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      return;
                    }
                    if (_expAmountController.text.length <= 0) {

                      Toast.show('Please provide a valid amount', context,duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      return;
                    }
                    else{
                      if(isNumeric(_expAmountController.text)== true)
                      {        }
                      else
                      {

                        Toast.show('Please provide a valid amount', context,duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                      }
                    }

                    try {
                      String url =
                          '$Url/InsertExpsData?AreaCode=$AreaCode&Area=$AreaName&uname=${UserName}&';
                      url +=
                      "ExpNo=${_expNumber}&ExpDate=${_expDateController.text}&ExpenseType=$_myValue&ExpenseAmount=${_expAmountController.text}&";
                      url +=
                      "Remarks=${_expRemarkController.text}";
                        print(url);
                      NetworkHelper networkHelper = NetworkHelper(url);
                      var data = await networkHelper.getData();
                      print(data);
                    } catch (e) {
                      print(e);
                    }
                    // showToast("Show Long Toast", duration: Toast.LENGTH_LONG);
                    Toast.show("Expense Information Saved...", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

                    Navigator.of(context).pop();


                  }),
            ],
          ),
        ),
      ),
    );
  }
}
