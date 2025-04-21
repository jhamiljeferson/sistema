import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const baseUrl = "http://localhost:8080/auth";

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", json["token"]);
      await prefs.setString("name", json["name"]);
      return true;
    }
    return false;
  }

  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    return response.statusCode == 200;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("name");
  }
}
