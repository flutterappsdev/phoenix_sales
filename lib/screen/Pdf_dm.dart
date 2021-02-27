import 'package:flutter/material.dart';
import '../screen/generateDmPrint.dart';
import 'package:printing/printing.dart';

class PdfDm extends StatefulWidget {
  static const String id = 'PdfDm';
  @override
  _PdfDmState createState() => _PdfDmState();
}

class _PdfDmState extends State<PdfDm> {
  @override
  Widget build(BuildContext context) {
    var trdata = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format)=>generateDmPrint(format,trdata['dmno'].toString(),
            trdata['dmdate'].toString(),
            trdata['cname'].toString(),
            trdata['hatchdate'].toString(),
            trdata['ctype'].toString(),
            trdata['qty'].toString(),
            trdata['mortality'].toString(),
           trdata['rate'].toString()
        ),
      ),
    );
  }
}
