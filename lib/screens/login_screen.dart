import 'package:flutter/material.dart';

// Importa a classe DatabaseHelper construída na Atividade 6.
// Ela contém a lógica de conexão com o banco de dados SQLite.
import '../../database/database_helper.dart';

// Importa a tela principal para onde o usuário irá após o login.
import 'home_screen.dart';

// Importa o botão customizado.
import '../components/botao_customizado.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores dos campos de E-mail e Senha.
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _senhaController =
      TextEditingController();

  // Função responsável por realizar o login.
  void _fazerLogin() async {
    // Pega o texto digitado pelo usuário.
    String email = _emailController.text;
    String senha = _senhaController.text;

    // Consulta o banco de dados para verificar o usuário.
    var usuario = await DatabaseHelper.instancia
        .autenticarUsuario(email, senha);

    // Se encontrou o usuário, o login foi realizado.
    if (usuario != null) {
      // Vai para a tela principal.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      // Se o usuário não existir ou a senha estiver errada,
      // mostra uma mensagem na parte inferior da tela.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'E-mail ou senha inválidos!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo bege claro, combinando com o protótipo do Figma.
      backgroundColor: const Color(0xFFF5EEE2),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          // Centraliza o formulário verticalmente.
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Logo do aplicativo.
           

            const SizedBox(height: 20),

            // Título.
            Text(
              'Bem-vindo!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10251B),
              ),
            ),

            const SizedBox(height: 10),

            // Subtítulo.
            Text(
              'Entre para continuar',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // CAMPO DE E-MAIL
            // =========================

            TextField(
              controller: _emailController,

              decoration: InputDecoration(
                labelText: 'E-mail',

                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xFF10251B),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // CAMPO DE SENHA
            // =========================

            TextField(
              controller: _senhaController,

              // Esconde a senha usando pontos.
              obscureText: true,

              decoration: InputDecoration(
                labelText: 'Senha',

                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF10251B),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // BOTÃO ENTRAR
            // =========================

            BotaoCustomizado(
              texto: 'Entrar',
              onPressed: _fazerLogin,
            ),
          ],
        ),
      ),
    );
  }
}