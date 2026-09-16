import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotaoCustomizado({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          // Verde escuro do aplicativo Coma Bem
          backgroundColor: const Color.fromARGB(255, 21, 48, 35),

          // Cor do texto
          foregroundColor: const Color(0xFFD9AD4A),

          // Cantos arredondados
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          // Fonte do botão
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(texto),
      ),
    );
  }
}