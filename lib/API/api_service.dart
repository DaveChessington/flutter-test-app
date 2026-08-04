import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/models/User.dart';

class ApiService {
  final String baseURL =
      "http://127.0.0.1:5000"; //"http://davechessington.pythonanywhere.com";

  Future login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        // Manually decode the raw string body into a Dart Map
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }

  Future getUsers() async {
    try {
      List users = [];
      final response = await http.get(Uri.parse('$baseURL/users'));
      if (response.statusCode == 200) {
        Map res = jsonDecode(response.body) as Map<String, dynamic>;
        for (var i in res["users"]) {
          User u = new User();
          u.fromMap(i);
          users.add(u);
        }
        return users;
      } else {
        print('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }

  Future getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseURL/users/$id'));
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body) as Map<String, dynamic>;
        User u = new User();
        u.fromMap(res);
        return u;
      } else {
        print('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }

  Future getAvatar(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/users/profile_photo/$id'),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }
}
