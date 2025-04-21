import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final String loginUrl =
      'https://97a9-187-255-42-37.ngrok-free.app/auth/login';

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailCtrl.text, 'password': passCtrl.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['name'];
        final token = data['token'];

        print('✅ Login bem-sucedido!');
        print('Nome: $name');
        print('Token: $token');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Aqui você pode redirecionar se quiser:
        // Navigator.pushReplacement(...);
      } else {
        print('❌ Erro no login: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha no login. Verifique seus dados.'),
          ),
        );
      }
    } catch (e) {
      print('Erro ao tentar login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Entrar')),
          ],
        ),
      ),
    );
  }
}
