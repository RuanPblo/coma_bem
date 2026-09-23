import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/restaurante.dart';
import '../components/estrelas_avaliacao.dart';
import '../services/favoritos_service.dart';
import 'detalhe_restaurante_screen.dart';

// Antes era a HomeScreen (com Scaffold/AppBar próprios). Agora é só o
// conteúdo da aba "Catálogo", que fica dentro do MainNavigationScreen.
class CatalogoTab extends StatefulWidget {
  const CatalogoTab({super.key});

  @override
  State<CatalogoTab> createState() => _CatalogoTabState();
}

class _CatalogoTabState extends State<CatalogoTab> {
  final TextEditingController _buscaController = TextEditingController();

  List<Restaurante> _todosOsRestaurantes = [];
  List<Restaurante> _restaurantesFiltrados = [];
  Map<int, double?> _mediasPorRestaurante = {};
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    carregarRestaurantes();
  }

  Future<void> carregarRestaurantes() async {
    setState(() => _carregando = true);

    final linhas = await DatabaseHelper.instancia.listarTodosRestaurantes();
    final restaurantes = linhas.map((linha) => Restaurante.fromMap(linha)).toList();

    final medias = <int, double?>{};
    for (final restaurante in restaurantes) {
      medias[restaurante.idRestaurante] = await DatabaseHelper.instancia
          .calcularMediaAvaliacoesRestaurante(restaurante.idRestaurante);
    }

    if (!mounted) return;

    setState(() {
      _todosOsRestaurantes = restaurantes;
      _restaurantesFiltrados = restaurantes;
      _mediasPorRestaurante = medias;
      _carregando = false;
    });
  }

  void _filtrarRestaurantes(String termo) {
    final termoBusca = termo.trim().toLowerCase();

    setState(() {
      if (termoBusca.isEmpty) {
        _restaurantesFiltrados = _todosOsRestaurantes;
      } else {
        _restaurantesFiltrados = _todosOsRestaurantes.where((restaurante) {
          return restaurante.nomeRestaurante.toLowerCase().contains(termoBusca) ||
              restaurante.tipoCulinaria.toLowerCase().contains(termoBusca);
        }).toList();
      }
    });
  }

  IconData _iconePorTipoCulinaria(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'japonesa':
        return Icons.set_meal;
      case 'italiana':
        return Icons.local_pizza;
      case 'brasileira':
        return Icons.rice_bowl;
      case 'vegetariana':
        return Icons.eco;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _buscaController,
            onChanged: _filtrarRestaurantes,
            decoration: InputDecoration(
              hintText: 'Buscar restaurante ou culinária...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF10251B)),
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
            ),
          ),
        ),

        Expanded(
          child: _carregando
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF10251B)))
              : _restaurantesFiltrados.isEmpty
                  ? const Center(child: Text('Nenhum restaurante encontrado.'))
                  : RefreshIndicator(
                      color: const Color(0xFF10251B),
                      onRefresh: carregarRestaurantes,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                        itemCount: _restaurantesFiltrados.length,
                        itemBuilder: (context, index) {
                          final restaurante = _restaurantesFiltrados[index];
                          final media = _mediasPorRestaurante[restaurante.idRestaurante];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.25)),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalheRestauranteScreen(
                                      restaurante: restaurante,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: const Color(0xFF10251B),
                                      child: Icon(
                                        _iconePorTipoCulinaria(restaurante.tipoCulinaria),
                                        color: const Color(0xFFD4AF37),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            restaurante.nomeRestaurante,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Color(0xFF10251B),
                                            ),
                                          ),
                                          Text(
                                            restaurante.tipoCulinaria[0].toUpperCase() +
                                                restaurante.tipoCulinaria.substring(1),
                                            style: const TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(height: 6),
                                          EstrelasAvaliacao(media: media, tamanho: 16),
                                        ],
                                      ),
                                    ),
                                    ValueListenableBuilder<Set<int>>(
                                      valueListenable: FavoritosService.instancia.favoritos,
                                      builder: (context, favoritosIds, _) {
                                        final ehFavorito =
                                            favoritosIds.contains(restaurante.idRestaurante);
                                        return IconButton(
                                          icon: Icon(
                                            ehFavorito ? Icons.favorite : Icons.favorite_border,
                                            color: ehFavorito
                                                ? Colors.redAccent
                                                : Colors.grey,
                                          ),
                                          onPressed: () => FavoritosService.instancia
                                              .alternar(restaurante.idRestaurante),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }
}