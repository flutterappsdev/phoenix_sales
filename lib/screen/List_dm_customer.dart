import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import '../widgets/rounded_button.dart';
import '../constant/constants.dart';
import '../models/customer.dart';
import '../network/network.dart';


class ListDm {
  final String dmNo;
  final String dmDate;
  final String totalChicks;
  final String CCode;
  final String CName;
  final String Ctype;
  final String mortalty;
  final String rate;
  final String hdate;
  final String hatchries;

  ListDm(
      {this.dmNo,
        this.dmDate,
        this.totalChicks,
        this.CCode,
        this.CName,
        this.Ctype,
        this.mortalty,
        this.rate,
        this.hdate,
        this.hatchries});
}

class ListDmCustomer extends StatefulWidget {
  static const id = 'ListDmCustomer';
  @override
  _ListDmCustomerState createState() => _ListDmCustomerState();
}

class _ListDmCustomerState extends State<ListDmCustomer> {

  final GlobalKey<ScaffoldState> ScafoldKey = new GlobalKey<ScaffoldState>();
  List<String> customerList = [];
  List<Customer> customerList1 = [];
  List<String> added = [];
  List<ListDm> dmList = [];
  bool _isDropDownFilled = false;

  final txtController = TextEditingController();

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
  void filldmData() async {
    String url =
        '$Url/ShowCustomerDMData?AreaCode=$AreaCode&uname=$UserName&code=${added[1]}';
    print(url);
    NetworkHelper networkHelper = NetworkHelper(url);
    var data = await networkHelper.getData();
    // print(data);
    dmList.clear();
    for (var c in data['CustomerDMData']) {
      if (c['DMNo'].toString() != 'null') {
        setState(() {
          dmList.add(ListDm(
              dmNo: c['DMNo'].toString(),
              dmDate: c['DMDate'].toString(),
              totalChicks: c['TotalChicks'].toString(),
              CCode: c['Code'].toString(),
              CName: c['CName'].toString(),
              Ctype: c['Chick_type'].toString(),
              mortalty: c['Mortality'].toString(),
              rate: c['Rate'].toString(),
              hdate: c['HatchDate'].toString(),
              hatchries: c['Hatchries'].toString()
          ));
        });
      }
    }
    _isDropDownFilled = true;
    print(dmList[0].CName);
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
        title: Text('List DM Customer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
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
                  filldmData();
                }),
            SizedBox(height: 8,),
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
                        'Chick : ' + dmList[index].Ctype.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        'Hatch Date: ' + dmList[index].hdate.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Text(
                        "Total Chicks " +
                            dmList[index].totalChicks.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Transit Mortality: " +
                                  dmList[index].mortalty.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Rate: " + dmList[index].rate.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),

                      Text(
                        "Unit:" +
                            dmList[index].hatchries.toString(),
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
