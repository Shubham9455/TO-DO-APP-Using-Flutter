// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/apiclient.dart';
import 'package:velocity_x/velocity_x.dart';

  

import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiClient apiclient = ApiClient();
  late final SharedPreferences prefs;
  String token = "";
  bool regtapped = false;
  late String name = "";
  late String uname = "";
  late String email = "";
  late String password = "";
  bool _loading = true;
  @override
  void initState() {
    super.initState();

    getDataBase();

    checkAndPush();
  }

  checkAndPush() {
    Future.delayed(const Duration(seconds: 1), (() {
      if (token != "") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage(token: token)));
      }

      setState(() {});
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {});
        _loading = false;
      });
    }));

    debugPrint("token2 = $token");
    if (token != "") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(token: token)));
    }
  }

  putToken(String token) async {
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('username', uname);
    await prefs.setString('email', email);
  }

  deleteToken() async {
    await prefs.setString('token', "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
              strokeWidth: 10,
            ))
          : SafeArea(
              child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: VxArc(
                        height: 13,
                        arcType: VxArcType.CONVEY,
                        edge: VxEdge.BOTTOM,
                        child: Container(
                          height: 100,
                          color: Colors.deepPurple,
                          child: const Text(
                            "Login / Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                fontFamily: 'Fascinate'),
                          ).p20(),
                        ),
                      ),
                    )
                  ],
                ).pOnly(bottom: 20),
                Expanded(
                  flex: 5,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      regtapped
                          ? Image.asset("assets/images/register.png")
                          : Image.asset(
                              'assets/images/login.png',
                              height: 250,
                              fit: BoxFit.fill,
                            ),
                      TextFormField(
                        decoration: InputDecoration(
                          label: "Username".text.make(),
                          suffixIcon: const Icon(Icons.abc_rounded),
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        onChanged: (val) {
                          uname = val;
                          setState(() {});
                        },
                      ).px32().py8(),
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: 'X',
                        decoration: InputDecoration(
                          label: "Password".text.make(),
                          suffixIcon: const Icon(Icons.password),
                          prefixIcon: const Icon(Icons.key),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        onChanged: (val) {
                          password = val;
                          setState(() {});
                        },
                      ).px32().py8(),
                      regtapped
                          ? TextFormField(
                              decoration: InputDecoration(
                                label: "Name".text.make(),
                                suffixIcon: const Icon(Icons.abc),
                                prefixIcon: const Icon(CupertinoIcons.person),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              onChanged: (val) {
                                name = val;
                                setState(() {});
                              },
                            ).px32().py8()
                          : Container(),
                      regtapped
                          ? TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                label: "Email".text.make(),
                                suffixIcon: const Icon(CupertinoIcons.mail),
                                prefixIcon: const Icon(Icons.email),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              onChanged: (val) {
                                email = val;
                                setState(() {});
                              },
                            ).px32().py8()
                          : Container(),
                      Center(
                        child: GestureDetector(
                          child: (!regtapped)
                              ? "Login"
                                  .text
                                  .xl5
                                  .purple800
                                  .buttonText(context)
                                  .fontFamily('Fascinate')
                                  .make()
                              : "Register"
                                  .text
                                  .xl5
                                  .purple800
                                  .buttonText(context)
                                  .fontFamily('Fascinate')
                                  .make(),
                          onTap: () async {
                            if (regtapped) {
                              Response response = await apiclient.registerUser(
                                  uname, name, email, password);
                              token = (response.data)['token'];
                              debugPrint("token  = $token");
                              putToken(token);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(token: token)));
                            } else {
                              Response response =
                                  await apiclient.login(uname, password);
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.green,
                                    content: "Succes".text.make()));
                                token = (response.data)['token'];
                                debugPrint("token  = $token");
                                putToken(token);
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(token: token)));
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.red,
                                    content: "Invalid Data".text.make()));
                              }
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: "Register"
                                .text
                                .xl3
                                .xl
                                .red900
                                .buttonText(context)
                                .fontFamily('Fascinate')
                                .underline
                                .make(),
                            onTap: () {
                              regtapped = true;
                              setState(() {});
                            },
                          ).px8(),
                          GestureDetector(
                            child: "Login"
                                .text
                                .xl3
                                .xl
                                .red900
                                .buttonText(context)
                                .fontFamily('Fascinate')
                                .underline
                                .make(),
                            onTap: () {
                              regtapped = false;
                              setState(() {});
                            },
                          ).px8(),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            )),
    );
  }

  Future<void> getDataBase() async {
    prefs = await SharedPreferences.getInstance();
    token = ((prefs.getString('token') != null)
        ? (prefs.getString('token'))
        : (""))!;
    setState(() {});
  }
}
