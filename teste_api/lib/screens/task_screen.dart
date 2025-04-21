import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_api/models/task.dart';
import '../services/auth_service.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Tarefas")),
      body: FutureBuilder(
        future: auth.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const CircularProgressIndicator();
          if (snapshot.hasError) return Text("Erro: ${snapshot.error}");

          final tasks = snapshot.data as List<Task>;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration:
                        task.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                leading: Checkbox(
                  value: task.completed,
                  onChanged: (_) => auth.toggleTaskCompletion(task.id),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => auth.deleteTask(task.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
