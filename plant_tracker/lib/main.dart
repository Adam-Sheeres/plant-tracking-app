import 'package:flutter/material.dart';
import 'My_Plants_Page.dart';
import 'Import_Export_Page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
      ),
      home: getHomePage(
          context), //i guess we change this function to have different bodies?
    );
  }
}
