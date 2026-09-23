import 'package:flutter/material.dart';
 
import '../../database/database_helper.dart';
import 'home_screen.dart';
import '../components/botao_customizado.dart';
 
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
 
  void _fazerLogin() async {
    String email = _emailController.text;
    String senha = _senhaController.text;
 
    var usuario =
        await DatabaseHelper.instancia.autenticarUsuario(email, senha);
 
    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha inválidos!')),
      );
    }
  }
 
  InputDecoration _decoracaoCampo(String label, IconData icone) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF10251B)),
      prefixIcon: Icon(icone, color: const Color(0xFF10251B)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10251B),
 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu, size: 56, color: Color(0xFFD4AF37)),
 
              const SizedBox(height: 16),
 
              const Text(
                'Bem-vindo!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
 
              const SizedBox(height: 8),
 
              Text(
                'Entre para continuar',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
 
              const SizedBox(height: 30),
 
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Color(0xFF10251B)),
                decoration: _decoracaoCampo('E-mail', Icons.email_outlined),
              ),
 
              const SizedBox(height: 20),
 
              TextField(
                controller: _senhaController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF10251B)),
                decoration: _decoracaoCampo('Senha', Icons.lock_outline),
              ),
 
              const SizedBox(height: 24),
 
              BotaoCustomizado(
                texto: 'Entrar',
                onPressed: _fazerLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}