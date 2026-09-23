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
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Foto de fundo do restaurante.
          Image.asset(
            'assets/images/splash_background.jpg',
            fit: BoxFit.cover,
          ),

          // Gradiente escuro por cima da foto, para o texto dourado
          // continuar legível em qualquer parte da imagem.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF10251B).withOpacity(0.75),
                  const Color(0xFF10251B).withOpacity(0.55),
                  const Color(0xFF10251B).withOpacity(0.9),
                ],
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 70,
                    color: Color(0xFFD4AF37),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Coma Bem',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Encontre os melhores restaurantes perto de você',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),

                const SizedBox(height: 40),

                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Color(0xFFD4AF37),
                    strokeWidth: 2.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}