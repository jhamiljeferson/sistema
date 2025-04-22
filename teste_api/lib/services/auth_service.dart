import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class AuthService with ChangeNotifier {
  String? _token;
  List<Task> _tasks = [];

  String? get token => _token;
  List<Task> get tasks => _tasks;

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _tasks = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:9191/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      await saveToken(_token!);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> fetchTasks() async {
    if (_token == null) return;
    final uri = Uri.parse('http://localhost:9191/tasks');
    final headers = {'Authorization': 'Bearer $_token'};
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> taskList = jsonDecode(response.body);
      _tasks = taskList.map((task) => Task.fromJson(task)).toList();
      notifyListeners();
    }
  }

  /*
  Future<void> fetchTasks() async {
    if (_token == null) return;
    final response = await http.get(
      Uri.parse('http://localhost:9191/tasks'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> taskList = jsonDecode(response.body);
      _tasks = taskList.map((task) => Task.fromJson(task)).toList();
      notifyListeners();
    }
  }
*/
  Future<void> addTask(String title) async {
    if (_token == null) return;
    final response = await http.post(
      Uri.parse('http://localhost:9191/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'title': title}),
    );
    print('-----------post $response');
    print('-----------post Response Body: ${response.body}');
    print('-----------post Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final task = Task.fromJson(jsonDecode(response.body));
      _tasks.add(task);
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    if (_token == null) return;
    final response = await http.delete(
      Uri.parse('http://localhost:9191/tasks/$id'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    print('-----------delete Response Body: ${response.statusCode}');

    if (response.statusCode == 200) {
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
      print('-----------delete Response 200: ${response.body}');
    }
  }

  Future<void> toggleTaskCompletion(int id) async {
    if (_token == null) return;
    final task = _tasks.firstWhere((task) => task.id == id);
    final response = await http.put(
      Uri.parse('http://localhost:9191/tasks/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'done': !task.completed}),
    );

    if (response.statusCode == 200) {
      task.completed = !task.completed;
      notifyListeners();
    }
  }
}
