import 'package:flutter/material.dart';

// Criamos um StatelessWidget pois o visual desse campo não muda por si só.
class CampoFormularioCustomizado extends StatelessWidget {
  // Declaramos as propriedades que nosso campo vai precisar receber.
  // 'final' significa que essas variáveis não mudarão depois que o widget for construído.
  final String titulo;
  final TextEditingController controlador;
  final TextInputType tipoTeclado;
  final bool ocultarTexto;

  // Constructor: Exige que quem for usar esse componente passe os valores obrigatórios (required).
  // tipoTeclado e ocultarTexto têm valores padrão caso não sejam informados.
  const CampoFormularioCustomizado({
    Key? key,
    required this.titulo,
    required this.controlador,
    this.tipoTeclado = TextInputType.text, // Padrão é texto normal
    this.ocultarTexto = false, // Padrão é não ocultar (senha)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retornamos toda a estrutura visual de um TextField com margem inferior (Padding).
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controlador, // Recebe o controlador que veio de fora
        keyboardType: tipoTeclado, // Define se abre o teclado de letras ou números
        obscureText: ocultarTexto, // Define se é senha ou texto legível

        decoration: InputDecoration(
          labelText: titulo, // O nome do campo (Ex: "Nome do Restaurante")

          // ATENÇÃO: Personalize as cores das bordas abaixo para o padrão do seu projeto!
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange, width: 2.0),
          ),
        ),
      ),
    );
  }
}