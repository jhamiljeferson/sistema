import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_api/screens/task_screen.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService()..loadToken(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Tarefas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          return auth.token == null ? LoginScreen() : TasksScreen();
        },
      ),
    );
  }
}
