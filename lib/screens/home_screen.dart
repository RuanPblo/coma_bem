import 'package:flutter/material.dart';

// Ajuste estes caminhos se seus arquivos estiverem em pastas diferentes.
import '../database/database_helper.dart';
import '../models/restaurante.dart';
import 'detalhe_restaurante_screen.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _buscaController = TextEditingController();

  List<Restaurante> _todosOsRestaurantes = [];
  List<Restaurante> _restaurantesFiltrados = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarRestaurantes();
  }

  Future<void> _carregarRestaurantes() async {
    setState(() => _carregando = true);

    final linhas = await DatabaseHelper.instancia.listarTodosRestaurantes();
    final restaurantes = linhas.map((linha) => Restaurante.fromMap(linha)).toList();

    setState(() {
      _todosOsRestaurantes = restaurantes;
      _restaurantesFiltrados = restaurantes;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),

      appBar: AppBar(
        backgroundColor: const Color(0xFF10251B),
        title: const Text(
          'Catálogo de Restaurantes',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      body: Column(
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
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
                        onRefresh: _carregarRestaurantes,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _restaurantesFiltrados.length,
                          itemBuilder: (context, index) {
                            final restaurante = _restaurantesFiltrados[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.25)),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF10251B),
                                  child: Icon(
                                    _iconePorTipoCulinaria(restaurante.tipoCulinaria),
                                    color: const Color(0xFFD4AF37),
                                  ),
                                ),
                                title: Text(
                                  restaurante.nomeRestaurante,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF10251B),
                                  ),
                                ),
                                subtitle: Text(
                                  restaurante.tipoCulinaria[0].toUpperCase() +
                                      restaurante.tipoCulinaria.substring(1),
                                ),
                                trailing: const Icon(Icons.chevron_right, color: Color(0xFF10251B)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalheRestauranteScreen(
                                        restaurante: restaurante,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      // Antes só dava pra chegar em /cadastro digitando na barra de
      // endereço. Agora tem um botão de verdade dentro do app.
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: const Color(0xFF10251B),
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroScreen()),
          );
          // Ao voltar do cadastro, recarrega para mostrar o novo restaurante.
          _carregarRestaurantes();
        },
      ),
    );
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }
}