import 'package:flutter/material.dart';
import 'package:teste_api/LoginPage.dart'; // Certifique-se de que esse arquivo existe

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Aqui ele começa pela tela de login
    );
  }
}
