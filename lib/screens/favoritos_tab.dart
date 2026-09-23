import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/restaurante.dart';
import '../components/estrelas_avaliacao.dart';
import '../services/favoritos_service.dart';
import 'detalhe_restaurante_screen.dart';

class FavoritosTab extends StatelessWidget {
  const FavoritosTab({super.key});

  Future<List<MapEntry<Restaurante, double?>>> _buscarFavoritos(
      Set<int> idsFavoritos) async {
    final linhas = await DatabaseHelper.instancia.listarTodosRestaurantes();
    final todos = linhas.map((linha) => Restaurante.fromMap(linha)).toList();

    final favoritos =
        todos.where((r) => idsFavoritos.contains(r.idRestaurante)).toList();

    final resultado = <MapEntry<Restaurante, double?>>[];
    for (final restaurante in favoritos) {
      final media = await DatabaseHelper.instancia
          .calcularMediaAvaliacoesRestaurante(restaurante.idRestaurante);
      resultado.add(MapEntry(restaurante, media));
    }

    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      // Sempre que um favorito é marcado/desmarcado, buscamos os
      // restaurantes de novo no banco — assim nunca fica desatualizado,
      // mesmo com um restaurante recém-cadastrado.
      valueListenable: FavoritosService.instancia.favoritos,
      builder: (context, idsFavoritos, _) {
        if (idsFavoritos.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite_border, size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Você ainda não tem favoritos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Toque no coração de um restaurante no catálogo para salvá-lo aqui.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return FutureBuilder<List<MapEntry<Restaurante, double?>>>(
          future: _buscarFavoritos(idsFavoritos),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF10251B)),
              );
            }

            final favoritos = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final restaurante = favoritos[index].key;
                final media = favoritos[index].value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.25)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF10251B),
                      child: Icon(Icons.favorite, color: Colors.redAccent),
                    ),
                    title: Text(
                      restaurante.nomeRestaurante,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10251B)),
                    ),
                    subtitle: EstrelasAvaliacao(media: media, tamanho: 14),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.redAccent),
                      onPressed: () =>
                          FavoritosService.instancia.alternar(restaurante.idRestaurante),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalheRestauranteScreen(restaurante: restaurante),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}