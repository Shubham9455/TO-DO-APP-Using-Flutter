// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/apiclient.dart';
import 'package:todo/pages/profile_page.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/todo.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiClient apiclient = ApiClient();
  final myController = TextEditingController();
  List<TodoDetails> todoList = [];
  String name = '';
  String uname = '';
  String email = '';
  String title = "";
  String date = "";
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    getData();
    getProfileData();
    // debugPrint(todoList[0].title);
  }

  refresh() {
    setState(() {});
    getData();
  }

  deleteToken() async {
    await prefs.setString('token', "");
  }

  getProfileData() async {
    var data = await apiclient.getUserProfileData(widget.token);
    setState(() {
      name = data['name'];
      uname = data['username'];
      email = data['email'];
    });
  }

  getData() async {
    prefs = await SharedPreferences.getInstance();
    Todo todoClass = Todo();
    await todoClass.getTodos(widget.token);
    setState(() {});
    todoList = todoClass.todoList;
    debugPrint(todoList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: VxArc(
                  height: 13,
                  arcType: VxArcType.CONVEY,
                  edge: VxEdge.BOTTOM,
                  child: Container(
                    height: 150,
                    color: Colors.deepPurple,
                    child: Center(
                      child: const Text(
                        "TO-DO",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            fontFamily: 'Fascinate'),
                      ).p24(),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
              height: 100,
              child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: ((context, index) => TodoTile(
                      notifyParent: getData,
                      token: widget.token,
                      title: todoList[todoList.length - index - 1].title,
                      id: todoList[todoList.length - index - 1].id)))).expand(),
          const SizedBox(
            height: 50,
          )
        ],
      ),
      floatingActionButton: GestureDetector(
        child: const Icon(Icons.add_circle_rounded, size: 70, color: Colors.red)
            .p24(),
        onTap: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => Container(
                  height: 500,
                  color: const Color.fromARGB(255, 239, 222, 170),
                  child: Column(
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          label: "Title Of Todo".text.make(),
                          suffixIcon: const Icon(Icons.work),
                          prefixIcon: const Icon(Icons.edit),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        onChanged: (val) {
                          title = val;
                          setState(() {});
                        },
                      ).px32().pOnly(top: 30),
                      TextFormField(
                        decoration: InputDecoration(
                          label: "date".text.make(),
                          suffixIcon: const Icon(Icons.work),
                          prefixIcon: const Icon(Icons.edit),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        onTap: () async {
                          DateTime? idate = DateTime(1900);
                          FocusScope.of(context).requestFocus(FocusNode());
                          idate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now());
                          if (idate != null) {
                            setState(() => {
                                  date = idate.toString(),
                                  myController.text = idate.toString()
                                });
                          }
                        },
                      ).px32().pOnly(top: 30),
                      GestureDetector(
                        child: const Icon(
                          Icons.done_all_rounded,
                          size: 40,
                        ).pOnly(top: 50),
                        onTap: () {
                          apiclient.createTodo(widget.token, ("$title;$date"));
                          Future.delayed(const Duration(milliseconds: 500), () {
                            getData();
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
      backgroundColor: Colors.white,
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: -15,
        color: Colors.deepPurple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) => Container(
                          height: 500,
                          color: const Color.fromARGB(255, 239, 222, 170),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              name.text.xl5.extraBold.red700
                                  .make()
                                  .pOnly(top: 50),
                              ("username: $uname").text.extraBold.xl3.make(),
                              ("email: $email").text.extraBold.xl2.make(),
                              GestureDetector(
                                onTap: () {
                                  deleteToken();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: "Logging Out".text.make()));
                                  Navigator.pushReplacement(
                                      context,

                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 50,
                                    color: Colors.deepPurple,
                                    child: "LOGOUT".text.white.make().p16(),
                                  ),
                                ).p32(),
                              )
                            ],
                          ),
                        )),
                icon: const Icon(
                  CupertinoIcons.person_circle,
                  size: 30,
                  color: Colors.white,
                )),
            const Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ).px12()
          ],
        ));
  }
}

class TodoTile extends StatefulWidget {
  final Function() notifyParent;
  String utitle = '';
  
  String date = "";
  final String token;
  double _height = 155;
  bool tiletapped = false;
  final myController = TextEditingController();
  Color _color = Color.fromRGBO(
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 0.5);
  final String title;
  final int id;
  TodoTile(
      {Key? key,
      required this.title,
      required this.id,
      required this.token,
      required this.notifyParent})
      : super(key: key);

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          widget._height = (widget._height == 155) ? 170 : 155;
          widget._color = Color.fromRGBO(Random().nextInt(256),
              Random().nextInt(256), Random().nextInt(256), 0.5);
          Future.delayed(const Duration(milliseconds: 300), (() {
            widget.tiletapped = widget.tiletapped ? false : true;
            print(widget.tiletapped);
            setState(() {});
          }));
        });
      }),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),

          height: widget._height,

          // elevation: 5,
          color: widget._color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  child:
                      Column(
                        children: [
                          widget.title.split(";")[0].text.extraBlack.extraBold.xl2.make().p24(),
                          widget.title.split(";")[1].split(" ")[0].text.extraBlack.extraBold.make().p8(),
                        ],
                      )),
              widget.tiletapped
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) => Container(
                                      height: 500,
                                      color: const Color.fromARGB(
                                          255, 239, 222, 170),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              label:
                                                  "Title Of Todo".text.make(),
                                              suffixIcon:
                                                  const Icon(Icons.work),
                                              prefixIcon:
                                                  const Icon(Icons.edit),
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                            onChanged: (val) {
                                              widget.utitle = val;
                                              setState(() {});
                                            },
                                          ).px32().pOnly(top: 30),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              label: "date".text.make(),
                                              suffixIcon:
                                                  const Icon(Icons.work),
                                              prefixIcon:
                                                  const Icon(Icons.edit),
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                            onTap: () async {
                                              DateTime? idate = DateTime(1900);
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              idate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1980),
                                                  lastDate: DateTime.now());
                                              if (idate != null) {
                                                setState(() => {
                                                      widget.date =
                                                          idate.toString(),
                                                      widget.myController.text =
                                                          idate.toString()
                                                    });
                                              }
                                            },
                                          ).px32().pOnly(top: 30),
                                          GestureDetector(
                                            child: const Icon(
                                              Icons.done_all_rounded,
                                              size: 40,
                                            ),
                                            onTap: () {
                                              ApiClient apiclient = ApiClient();
                                              apiclient.updateTodo(
                                                  widget.token,
                                                  widget.id,
                                                  ("${widget.utitle};${widget.date}"));
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar( 
                                    duration: Duration(milliseconds: 500),
                                    backgroundColor: Colors.green,
                                    content: "Updating Todo".text.make()));
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                widget.notifyParent();
                                              });
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    )),
                            icon: const Icon(
                              Icons.edit,
                              size: 30,
                            )),
                        IconButton(
                            onPressed: () {
                              ApiClient apiClient = ApiClient();
                              apiClient.deleteTodo(widget.token, widget.id);
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                widget.notifyParent();
                              });
                            },
                            icon: const Icon(
                              CupertinoIcons.delete,
                              size: 30,
                            ))
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ).px64().py8(),
    );
  }
}
