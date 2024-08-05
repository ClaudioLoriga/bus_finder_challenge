import 'package:flutter/material.dart';
import 'views/bus_lines_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomepageScreen(),
    );
  }
}