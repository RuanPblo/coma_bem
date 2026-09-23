import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instancia = DatabaseHelper._interno();
  static Database? _bancoDeDados;

  factory DatabaseHelper() => instancia;

  DatabaseHelper._interno();

  Future<Database> get bancoDeDados async {
    if (_bancoDeDados != null) return _bancoDeDados!;
    _bancoDeDados = await _iniciarBanco();
    return _bancoDeDados!;
  }

  Future<Database> _iniciarBanco() async {
    String caminhoBanco = await getDatabasesPath();
    String caminhoCompleto = join(caminhoBanco, 'coma_bem.db');

    return await openDatabase(
      caminhoCompleto,
      version: 1,
      onCreate: _criarTabelas,
    );
  }

  Future<void> _criarTabelas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuario (
        usu_id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        usu_tx_email TEXT NOT NULL UNIQUE,
        usu_tx_senha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE restaurante (
        res_id_restaurante INTEGER PRIMARY KEY AUTOINCREMENT,
        res_nm_restaurante TEXT NOT NULL,
        res_nu_latitude TEXT,
        res_nu_longitude TEXT,
        res_ds_tipo_culinaria TEXT NOT NULL
      )
    ''');

    // Tabelas que faltavam: sem elas, cadastrar um prato ou uma nota
    // nunca tinha onde ser gravado de verdade.
    await db.execute('''
      CREATE TABLE prato (
        pra_id_prato INTEGER PRIMARY KEY AUTOINCREMENT,
        pra_id_restaurante INTEGER NOT NULL,
        pra_nm_prato TEXT NOT NULL,
        pra_tx_foto_base64 TEXT,
        FOREIGN KEY (pra_id_restaurante) REFERENCES restaurante (res_id_restaurante)
      )
    ''');

    await db.execute('''
      CREATE TABLE avaliacao (
        avl_id_avaliacao INTEGER PRIMARY KEY AUTOINCREMENT,
        avl_id_prato INTEGER NOT NULL,
        avl_nu_ranking INTEGER NOT NULL,
        avl_tx_recomendacao TEXT,
        FOREIGN KEY (avl_id_prato) REFERENCES prato (pra_id_prato)
      )
    ''');

    await _inserirRestaurantesIniciais(db);
    await _inserirUsuarioTeste(db);
  }

  // Usuário fixo só para conseguir testar o login sem precisar
  // de uma tela de cadastro de usuário ainda.
  Future<void> _inserirUsuarioTeste(Database db) async {
    await db.insert('usuario', {
      'usu_tx_email': 'teste@comabem.com',
      'usu_tx_senha': '123456',
    });
  }

  Future<void> _inserirRestaurantesIniciais(Database db) async {
    final restaurantesIniciais = [
      {
        'res_nm_restaurante': 'Sabor Caseiro',
        'res_nu_latitude': '-23.9931',
        'res_nu_longitude': '-46.4093',
        'res_ds_tipo_culinaria': 'brasileira',
      },
      {
        'res_nm_restaurante': 'Ristorante Bella Napoli',
        'res_nu_latitude': '-23.9878',
        'res_nu_longitude': '-46.4001',
        'res_ds_tipo_culinaria': 'italiana',
      },
      {
        'res_nm_restaurante': 'Sushi Kokoro',
        'res_nu_latitude': '-23.9902',
        'res_nu_longitude': '-46.4050',
        'res_ds_tipo_culinaria': 'japonesa',
      },
      {
        'res_nm_restaurante': 'Empório Vegano',
        'res_nu_latitude': '-23.9860',
        'res_nu_longitude': '-46.4110',
        'res_ds_tipo_culinaria': 'vegetariana',
      },
    ];

    for (final restaurante in restaurantesIniciais) {
      await db.insert('restaurante', restaurante);
    }
  }

  Future<Map<String, dynamic>?> autenticarUsuario(
      String email, String senha) async {
    Database db = await bancoDeDados;

    List<Map<String, dynamic>> resultado = await db.query(
      'usuario',
      where: 'usu_tx_email = ? AND usu_tx_senha = ?',
      whereArgs: [email, senha],
    );

    if (resultado.isNotEmpty) return resultado.first;

    return null;
  }

  Future<int> inserirDados(String tabela, Map<String, dynamic> dados) async {
    Database db = await bancoDeDados;
    return await db.insert(tabela, dados);
  }

  Future<List<Map<String, dynamic>>> consultarDados(String tabela) async {
    Database db = await bancoDeDados;
    return await db.query(tabela);
  }

  Future<int> alterarDados(
    String tabela,
    Map<String, dynamic> novosDados,
    String colunaId,
    int id,
  ) async {
    Database db = await bancoDeDados;

    return await db.update(
      tabela,
      novosDados,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarDados(
    String tabela,
    String colunaId,
    int id,
  ) async {
    Database db = await bancoDeDados;

    return await db.delete(
      tabela,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

  Future<void> inserirRestaurante(
      Map<String, dynamic> dadosRestaurante) async {
    try {
      Database db = await bancoDeDados;
      int idGerado = await db.insert('restaurante', dadosRestaurante);
      print('Sucesso: Restaurante cadastrado com o ID $idGerado.');
    } catch (erro) {
      print('Erro ao tentar cadastrar o restaurante: $erro');
    }
  }

  Future<List<Map<String, dynamic>>> listarTodosRestaurantes() async {
    return await consultarDados('restaurante');
  }

  Future<List<Map<String, dynamic>>> listarRestaurantesPortipo(
      String tipo) async {
    try {
      Database db = await bancoDeDados;

      List<Map<String, dynamic>> lista = await db.query(
        'restaurante',
        where: 'res_ds_tipo_culinaria = ?',
        whereArgs: [tipo],
      );
      print('Sucesso: Foram encontrados ${lista.length} restaurantes.');
      return lista;
    } catch (erro) {
      print('Erro ao buscar restaurantes do tipo $tipo: $erro');
      return [];
    }
  }

  Future<void> atualizarAvaliacao(
      int idAvaliacao, int novaNota, String novoTexto) async {
    try {
      Database db = await bancoDeDados;

      int linhasAfetadas = await db.update(
        'avaliacao',
        {'avl_nu_ranking': novaNota, 'avl_tx_recomendacao': novoTexto},
        where: 'avl_id_avaliacao = ?',
        whereArgs: [idAvaliacao],
      );

      if (linhasAfetadas > 0) {
        print('Sucesso: Avaliação atualizada.');
      } else {
        print('Aviso: Nenhuma avaliação encontrada com o ID $idAvaliacao.');
      }
    } catch (erro) {
      print('Erro ao atualizar: $erro');
    }
  }

  Future<void> removerPrato(int idPrato) async {
    try {
      Database db = await bancoDeDados;

      int linhasAfetadas = await db.delete(
        'prato',
        where: 'pra_id_prato = ?',
        whereArgs: [idPrato],
      );

      if (linhasAfetadas > 0) {
        print('Sucesso: Prato deletado do cardápio.');
      } else {
        print('Aviso: Nenhum prato encontrado com o ID $idPrato');
      }
    } catch (erro) {
      print('Erro ao tentar remover o prato: $erro');
    }
  }

  Future<List<Map<String, dynamic>>> buscarRestaurantePorNome(
      String termoBusca) async {
    try {
      Database db = await bancoDeDados;

      List<Map<String, dynamic>> lista = await db.query(
        'restaurante',
        where: 'res_nm_restaurante LIKE ?',
        whereArgs: ['%$termoBusca%'],
      );
      print(
          'Sucesso: Foram encontrados ${lista.length} restaurantes contendo "$termoBusca".');
      return lista;
    } catch (erro) {
      print('Erro ao buscar retaurante por nome: $erro');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> listarPratosPorRestaurante(
      int idRestaurante) async {
    try {
      Database db = await bancoDeDados;
      List<Map<String, dynamic>> cardapio = await db.query(
        'prato',
        where: 'pra_id_restaurante = ?',
        whereArgs: [idRestaurante],
      );
      print(
          'Sucesso: ${cardapio.length} pratos carregados para o restaurante ID $idRestaurante.');
      return cardapio;
    } catch (erro) {
      print('Erro ao carregar o cardápio: $erro');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> listarAvaliacoesPorPrato(
      int idPrato) async {
    try {
      Database db = await bancoDeDados;
      List<Map<String, dynamic>> avaliacoes = await db.query(
        'avaliacao',
        where: 'avl_id_prato = ?',
        whereArgs: [idPrato],
      );
      return avaliacoes;
    } catch (erro) {
      print('Erro ao carregar avaliações do prato $idPrato: $erro');
      return [];
    }
  }

  // Média de todas as avaliações de todos os pratos de um restaurante,
  // usada para mostrar as estrelas direto no catálogo.
  Future<double?> calcularMediaAvaliacoesRestaurante(int idRestaurante) async {
    try {
      final pratos = await listarPratosPorRestaurante(idRestaurante);
      if (pratos.isEmpty) return null;

      final notas = <int>[];
      for (final prato in pratos) {
        final idPrato = prato['pra_id_prato'] as int;
        final avaliacoes = await listarAvaliacoesPorPrato(idPrato);
        for (final avaliacao in avaliacoes) {
          notas.add(avaliacao['avl_nu_ranking'] as int);
        }
      }

      if (notas.isEmpty) return null;
      return notas.reduce((a, b) => a + b) / notas.length;
    } catch (erro) {
      print('Erro ao calcular média do restaurante $idRestaurante: $erro');
      return null;
    }
  }
}