class Restaurante {
  int _idRestaurante;
  String _nomeRestaurante;
  String _latitude;
  String _longitude;
  String _tipoCulinaria;
 
  Restaurante(this._idRestaurante, this._nomeRestaurante, this._latitude,
      this._longitude, this._tipoCulinaria);
 
  int get idRestaurante => _idRestaurante;
  String get nomeRestaurante => _nomeRestaurante;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get tipoCulinaria => _tipoCulinaria;
 
  set nomeRestaurante(String nome) => _nomeRestaurante = nome;
  set latitude(String lat) => _latitude = lat;
  set longitude(String lon) => _longitude = lon;
  set tipoCulinaria(String tipo) => _tipoCulinaria = tipo;
 
  // Converte uma linha vinda do banco de dados (Map) em um objeto Restaurante.
  factory Restaurante.fromMap(Map<String, dynamic> map) {
    return Restaurante(
      map['res_id_restaurante'] as int,
      map['res_nm_restaurante'] as String,
      (map['res_nu_latitude'] ?? '').toString(),
      (map['res_nu_longitude'] ?? '').toString(),
      map['res_ds_tipo_culinaria'] as String,
    );
  }
 
  // Converte o objeto Restaurante em um Map para inserir/atualizar no banco.
  Map<String, dynamic> toMap() {
    return {
      'res_nm_restaurante': _nomeRestaurante,
      'res_nu_latitude': _latitude,
      'res_nu_longitude': _longitude,
      'res_ds_tipo_culinaria': _tipoCulinaria,
    };
  }
 
  void exibirCategoriaCulinaria() {
    switch (_tipoCulinaria.toLowerCase()) {
      case 'japonesa':
        print('Categoria: Culinária Asiática - Foco em peixes e arroz');
        break;
      case 'italiana':
        print('Categoria: Massas e Pizzas artesanais.');
        break;
      case 'brasileira':
        print('Categoria: Churrasco, feijoada e pratos típicos.');
        break;
      default:
        print('Categoria: Culinária Internacional ou Diversa.');
    }
  }
}