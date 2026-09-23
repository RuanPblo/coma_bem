import 'package:flutter/foundation.dart';

// Guarda os favoritos apenas em memória (some ao fechar o app).
// Dá pra evoluir depois para salvar numa tabela do banco, se precisar.
class FavoritosService {
  FavoritosService._interno();
  static final FavoritosService instancia = FavoritosService._interno();

  final ValueNotifier<Set<int>> favoritos = ValueNotifier<Set<int>>({});

  bool ehFavorito(int idRestaurante) =>
      favoritos.value.contains(idRestaurante);

  void alternar(int idRestaurante) {
    final novoConjunto = Set<int>.from(favoritos.value);

    if (novoConjunto.contains(idRestaurante)) {
      novoConjunto.remove(idRestaurante);
    } else {
      novoConjunto.add(idRestaurante);
    }

    favoritos.value = novoConjunto;
  }
}