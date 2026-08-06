import 'dart:convert';

import 'package:flutter/material.dart';
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

  Future<ImageProvider?> getAvatar(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/users/profile_photo/$id'),
      );
      if (response.statusCode == 200) {
        // Use MemoryImage with the response bytes for binary image data
        return MemoryImage(response.bodyBytes);
      } else {
        print('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }

  Future addUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/users'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(user.toMap()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Server Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Network Error: $e');
      return false;
    }
  }
}
