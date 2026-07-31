import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  final String baseURL = "http://davechessington.pythonanywhere.com"; //"http://127.0.0.1:5000";

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

  Future getUsers() async{
    try {
      final response = await http.get(
        Uri.parse('$baseURL/users'),
      );
       if (response.statusCode == 200) {
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

  Future getUserById(int id) async{
    try {
      final response = await http.get(
        Uri.parse('$baseURL/users/$id'),
      );
       if (response.statusCode == 200) {
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
}
