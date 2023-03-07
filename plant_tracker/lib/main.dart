import 'package:flutter/material.dart';
import 'My_Plants_Page.dart';
import 'Import_Export_Page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyHome());
  }
}

//this builds the material App
class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: getHomePage(
          context), //i guess we change this function to have different bodies?
    );
  }
}
