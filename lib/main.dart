import 'package:flutter/material.dart';
import 'package:flutter_designtest01/design/home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home(),//시작화면 불러옴 -> 구글맵 home.dart
    );
  }
}

