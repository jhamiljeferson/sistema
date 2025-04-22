import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      home: TaskListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskItem {
  final int id;
  final String title;
  final bool done;

  TaskItem({required this.id, required this.title, required this.done});

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(id: json['id'], title: json['title'], done: json['done']);
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<TaskItem> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  final String apiUrl = 'http://192.168.0.8:9191/tasks';

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> taskList = json.decode(response.body);
      setState(() {
        _tasks = taskList.map((e) => TaskItem.fromJson(e)).toList();
      });
    }
  }

  Future<void> _addTask(String title) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': false}),
    );
    if (response.statusCode == 200) {
      _controller.clear();
      _fetchTasks();
    }
  }

  Future<void> _toggleDone(int id) async {
    final response = await http.put(Uri.parse('$apiUrl/update/$id'));
    if (response.statusCode == 200) {
      _fetchTasks();
    }
  }

  Future<void> _deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
    if (response.statusCode == 200) {
      _fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Nova Tarefa'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTask(_controller.text),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration:
                            task.done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: task.done,
                      onChanged: (_) => _toggleDone(task.id),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(task.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
