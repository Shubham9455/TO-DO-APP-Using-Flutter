import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();
  
  //User Registration
  Future<Response> registerUser(
      String uname, String name, String email, String password) async {
    try {
      Response response =
          await _dio.post('https://todo-app-csoc.herokuapp.com/auth/register/',
              data: {
                'name': name,
                "email": email,
                "username": uname,
                "password": password,
              },
              options: Options(contentType: "application/json", headers: {
                "accept": "application/json",
                "Content-Type": "application/json",
                "X-CSRFToken":
                    "tIu453K3Za1tMhVjocHQihpn1vVnhm9OHT2n9Li5OHut3jQEdQkyYAcaik2aMgRx"
              }));
      return response;
    } on DioError catch (e) {
      return e.response!;
    }
  }

  //User Login
  Future<Response> login(String username, String password) async {
    try {
      Response response =
          await _dio.post('https://todo-app-csoc.herokuapp.com/auth/login/',
              data: {'username': username, 'password': password},
              options: Options(contentType: "application/json", headers: {
                "accept": "application/json",
                "Content-Type": "application/json",
                "X-CSRFToken":
                    "4msrayr5GHeWlfO4PPE1MUWDKtVgXwv5ix0KegZ7veHWChJpEthJsdJq1i23sqdO"
              }));
      return response;
    } on DioError catch (e) {
      return e.response!;
    }
  }
  // Get Profile Data
  getUserProfileData(String accesstoken) async {
    try {
      Response response = await _dio.get(
        'https://todo-app-csoc.herokuapp.com/auth/profile/',
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            "accept": "application/json",
            "X-CSRFToken": "LQMXytPp1oJMAcrAdZ4y0I0IV6RV1anBZ1kgCbnrQVcMRemV2DHgG1NvcVYIw45k"

          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!;
    }
  }
  // Future<Response> logout() async {
  //   //IMPLEMENT USER LOGOUT
  // }

  //For Geting To Do List
  getTodo(String accesstoken) async {
    try {
      Response response = await _dio.get(
        'https://todo-app-csoc.herokuapp.com/todo/',
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            "accept": "application/json"
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      return e.response!;
    }
  }

  //For Creating To Do
  Future<Response> createTodo(String accesstoken, String title) async {
    try {
      Response response = await _dio.post(
        'https://todo-app-csoc.herokuapp.com/todo/create/',
        data: {
          'title': title,
        },
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      return e.response!;
    }
  }

  //For Updating To Do
  Future<Response> updateTodo(
      String accesstoken, int id, String title) async {
    try {
      Response response = await _dio.put(
        'https://todo-app-csoc.herokuapp.com/todo/$id/',
        data: {
          'title': title,
        },
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            "Content-Type": "application/json",
            "accept": "application/json",
            "X-CSRFToken":
                "froYxTp3uBxWAyOiSulp8N4nAmKZOIIUtCWhBBX5j80WRAJDH8Y7O6RaRbRMjCqD"
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      return e.response!;
    }
  }

  //For Partially Updating To Do
  Future<Response> partupdateTodo(
      String accesstoken, int id, String title) async {
    try {
      Response response = await _dio.patch(
        'https://todo-app-csoc.herokuapp.com/todo/$id/',
        data: {'title': title},
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            "Content-Type": "application/json",
            "accept": "application/json",
            "X-CSRFToken": "froYxTp3uBxWAyOiSulp8N4nAmKZOIIUtCWhBBX5j80WRAJDH8Y7O6RaRbRMjCqD"
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      return e.response!;
    }
  }

  //For Reading To Do
  Future<Response> readTodo(String accesstoken, String id) async {
    try {
      Response response = await _dio.get(
        'https://todo-app-csoc.herokuapp.com/todo/$id/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accesstoken',
            "Content-Type": "application/json",
            "accept": "application/json"
          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  //For Deleting To Do
  Future<Response> deleteTodo(String accesstoken, int id) async {
    try {
      Response response = await _dio.delete(
        'https://todo-app-csoc.herokuapp.com/todo/$id/',
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            "Content-Type": "application/json",
            "accept": "application/json",
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      return e.response!;
    }
  }
}
