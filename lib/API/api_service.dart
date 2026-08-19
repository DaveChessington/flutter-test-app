import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/models/User.dart';

class ApiService {
  String get baseURL {
    final isDebug = dotenv.env['debug']?.toLowerCase() == 'true';
    final key = isDebug ? 'API_BASE_URL_LOCAL' : 'API_BASE_URL_PRODUCTION';
    final url = dotenv.env[key];
    if (url == null || url.isEmpty) {
      throw StateError('$key no está configurada en el archivo .env');
    }
    return url;
  }

  // ─── Auth ────────────────────────────────────────────────────────────────

  Future login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}),
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

  // ─── Users ───────────────────────────────────────────────────────────────

  Future getUsers() async {
    try {
      List users = [];
      final response = await http.get(Uri.parse('$baseURL/users'));
      if (response.statusCode == 200) {
        Map res = jsonDecode(response.body) as Map<String, dynamic>;
        for (var i in res["users"]) {
          User u = User();
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

  Future<User?> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseURL/users/$id'));
      print('getUserById($id) status: ${response.statusCode}');
      print('getUserById($id) body: ${response.body}');
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body) as Map<String, dynamic>;
        // Handle both {"id":...} and {"user":{"id":...}} response shapes
        var userData = body.containsKey('user') ? body['user'] : body;
        User u = User();
        u.fromMap(userData);
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

  Future<bool> updateUser(int id, User user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/users/$id'),
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

  Future<bool> addUser(User user) async {
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

  Future<int?> createUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/users'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(user.toMap()),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Server Error: ${response.statusCode}');
        return null;
      }

      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        final data = body['user'] is Map<String, dynamic>
            ? body['user'] as Map<String, dynamic>
            : body;
        return data['id'] as int?;
      }
      return null;
    } catch (e) {
      print('Network Error: $e');
      return null;
    }
  }

  Future<bool> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseURL/users/$id'));
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

  // ─── Avatar ──────────────────────────────────────────────────────────────

  Future<ImageProvider?> getAvatar(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/users/profile_photo/$id'),
      );
      if (response.statusCode == 200) {
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

  /// Upload profile photo as multipart/form-data (web-compatible, no dart:io).
  Future<bool> updateProfilePhoto(
    int id,
    Uint8List bytes,
    String filename,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseURL/users/profile_photo/$id'),
      );
      request.files.add(
        http.MultipartFile.fromBytes('photo', bytes, filename: filename),
      );
      final streamed = await request.send();
      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        return true;
      } else {
        print('Server Error: ${streamed.statusCode}');
        return false;
      }
    } catch (e) {
      print('Network Error: $e');
      return false;
    }
  }
}
