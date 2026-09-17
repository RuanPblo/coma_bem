import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:coma_bem/main.dart' as app;

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets(
    'Validação Funcional: O robô vai fazer Login sozinho',
    (WidgetTester tester) async {

      // ABRINDO O APLICATIVO
      app.main();

      await tester.pumpAndSettle();

      // PROCURANDO ELEMENTOS
      final campoEmail = find.byType(TextField).first;
      final campoSenha = find.byType(TextField).last;
      final botaoEntrar = find.text('Entrar');

      // DIGITANDO
      await tester.enterText(
        campoEmail,
        'admin@comabem.com',
      );

      await tester.enterText(
        campoSenha,
        'senha123',
      );

      await tester.pumpAndSettle();

      // CLICANDO EM ENTRAR
      await tester.tap(botaoEntrar);

      await tester.pumpAndSettle();

      // VALIDANDO O CATÁLOGO
      expect(
        find.text('Catálogo de Restaurantes'),
        findsOneWidget,
      );

      // ENCONTRANDO O BOTÃO +
      final botaoNovo = find.byIcon(Icons.add);

      // CLICANDO NO +
      await tester.tap(botaoNovo);

      await tester.pumpAndSettle();

      // VALIDANDO A TELA DE CADASTRO
      expect(
        find.text('Foto do Prato'),
        findsOneWidget,
      );
    },
  );
}