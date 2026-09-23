import 'package:flutter/material.dart';
 
import '../database/database_helper.dart';
 
class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});
 
  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}
 
class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
 
  bool _salvando = false;
 
  Future<void> _criarConta() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;
    final confirmarSenha = _confirmarSenhaController.text;
 
    if (email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty) {
      _mostrarErro('Preencha todos os campos.');
      return;
    }
 
    if (senha.length < 6) {
      _mostrarErro('A senha deve ter pelo menos 6 caracteres.');
      return;
    }
 
    if (senha != confirmarSenha) {
      _mostrarErro('As senhas não coincidem.');
      return;
    }
 
    setState(() => _salvando = true);
 
    try {
      await DatabaseHelper.instancia.inserirDados('usuario', {
        'usu_tx_email': email,
        'usu_tx_senha': senha,
      });
 
      if (!mounted) return;
 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada! Agora é só entrar.'),
          backgroundColor: Colors.green,
        ),
      );
 
      Navigator.pop(context);
    } catch (erro) {
      // A coluna usu_tx_email é UNIQUE: se o e-mail já existir, o
      // sqflite lança um erro de constraint aqui.
      final mensagemErro = erro.toString().toLowerCase().contains('unique')
          ? 'Esse e-mail já está cadastrado.'
          : 'Não foi possível criar a conta. Tente novamente.';
 
      _mostrarErro(mensagemErro);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }
 
  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF10251B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add_alt_1,
                  size: 48, color: Color(0xFFD4AF37)),
 
              const SizedBox(height: 16),
 
              const Text(
                'Criar conta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
 
              const SizedBox(height: 6),
 
              Text(
                'Leva menos de um minuto',
                style: TextStyle(color: Colors.white.withOpacity(0.85)),
              ),
 
              const SizedBox(height: 28),
 
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Color(0xFF10251B)),
                decoration: _decoracaoCampo('E-mail', Icons.email_outlined),
              ),
 
              const SizedBox(height: 16),
 
              TextField(
                controller: _senhaController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF10251B)),
                decoration: _decoracaoCampo('Senha (mín. 6 caracteres)', Icons.lock_outline),
              ),
 
              const SizedBox(height: 16),
 
              TextField(
                controller: _confirmarSenhaController,
                obscureText: true,
                style: const TextStyle(color: Color(0xFF10251B)),
                decoration: _decoracaoCampo('Confirmar senha', Icons.lock_outline),
              ),
 
              const SizedBox(height: 28),
 
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _salvando ? null : _criarConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF10251B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _salvando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Color(0xFF10251B),
                          ),
                        )
                      : const Text(
                          'Criar conta',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 