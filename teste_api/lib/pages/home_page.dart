import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? "Usuário";
  }

  void logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserName(),
      builder: (context, snapshot) {
        final name = snapshot.data ?? '';
        return Scaffold(
          appBar: AppBar(
            title: Text('Bem-vindo, $name'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => logout(context),
              ),
            ],
          ),
          body: const Center(child: Text("Login bem-sucedido")),
        );
      },
    );
  }
}
