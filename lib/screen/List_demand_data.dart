import 'package:flutter/material.dart';
import '../constant/constants.dart';
import '../widgets/rounded_button.dart';

class ListDemadData extends StatefulWidget {
  static const id = 'ListDemadData';
  @override
  _ListDemadDataState createState() => _ListDemadDataState();
}

class _ListDemadDataState extends State<ListDemadData> {
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
                    //controller: _trDateController,
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
                     // _selectTrDate(context);
                    },
                  ),
                ),

              ],
            ),
            RoundedButton(
                title: 'Show Demand',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  //fillTrData();
                }),
            RoundedButton(
                title: 'Show ALL Demand',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  // fillAllTrData();
                }),

          ],
        ),
      ),


    );
  }
}
