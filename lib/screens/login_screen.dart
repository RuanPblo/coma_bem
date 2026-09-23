import 'package:flutter/material.dart';

import '../../database/database_helper.dart';
import 'main_navigation_screen.dart';
import 'cadastro_usuario_screen.dart';
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
        MaterialPageRoute(
          builder: (context) => MainNavigationScreen(emailUsuario: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail ou senha inválidos!')),
      );
    }
  }

  void _irParaCriarConta() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroUsuarioScreen()),
    );
  }

  InputDecoration _decoracaoCampo(String label, IconData icone) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF10251B)),
      prefixIcon: Icon(icone, color: const Color(0xFF10251B)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10251B),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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

                const SizedBox(height: 32),

                // Cartão branco flutuante com o formulário, para dar
                // profundidade e um visual mais moderno.
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Color(0xFF10251B)),
                        decoration: _decoracaoCampo('E-mail', Icons.email_outlined),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: _senhaController,
                        obscureText: true,
                        style: const TextStyle(color: Color(0xFF10251B)),
                        decoration: _decoracaoCampo('Senha', Icons.lock_outline),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: BotaoCustomizado(
                          texto: 'Entrar',
                          onPressed: _fazerLogin,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: _irParaCriarConta,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.white.withOpacity(0.85)),
                      children: const [
                        TextSpan(text: 'Não tem conta? '),
                        TextSpan(
                          text: 'Cadastre-se',
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}