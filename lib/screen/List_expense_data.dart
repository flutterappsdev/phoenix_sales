import 'package:flutter/material.dart';
import '../constant/constants.dart';
import '../widgets/rounded_button.dart';
import '../network/network.dart';


class ListExpenses {
  final String ExpNo;
  final String ExpDate;
  final String ExpenseType;
  final String ExpenseAmount;
  final String Remarks;

  //
  // "id": 9,
  // "AreaCode": "RP",
  // "Area": "RAIPUR",
  // "session": "2021",
  // "uname": "qw",
  // "entrydate": "2021-01-14T17:00:14.52",
  // "ExpNo": "EXP/2/RP/Jan 14 2021  5:00PM/2021",
  // "ExpDate": "2021-01-14T00:00:00",
  // "ExpenseType": "Petrol Expenses",
  // "ExpenseAmount": "125",
  // "Remarks": "myexpenses",
  // "expidarea": 2,
  // "isEmailed": null,
  // "isPosted": null

  ListExpenses(
      {this.ExpNo,
        this.ExpDate,
        this.ExpenseType,
        this.ExpenseAmount,
        this.Remarks,
        });
}


class ListExpenseData extends StatefulWidget {
  static const id = 'ListExpenseData';
  @override
  _ListExpenseDataState createState() => _ListExpenseDataState();
}

class _ListExpenseDataState extends State<ListExpenseData> {

  final _dmDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<ListExpenses> expenseList = [];
  bool _isDropDownFilled = false;


  void fillExpenses() async {
    String url =
        '$Url/ShowAreaExpsData?&uname=$UserName&Exp_Date=${_dmDateController.text}';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
     //print(data);
    expenseList.clear();
    for (var c in data['AreaExpenseData']) {

      if (c['ExpNo'].toString() != 'null') {
        print(c['ExpNo'].toString());
        setState(() {
          expenseList.add(ListExpenses(
            ExpNo: c['ExpNo'].toString(),
            ExpDate: c['ExpDate'].toString(),
            ExpenseType: c['ExpenseType'].toString(),
            ExpenseAmount: c['ExpenseAmount'].toString(),
              Remarks:c['Remarks'].toString(),
                      ));
        });
      }
    }
    _isDropDownFilled = true;
   // print("cddsfsf" + expenseList[0].ExpenseType);
    print(expenseList.length.toString());
  }

  _selectDemandDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dmDateController.text = selectedDate.toString().split(' ')[0];
      });
    } else {
      _dmDateController.text = selectedDate.toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Expense Data'),

      ),
      body: Padding(
        padding:  EdgeInsets.all(10),
        child: Column(
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
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  flex: 6,
                  child: TextField(
                    controller: _dmDateController,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Select Expense Date'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDemandDate(context);
                    },
                  ),
                ),

              ],
            ),
            RoundedButton(
                title: 'Show Expense',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  fillExpenses();
                }),
            // RoundedButton(
            //     title: 'Show ALL Demand',
            //     colour: Colors.lightBlueAccent,
            //     onPressed: () async {
            //       // fillAllTrData();
            //     }),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        expenseList[index].ExpNo.toString(),
                        style: TextStyle(color: Colors.green),
                      ),

                      Text(
                        'Expense Date: ' + expenseList[index].ExpDate.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Expense Type: ' + expenseList[index].ExpenseType .toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "Expense Amounr  " +
                            expenseList[index].ExpenseAmount.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Remarks  " +
                                  expenseList[index].Remarks.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Divider(
                        height: 3,
                        thickness: 1.5,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                  itemCount: expenseList.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
