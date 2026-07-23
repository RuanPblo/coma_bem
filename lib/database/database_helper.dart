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









}