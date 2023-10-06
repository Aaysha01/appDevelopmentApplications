import 'package:flutter/material.dart';
import 'package:appdevelopmentapplications_aaysha/view/HomeScreen.dart';
import 'package:appdevelopmentapplications_aaysha/view/drawing_page.dart';
import 'view/exp3_2.dart';
import 'view/home.dart';
void main() {
  //runApp(const MyApp());
  runApp( MaterialApp(
    home:HomeScreen(),
  ));
}

const Color kCanvasColor = Color(0xfff2f3f7);
const String kGithubRepo = 'https://github.com/JideGuru/flutter_drawing_board';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Let\'s Draw',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const DrawingPage(),
    );
  }
}
