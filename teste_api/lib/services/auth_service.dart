import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teste_api/models/task.dart';

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

  Future<List<Task>> getTasks() async {
    final url = Uri.parse('http://localhost:9191/tasks');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );
    print('DELETE status: ${response.statusCode}');
    print('DELETE body: ${response.body}');
    if (response.statusCode == 200) {
      final List tasks = jsonDecode(response.body);
      return tasks.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar tarefas");
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final url = Uri.parse('http://localhost:9191/tasks/$taskId/toggle');
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );
    print('DELETE status: ${response.statusCode}');
    print('DELETE body: ${response.body}');
    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception("Erro ao alterar status da tarefa");
    }
  }

  Future<void> deleteTask(String taskId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:9191/tasks/$taskId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token', // <- aqui foi o problema
      },
    );

    print('DELETE status: ${response.statusCode}');
    print('DELETE body: ${response.body}');

    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception("Erro ao excluir tarefa");
    }
  }
}
