import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/menu.dart';

const DUMMY_CATEGORIES = const [
  Menu(
    id: 'c1',
    title: 'TR Creation',
    color: Colors.purple,
    routeName: 'TrEntry',
    icon: Icons.note_add_outlined
  ),
  Menu(
    id: 'c2',
    title: 'Supply',
    color: Colors.red,
    icon: Icons.delivery_dining,
    routeName: 'SupplyEntryScreen'

  ),
  Menu(
    id: 'c3',
    title: 'Chicks Demand',
    color: Colors.orange,
    routeName: 'ChicksDemandScreen',
    icon: Icons.note
  ),
  Menu(
    id: 'c4',
    title: 'List TR(Customer)',
    routeName: 'ListTrCustomer',
    color: Colors.amber,
      icon: FontAwesomeIcons.list
  ),
  Menu(
      id: 'c4',
      title: 'Daily Expenses',
      color: Colors.blueGrey,
      routeName: 'DailyExpensesScreen',
      icon: FontAwesomeIcons.moneyBill
  ),
  Menu(
    id: 'c5',
    title: 'Image Upload',
    color: Colors.blue,
    icon: FontAwesomeIcons.camera,
    routeName: 'ImageUploadScreen',
  ),
  Menu(
    id: 'c6',
    title: 'List TR',
    color: Colors.green,
    icon: FontAwesomeIcons.list,
    routeName: 'ListTrData'
  ),
  Menu(
    id: 'c7',
    title: 'List Supply',
    color: Colors.lightBlue,
      icon: FontAwesomeIcons.listAlt,
    routeName: 'ListDmData'
  ),
  Menu(
    id: 'c8',
    title: 'List Demand',
    color: Colors.lightGreen,
      icon: FontAwesomeIcons.listOl,
      routeName: 'ListDemadData'
  ),
  Menu(
    id: 'c9',
    title: 'List Expenses',
    color: Colors.pink,
      routeName: 'ListExpenseData',
      icon: FontAwesomeIcons.moneyBillWave
  ),

  Menu(
      id: 'c4',
      title: 'List Supply(Customer)',
      color: Colors.amber,
      routeName: 'ListDmCustomer',
      icon: FontAwesomeIcons.list
  ),
  Menu(
    id: 'c10',
    title: 'Start Trip',
    routeName: 'TripScreen',
    color: Colors.teal,
      icon: FontAwesomeIcons.mapSigns
  ),
];