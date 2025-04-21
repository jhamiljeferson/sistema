import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

          final tasks = snapshot.data as List<String>;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder:
                (context, index) => ListTile(title: Text(tasks[index])),
          );
        },
      ),
    );
  }
}
