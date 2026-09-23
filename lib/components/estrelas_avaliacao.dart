import 'package:flutter/material.dart';

class EstrelasAvaliacao extends StatelessWidget {
  final double? media;
  final double tamanho;
  final bool mostrarValorNumerico;

  const EstrelasAvaliacao({
    super.key,
    required this.media,
    this.tamanho = 16,
    this.mostrarValorNumerico = true,
  });

  @override
  Widget build(BuildContext context) {
    if (media == null) {
      return Text(
        'Sem avaliação',
        style: TextStyle(
          color: Colors.grey,
          fontSize: tamanho * 0.75,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    final estrelasCheias = media!.round().clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < estrelasCheias ? Icons.star : Icons.star_border,
            color: const Color(0xFFD4AF37),
            size: tamanho,
          );
        }),
        if (mostrarValorNumerico) ...[
          const SizedBox(width: 4),
          Text(
            media!.toStringAsFixed(1),
            style: TextStyle(fontSize: tamanho * 0.8, color: Colors.black87),
          ),
        ],
      ],
    );
  }
}