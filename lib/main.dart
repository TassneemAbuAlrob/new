import 'package:flutter/material.dart';
import 'package:webfront/Signup.dart';
import 'package:webfront/childProfile.dart';
import 'package:webfront/mainChild.dart';
import 'package:webfront/mainParent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'log',
      home: mainParent(),
    );
  }
}
