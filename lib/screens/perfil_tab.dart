import 'package:flutter/material.dart';

class PerfilTab extends StatelessWidget {
  final String? emailUsuario;

  const PerfilTab({super.key, this.emailUsuario});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF10251B),
              child: Icon(Icons.person, size: 48, color: Color(0xFFD4AF37)),
            ),

            const SizedBox(height: 16),

            Text(
              emailUsuario ?? 'Usuário',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10251B),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (rota) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Color(0xFF10251B)),
                label: const Text(
                  'Sair',
                  style: TextStyle(color: Color(0xFF10251B), fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF10251B)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}