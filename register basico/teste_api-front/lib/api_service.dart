import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teste_api/task.dart';

class TaskService {
  static const String baseUrl = 'http://192.168.0.8:9191/tasks';

  Future<List<TaskItem>> getTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TaskItem.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar tarefas');
    }
  }

  Future<void> addTask(String title) async {
    await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': false}),
    );
  }

  Future<void> updateTaskStatus(int id) async {
    await http.put(Uri.parse('$baseUrl/update/$id'));
  }

  Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('$baseUrl/delete/$id'));
  }
}
