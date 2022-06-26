import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:todo/models/apiclient.dart';

class TodoDetails {
  late String title;
  late int id;

  TodoDetails({
    required this.id,
    required this.title,
  });
}

class Todo {
  List<TodoDetails> todoList = [];



  //For filling todoList
  Future<void> getTodos(String accesstoken) async {
    ApiClient apiclient = ApiClient();
    List data = await apiclient.getTodo(accesstoken);
    
    for (var element in data) {
      TodoDetails todo =
          TodoDetails(id: element['id'], title: element['title']);
      todoList.add(todo);
    }
  }



}
