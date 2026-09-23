import 'package:flutter/material.dart';

import 'catalogo_tab.dart';
import 'favoritos_tab.dart';
import 'perfil_tab.dart';
import 'cadastro_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final String? emailUsuario;

  const MainNavigationScreen({super.key, this.emailUsuario});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _abaSelecionada = 0;

  // Chave para conseguir chamar carregarRestaurantes() na aba de Catálogo
  // depois de voltar da tela de cadastro.
  final GlobalKey<State<CatalogoTab>> _catalogoKey = GlobalKey();

  static const _titulos = ['Catálogo de Restaurantes', 'Favoritos', 'Perfil'];

  List<Widget> get _abas => [
        CatalogoTab(key: _catalogoKey),
        const FavoritosTab(),
        PerfilTab(emailUsuario: widget.emailUsuario),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),

      appBar: AppBar(
        backgroundColor: const Color(0xFF10251B),
        title: Text(
          _titulos[_abaSelecionada],
          style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),

      // IndexedStack mantém o estado de cada aba (a busca não reseta ao trocar de aba).
      body: IndexedStack(
        index: _abaSelecionada,
        children: _abas,
      ),

      floatingActionButton: _abaSelecionada == 0
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: const Color(0xFF10251B),
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CadastroScreen()),
                );
                // Recarrega o catálogo ao voltar, para mostrar o novo restaurante.
                final estadoCatalogo = _catalogoKey.currentState;
                if (estadoCatalogo != null) {
                  (estadoCatalogo as dynamic).carregarRestaurantes();
                }
              },
            )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaSelecionada,
        onDestinationSelected: (indice) => setState(() => _abaSelecionada = indice),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFD4AF37).withOpacity(0.25),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined, color: Color(0xFF10251B)),
            selectedIcon: Icon(Icons.restaurant_menu, color: Color(0xFF10251B)),
            label: 'Catálogo',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border, color: Color(0xFF10251B)),
            selectedIcon: Icon(Icons.favorite, color: Colors.redAccent),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Color(0xFF10251B)),
            selectedIcon: Icon(Icons.person, color: Color(0xFF10251B)),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}