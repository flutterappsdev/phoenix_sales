import 'package:flutter/material.dart';
import '../network/network.dart';
import '../constant/constants.dart';
import '../widgets/rounded_button.dart';
import '../screen/Pdf_tr.dart';

class ListTr {
  final String TrNo;
  final String TrDate;
  final String Amount;
  final String CCode;
  final String CName;
  final String Ctype;
  final String bankdet;
  final String hatchdate;
  final String paytype;
  final String rate;
  final String bankdate;
  ListTr(
      {this.TrNo,
      this.TrDate,
      this.Amount,
      this.CCode,
      this.CName,
      this.Ctype,this.bankdet,this.hatchdate,this.paytype,this.rate,this.bankdate});
}

class ListTrData extends StatefulWidget {
  static const String id = 'ListTrData';
  @override
  _ListTrDataState createState() => _ListTrDataState();
}

class _ListTrDataState extends State<ListTrData> {
  final _trDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<ListTr> trList = [];
  bool _isDropDownFilled = false;

  void fillTrData() async {
    String url =
        '$Url/ShowTrData?AreaCode=$AreaCode&uname=$UserName&TrDate=${_trDateController.text}';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    trList.clear();
    //print(data);
    for (var c in data['TrData']) {
      if (c['TRNo'].toString() != 'null') {
        setState(() {
          trList.add(ListTr(
            TrNo: c['TRNo'].toString(),
            TrDate: c['TrDate'].toString(),
            Amount: c['TrAmount'].toString(),
            CCode: c['Code'].toString(),
            CName: c['CName'].toString(),
            Ctype: c['Chick_type'].toString(),
            bankdet: c['Bank_det'].toString(),
            hatchdate: c['HatchDate'].toString(),
            paytype: c['Pay_mode'].toString(),
            rate: c['Rate'].toString(),
            bankdate: c['bankdate'].toString()
          ));
        });
      }
    }
    _isDropDownFilled = true;
    // print(trList[0].CName);
  }

  void fillAllTrData() async {
    String url =
        '$Url/ShowAllTrData?AreaCode=$AreaCode&uname=$UserName';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    //print(data);
    trList.clear();
    for (var c in data['TrData']) {
      if (c['TRNo'].toString() != 'null') {
        setState(() {
          trList.add(ListTr(
            TrNo: c['TRNo'].toString(),
            TrDate: c['TrDate'].toString(),
            Amount: c['TrAmount'].toString(),
            CCode: c['Code'].toString(),
            CName: c['CName'].toString(),
            Ctype: c['Chick_type'].toString(),
            bankdet: c['Bank_det'].toString(),
            hatchdate: c['HatchDate'].toString(),
            paytype: c['Pay_mode'].toString(),
            rate: c['Rate'].toString(),
            bankdate: c['bankdate'].toString()
          ));
        });
      }
    }
    _isDropDownFilled = true;
    // print(trList[0].CName);
  }

  _selectTrDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // fillTrData();
    fillAllTrData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List TR'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
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
                    controller: _trDateController,
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
                      _selectTrDate(context);
                    },
                  ),
                )
              ],
            ),
            RoundedButton(
                title: 'Show TR',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  fillTrData();
                }),
            RoundedButton(
                title: 'Show ALL TR',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  fillAllTrData();
                }),
            !_isDropDownFilled
                ? SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
            : Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, PdfTr.id , arguments: {
                        'trno':trList[index].TrNo.toString(),
                        'trdate': trList[index].TrDate.toString(),
                        'cname':trList[index].CName +"#" + trList[index].CCode.toString(),
                        'amt':trList[index].Amount.toString(),
                        'bankdet': trList[index].bankdet.toString(),
                        'hatchdate':trList[index].hatchdate.toString(),
                        'rate':trList[index].rate.toString(),
                      });
                      print('tr pds');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          trList[index].TrNo.toString(),
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          trList[index].CName +
                              "#" +
                              trList[index].CCode.toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                        Text('TR DaTe: '+
                          trList[index].TrDate.toString(),
                          style: TextStyle(color: Colors.black),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Text('TR Amount: ' +
                                  trList[index].Amount.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Text('Rate: ' +
                                  trList[index].rate .toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Text('' +
                                  trList[index].Ctype.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Text('Hatch Date: ' +
                                  trList[index].hatchdate.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          trList[index].bankdet.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                        Text('Deposit Date:'+
                          trList[index].bankdate.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 3,),
                        Divider(
                          height: 3,
                          thickness: 1.5,
                          color: Colors.blue,
                        ),
                        SizedBox(height: 3,),
                      ],
                    ),
                  ),
                  itemCount: trList.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
