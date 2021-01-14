import 'package:flutter/material.dart';
import '../constant/constants.dart';
import '../widgets/rounded_button.dart';
import '../network/network.dart';


class ListDemand {
  final String dmNo;
  final String dmDate;
  final String totalChicks;
  final String CCode;
  final String CName;
  final String Ctype;
  final String mortalty;
  final String rate;
  final String hdate;

  ListDemand(
      {this.dmNo,
        this.dmDate,
        this.totalChicks,
        this.CCode,
        this.CName,
        this.Ctype,
        this.mortalty,
        this.rate,
        this.hdate});
}


class ListDemadData extends StatefulWidget {
  static const id = 'ListDemadData';
  @override
  _ListDemadDataState createState() => _ListDemadDataState();
}

class _ListDemadDataState extends State<ListDemadData> {

  final _dmDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<ListDemand> dmList = [];
  bool _isDropDownFilled = false;


  void filldemandData() async {
    String url =
        '$Url/ShowDemandData?AreaCode=$AreaCode&uname=$UserName&DMDate=${_dmDateController.text}';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    // print(data);
    dmList.clear();
    for (var c in data['DemandData']) {
      if (c['DMNo'].toString() != 'null') {
        setState(() {
          dmList.add(ListDemand(
            dmNo: c['DMNo'].toString(),
            dmDate: c['DMDate'].toString(),
            totalChicks: c['TotalChicks'].toString(),
            CCode: c['Code'].toString(),
            CName: c['CName'].toString(),
            Ctype: c['Chick_type'].toString(),
            mortalty: c['Mortality'].toString(),
            rate: c['Rate'].toString(),
            hdate: c['HatchDate'].toString(),
          ));
        });
      }
    }
    _isDropDownFilled = true;
    print("cddsfsf" + dmList[0].CName);
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
        title: Text('List Demand Data'),
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
                        labelText: 'Select Hatch Date'),
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
                title: 'Show Demand',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  filldemandData();
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
                        dmList[index].dmNo.toString(),
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        dmList[index].CName +
                            "#" +
                            dmList[index].CCode.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                      Text(
                        'Demand Date: ' + dmList[index].dmDate.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Hatch Date: ' + dmList[index].hdate.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "Demand Qty Chicks-1  " +
                            dmList[index].totalChicks.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Demand Qty Chicks-2  " +
                                  dmList[index].mortalty.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "-",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
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
                  itemCount: dmList.length,
                ),
              ),
            )
          ],
        ),
      ),


    );
  }
}
