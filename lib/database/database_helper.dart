import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instancia = DatabaseHelper._interno();
  static Database? _bancoDeDados;

  factory DatabaseHelper() => _instancia;

  DatabaseHelper._interno();

  Future<Database> get bancoDeDados async {
    if(_bancoDeDados != null) return _bancoDeDados!;
    _bancoDeDados = await _iniciarBanco();
    return _bancoDeDados!;
  }

  Future<Database> _iniciarBanco() async {
    String caminhoBanco = await getDatabasesPath();
    String caminhoCompleto = join(caminhoBanco, 'coma_bem.db');
    return await openDatabase(caminhoCompleto, version: 1, onCreate: _criarTabelas);
  }

  Future<void> _criarTabelas(Database db, int versao) async{
    await db.execute('''
      CREATE TABLE usuario (
      usu_id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
      usu_tx_email TEXT NOT NULL UNIQUE,
      usu_tx_senha TEXT NOT NULL
      )
      ''');
  }



  Future<Map<String, dynamic>?> autenticarUsuario(String email, String senha) async{
    Database db = await bancoDeDados;
    List<Map<String, dynamic>> resultado = await db.query(
      'usuario',
      where: 'usu_tx_email = ? AND usu_tx_senha = ?',
      whereArgs: [email, senha],
    );
    if(resultado.isNotEmpty) return resultado.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> consultarDados(String tabela) async{
    Database db = await bancoDeDados;
    return await db.query(tabela);
  }

  Future<int> alterarDados(String tabela, Map<String, dynamic> novosDados, String colunaId, int id) async{
    Database db = await bancoDeDados;
    return await db.update(
      tabela,
      novosDados,
      where: '$colunaId = ? ',
      whereArgs: [id],
    );
  }

  Future<int> deletarDados(String tabela, String colunaId, int id) async {
    Database db = await bancoDeDados;
    return await db.delete(
      tabela,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

 Future<void> inserirRestaurante(Map<String, dynamic> dadosRestaurante) async {
  try {
    Database db = await bancoDeDados;
    int idGerado = await db.insert('restaurante', dadosRestaurante);
    print('Sucesso: Restaurante cadastrado com ID $idGerado.');
  } catch (erro){
    print('Erro ao tentar cadastrar o restaurante: \$erro');
  }
 }

Future<List<Map<String, dynamic>>> listarRestaurantesPorTipo(String tipo) async {
  try{
    Database db = await bancoDeDados;
    List<Map<String, dynamic>> lista = await db.query(
      'restaurante',
      where: 'res_ds_tipo_culinaria = ?',
      whereArgs: [tipo],
    );
    print('Sucesso: Foram encontrados \${lista.length} restaurantes.');
    return lista;
  } catch (erro){
    print('Erro ao buscar restaurantes do tipo \$tipo: \$erro');
    return [];
  }
}

Future<void> atualizarAvaliacao(int idAvaliacao, int novaNota, String novoTexto) async {
  try {
    Database db = await bancoDeDados;

    int linhasAfetadas = await db.update(
      'avaliacao',
      {'avl_nu_ranking': novaNota, 'avl_tx_recomendacao': novoTexto},
      where: 'avl_id_avaliacao = ?',
      whereArgs: [idAvaliacao],
    );

    if(linhasAfetadas > 0){
      print('Sucesso: Avalição atualizada.');
    } else{
      print('Aviso: Nenhuma avaliação encontrada com o ID $idAvaliacao');
    }
  } catch (erro){
    print('Erro ao atualizar a avaliação: \$erro');
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
    if(linhasAfetadas > 0){
      print('Sucesso: Prato deletado do cardápio.');
    } else {
      print('Aviso: Nenhum prato encontrado com o ID $idPrato.');
    }
  } catch (erro){
    print('Erro ao tentar remover o prato: \$erro');
  }
}

Future<List<Map<String, dynamic>>> buscarRestaurantePorNome(String termoBusca) async {
  try {
    Database db = await bancoDeDados;

    List<Map<String, dynamic>> lista = await db.query(
      'restaurante',
      where: 'res_nm_restaurante LIKE ?',
      whereArgs: ['%$termoBusca%'],
    );
    print('Sucesso: Foram encontrados ${lista.length} restaurantes contendo "$termoBusca".');
    return lista;
  } catch (erro){
    print('Erro ao buscar restaurante por nome: $erro');
    return [];
  }
}

Future<List<Map<String, dynamic>>> listarPratosPorRestaurante(int idRestaurante) async{
  try{
    Database db = await bancoDeDados;
    List<Map<String, dynamic>> cardapio = await db.query(
      'prato',
      where: 'pra_id_restaurante = ?',
      whereArgs: [idRestaurante],
    );
    print('Sucesso: ${cardapio.length} pratos carregados para o restaurante ID $idRestaurante.');
    return cardapio;
  } catch (erro) {
    print('Erro ao carregar o cardápio: $erro');
    return [];
  }
}
}