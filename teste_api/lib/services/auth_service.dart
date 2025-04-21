import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://localhost:9191/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> getTasks() async {
    final url = Uri.parse('http://localhost:9191/tasks');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final List tasks = jsonDecode(response.body);
      return tasks.map((e) => e.toString()).toList();
    } else {
      throw Exception("Erro ao carregar tarefas");
    }
  }
}
