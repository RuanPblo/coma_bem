import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:coma_bem/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Validação Funcional: O robô vai fazer Login sozinho',
    (WidgetTester tester) async {

      // ==========================================
      // PREPARAÇÃO: ABRINDO O APLICATIVO
      // ==========================================

      app.main();

      await tester.pumpAndSettle();

      // ==========================================
      // FASE 1: PROCURANDO ELEMENTOS
      // ==========================================

      final campoEmail =
          find.byType(TextField).first;

      final campoSenha =
          find.byType(TextField).last;

      final botaoEntrar =
          find.text('Entrar');

      // ==========================================
      // FASE 2: DIGITANDO E CLICANDO
      // ==========================================

      await tester.enterText(
        campoEmail,
        'admin@comabem.com',
      );

      await tester.enterText(
        campoSenha,
        'senha123',
      );

      await tester.pumpAndSettle();

      await tester.tap(botaoEntrar);

      await tester.pumpAndSettle();

      // ==========================================
      // FASE 3: VALIDANDO O CATÁLOGO
      // ==========================================

      expect(
        find.text('Catálogo de Restaurantes'),
        findsOneWidget,
      );

      // ==========================================
      // 🏆 PASSO 5: DESAFIO FINAL
      // TESTANDO A NAVEGAÇÃO PARA NOVO CADASTRO
      // ==========================================

      // 1. Encontrar o botão flutuante (+)
      final botaoNovo =
          find.byIcon(Icons.add);

      // 2. Clicar no botão +
      await tester.tap(botaoNovo);

      // 3. Esperar a tela de cadastro carregar
      await tester.pumpAndSettle();

      // 4. Verificar se a tela possui "Foto do Prato"
      expect(
        find.text('Foto do Prato'),
        findsOneWidget,
      );
    },
  );
}