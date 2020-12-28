import 'dart:convert';
import 'package:flutter/material.dart';
import '../constant/constants.dart';
import 'package:http/http.dart' as http;

class DailyExpensesScreen extends StatefulWidget {
  static const id = 'DailyExpensesScreen';
  @override
  _DailyExpensesScreenState createState() => _DailyExpensesScreenState();
}

class _DailyExpensesScreenState extends State<DailyExpensesScreen> {

  final _expDateController = TextEditingController();
  List dataExpenses = List();
  String _expNumber='';
  String _myValue = '124';

  void fillExpensesType() async {
    try {
      String url = '$Url/GetExpsType?AreaCode=$AreaCode';
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) ;
      //print(extractedData);
      // extractedData.forEach((key, value) {
      //   print(key);
      //   setState(() {
      //     dataExpenses.add(value['Expense_head']);
      //   });
      // });

      for (var c in extractedData['Area_Expenses_Master']) {
        print(c['Expense_head']);
      }

      print(dataExpenses);
      setState(() {
        _myValue = dataExpenses[0];
      });
    }
    catch(e)
    {

    }
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
                      //controller: _expDateController,
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
                       // _selectDate(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Exp:' + "",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
