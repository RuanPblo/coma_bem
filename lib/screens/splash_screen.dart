import 'dart:async';
import 'package:flutter/material.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
 
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navegarParaLogin();
  }
 
  Future<void> _navegarParaLogin() async {
    await Future.delayed(const Duration(seconds: 2));
 
    // Garante que a tela ainda está na árvore de widgets antes de navegar.
    if (!mounted) return;
 
    Navigator.pushReplacementNamed(context, '/login');
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mesmo tom de fundo usado na tela de login, para manter a
      // identidade visual do app.
      backgroundColor: const Color(0xFF10251B),
 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 90,
              color: const Color(0xFFD4AF37),
            ),
 
            const SizedBox(height: 20),
 
            const Text(
              'Coma Bem',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
 
            const SizedBox(height: 8),
 
            Text(
              'Encontre os melhores restaurantes perto de você',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFD4AF37),
              ),
            ),
 
            const SizedBox(height: 40),
 
            const CircularProgressIndicator(
              color: Color(0xFFD4AF37),
            ),
          ],
        ),
      ),
    );
  }
}