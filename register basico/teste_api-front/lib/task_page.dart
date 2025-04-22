import 'package:flutter/material.dart';
import 'package:teste_api/api_service.dart';
import 'package:teste_api/task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskService _taskService = TaskService();
  final TextEditingController _controller = TextEditingController();
  List<TaskItem> tasks = [];

  void fetchTasks() async {
    final data = await _taskService.getTasks();
    setState(() {
      tasks = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void _addTask() async {
    if (_controller.text.isNotEmpty) {
      await _taskService.addTask(_controller.text);
      _controller.clear();
      fetchTasks();
    }
  }

  void _toggleDone(int id) async {
    await _taskService.updateTaskStatus(id);
    fetchTasks();
  }

  void _deleteTask(int id) async {
    await _taskService.deleteTask(id);
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Nova tarefa'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addTask),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                final task = tasks[i];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.done
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          task.done
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                        onPressed: () => _toggleDone(task.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
