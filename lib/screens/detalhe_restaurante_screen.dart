import 'dart:convert';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/restaurante.dart';
import '../components/estrelas_avaliacao.dart';

class DetalheRestauranteScreen extends StatefulWidget {
  final Restaurante restaurante;

  const DetalheRestauranteScreen({super.key, required this.restaurante});

  @override
  State<DetalheRestauranteScreen> createState() =>
      _DetalheRestauranteScreenState();
}

class _PratoComAvaliacao {
  final Map<String, dynamic> prato;
  final double? mediaNota;
  final int totalAvaliacoes;

  _PratoComAvaliacao({
    required this.prato,
    required this.mediaNota,
    required this.totalAvaliacoes,
  });
}

class _DetalheRestauranteScreenState extends State<DetalheRestauranteScreen> {
  List<_PratoComAvaliacao> _pratos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarCardapio();
  }

  Future<void> _carregarCardapio() async {
    setState(() => _carregando = true);

    final pratos = await DatabaseHelper.instancia
        .listarPratosPorRestaurante(widget.restaurante.idRestaurante);

    final List<_PratoComAvaliacao> pratosComAvaliacao = [];

    for (final prato in pratos) {
      final idPrato = prato['pra_id_prato'] as int;
      final avaliacoes =
          await DatabaseHelper.instancia.listarAvaliacoesPorPrato(idPrato);

      double? media;
      if (avaliacoes.isNotEmpty) {
        final soma = avaliacoes.fold<int>(
          0,
          (total, avaliacao) => total + (avaliacao['avl_nu_ranking'] as int),
        );
        media = soma / avaliacoes.length;
      }

      pratosComAvaliacao.add(
        _PratoComAvaliacao(
          prato: prato,
          mediaNota: media,
          totalAvaliacoes: avaliacoes.length,
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      _pratos = pratosComAvaliacao;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10251B),
        title: Text(
          widget.restaurante.nomeRestaurante,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF10251B)))
          : _pratos.isEmpty
              ? const Center(
                  child: Text('Nenhum prato cadastrado para esse restaurante ainda.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pratos.length,
                  itemBuilder: (context, index) {
                    final item = _pratos[index];
                    final nomePrato = item.prato['pra_nm_prato'] as String;
                    final fotoBase64 =
                        item.prato['pra_tx_foto_base64'] as String?;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: const Color(0xFFD4AF37).withOpacity(0.25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (fotoBase64 != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  base64Decode(fotoBase64),
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10251B),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.restaurant,
                                    color: Color(0xFFD4AF37)),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nomePrato,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF10251B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  EstrelasAvaliacao(media: item.mediaNota),
                                  if (item.totalAvaliacoes > 0)
                                    Text(
                                      '${item.totalAvaliacoes} avaliação(ões)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}