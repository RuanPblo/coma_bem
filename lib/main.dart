import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/cadastro_usuario_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  // No navegador, o sqflite nativo não existe: trocamos a "fábrica" do
  // banco de dados para a versão que grava no IndexedDB do navegador.
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(const ComaBemApp());
}

class ComaBemApp extends StatelessWidget {
  const ComaBemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Coma Bem',

      // Tema principal do aplicativo
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),

        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),

      // Primeira tela que será aberta
      initialRoute: '/splash',

      // Rotas do aplicativo
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/cadastro_usuario': (context) => const CadastroUsuarioScreen(),
        '/home': (context) => const MainNavigationScreen(),
      },
    );
  }
}