import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import '../network/network.dart';
import '../constant/constants.dart';
import '../widgets/rounded_button.dart';
import '../models/customer.dart';
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
      this.Ctype,
      this.bankdet,
      this.hatchdate,
      this.paytype,
      this.rate,this.bankdate});
}

class ListTrCustomer extends StatefulWidget {
  static const id = 'ListTrCustomer';
  @override
  _ListTrCustomerState createState() => _ListTrCustomerState();
}

class _ListTrCustomerState extends State<ListTrCustomer> {
  final GlobalKey<ScaffoldState> ScafoldKey = new GlobalKey<ScaffoldState>();
  List<String> customerList = [];
  List<Customer> customerList1 = [];
  List<String> added = [];
  List<ListTr> trList = [];
  final txtController = TextEditingController();
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

  void fillTrData() async {
    String url =
        '$Url/ShowCustomerTrData?AreaCode=$AreaCode&uname=$UserName&code=${added[1]}';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    trList.clear();
    print(data);
    for (var c in data['CustomerTrData']) {
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
            bankdate: c['bankdate'].toString(),
          ),);
        });
      }
    }
    _isDropDownFilled = true;
    // print(trList[0].CName);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    filCustomer();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Tr Customer'),
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
                //fetchCustomerMobile(added[1]);
                print('Customer' + added[1]);
              },
              itemBuilder: (context, item) {
                // ui for the autocomplete row
                return row(item);
              },
            ),
            SizedBox(height: 5),
            RoundedButton(
                title: 'Show TR',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  fillTrData();
                }),
            SizedBox(
              height: 8,
            ),
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
                          onTap: () {
                            Navigator.pushNamed(context, PdfTr.id, arguments: {
                              'trno': trList[index].TrNo.toString(),
                              'trdate': trList[index].TrDate.toString(),
                              'cname': trList[index].CName +
                                  "#" +
                                  trList[index].CCode.toString(),
                              'amt': trList[index].Amount.toString(),
                              'bankdet': trList[index].bankdet.toString(),
                              'hatchdate': trList[index].hatchdate.toString(),
                              'rate': trList[index].rate.toString(),
                              'bankdate': trList[index].bankdate.toString(),
                            });
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
                              Text(
                                'TR DaTe: ' + trList[index].TrDate.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'TR Amount: ' +
                                          trList[index].Amount.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Rate: ' + trList[index].rate.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '' + trList[index].Ctype.toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Hatch Date: ' +
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
