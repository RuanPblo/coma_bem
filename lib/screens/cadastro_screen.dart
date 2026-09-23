import 'dart:convert';
import 'dart:typed_data';
 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
 
import '../database/database_helper.dart';
import '../components/campo_formulario_customizado.dart';
import '../components/botao_customizado.dart';
 
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});
 
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}
 
class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _culinariaController = TextEditingController();
  final TextEditingController _pratoController = TextEditingController();
  final TextEditingController _rankingController = TextEditingController();
 
  // Antes era um File (dart:io), que não existe no navegador.
  // Uint8List funciona em qualquer plataforma, incluindo web.
  Uint8List? _fotoPrato;
 
  final String _latitude = '';
  final String _longitude = '';
 
  final ImagePicker _picker = ImagePicker();
 
  Future<void> _tirarFoto() async {
    final XFile? fotoCapturada =
        await _picker.pickImage(source: ImageSource.camera);
 
    if (fotoCapturada != null) {
      // readAsBytes funciona em mobile, desktop E web.
      final bytes = await fotoCapturada.readAsBytes();
 
      setState(() {
        _fotoPrato = bytes;
      });
    }
  }
 
  void _salvarCadastro() async {
    final nomeRestaurante = _nomeController.text.trim();
    final tipoCulinaria = _culinariaController.text.trim();
    final nomePrato = _pratoController.text.trim();
    final rankingTexto = _rankingController.text.trim();
 
    if (nomeRestaurante.isEmpty ||
        tipoCulinaria.isEmpty ||
        nomePrato.isEmpty ||
        rankingTexto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
 
    final int? ranking = int.tryParse(rankingTexto);
 
    if (ranking == null || ranking < 1 || ranking > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O ranking deve ser um número entre 1 e 5.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
 
    try {
      // 1. Cadastra o restaurante e pega o ID gerado.
      final int idRestaurante = await DatabaseHelper.instancia.inserirDados(
        'restaurante',
        {
          'res_nm_restaurante': nomeRestaurante,
          'res_ds_tipo_culinaria': tipoCulinaria,
          'res_nu_latitude': _latitude,
          'res_nu_longitude': _longitude,
        },
      );
 
      // 2. Cadastra o prato vinculado a esse restaurante.
      final int idPrato = await DatabaseHelper.instancia.inserirDados(
        'prato',
        {
          'pra_id_restaurante': idRestaurante,
          'pra_nm_prato': nomePrato,
          'pra_tx_foto_base64':
              _fotoPrato != null ? base64Encode(_fotoPrato!) : null,
        },
      );
 
      // 3. Cadastra a nota/avaliação vinculada a esse prato.
      await DatabaseHelper.instancia.inserirDados(
        'avaliacao',
        {
          'avl_id_prato': idPrato,
          'avl_nu_ranking': ranking,
          'avl_tx_recomendacao': '',
        },
      );
 
      if (!mounted) return;
 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restaurante, prato e nota cadastrados com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
 
      Navigator.pop(context);
    } catch (erro) {
      print('DEBUG Erro ao salvar no SQLite: $erro');
 
      if (!mounted) return;
 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro inesperado ao salvar: $erro'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo Cadastro',
          style: TextStyle(color: Color(0xFFD9AD4A)),
        ),
        backgroundColor: const Color(0xFF10251B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CampoFormularioCustomizado(
              titulo: 'Nome do Restaurante',
              controlador: _nomeController,
            ),
 
            CampoFormularioCustomizado(
              titulo: 'Tipo da Culinária',
              controlador: _culinariaController,
            ),
 
            CampoFormularioCustomizado(
              titulo: 'Nome do Prato',
              controlador: _pratoController,
            ),
 
            CampoFormularioCustomizado(
              titulo: 'Ranking (1 a 5)',
              controlador: _rankingController,
              tipoTeclado: TextInputType.number,
            ),
 
            const SizedBox(height: 20),
 
            // Prévia da foto, se já tiver sido tirada.
            if (_fotoPrato != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _fotoPrato!,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
 
            BotaoCustomizado(
              texto: 'Tirar Foto',
              onPressed: _tirarFoto,
            ),
 
            const SizedBox(height: 10),
 
            BotaoCustomizado(
              texto: 'Salvar',
              onPressed: _salvarCadastro,
            ),
          ],
        ),
      ),
    );
  }
}