import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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


  File? _fotoPrato;


  final String _latitude = '';
  final String _longitude = '';


  final ImagePicker _picker = ImagePicker();


  Future<void> _tirarFoto() async {
    final XFile? fotoCapturada = await _picker.pickImage(source: ImageSource.camera);


    if (fotoCapturada != null) {
      setState(() {
        _fotoPrato = File(fotoCapturada.path);
      });
    }
  }


  void _salvarCadastro() async {
    if(_nomeController.text.isEmpty || _culinariaController.text.isEmpty) {


      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Por favor, preencha os campos obrigatorios !'), backgroundColor: Colors.red),
      );
      return;
    }


    try {
      Map<String, dynamic> dadosRestaurante = {
        'res_nm_restaurante': _nomeController.text,
        'res_ds_tipo_culinaria': _culinariaController.text,
        'res_nu_latitude': _latitude,
        'res_nu_longitude': _longitude,
      };


      await DatabaseHelper.instancia.inserirDados('restaurante', dadosRestaurante);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restaurante cadastrado com sucesso !'), backgroundColor: Colors.green),
      );


      Navigator.pop(context);
    } catch (erro) {
      print('DEBUG Erro ao salvar no SQLite: $erro');


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro inesperado ao salvar.'), backgroundColor: Colors.red),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Cadastro', style: TextStyle(color: Colors.white,)), backgroundColor: const Color.fromARGB(255, 92, 21, 3)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CampoFormularioCustomizado(
              titulo: 'Nome do Restaurante',
              controlador: _nomeController,
            ),


            CampoFormularioCustomizado(
              titulo: 'Tipo da Culinaria',
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
