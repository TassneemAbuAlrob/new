import 'package:finalfrontproject/Signup.dart';
import 'package:finalfrontproject/addChild.dart';
import 'package:finalfrontproject/mainChild.dart';
import 'package:finalfrontproject/perantDash.dart';
import 'package:finalfrontproject/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:finalfrontproject/screens/welcome/welcome_screen.dart';
import 'package:finalfrontproject/constants.dart';
import 'package:finalfrontproject/user.dart';

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
      theme: ThemeData(
        primaryColor: KPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: welcomeScreen(),
    );
  }
}
