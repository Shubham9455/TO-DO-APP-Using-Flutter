import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/utils/routes.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DOBs",
      theme: ThemeData(
          // fontFamily: 'BirthstoneBounce',

          ),
      // home: HomePage(token: "13cc9275cf62b37d8c4bbea5e30a25d8d0fcbaa0",),
      home: MyHomePage(),
      routes: {
        MyRouts.loginRoute: (context) => ProfilePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfilePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Image.asset("assets/images/icons8-to-do-64.png"));
  }
}
