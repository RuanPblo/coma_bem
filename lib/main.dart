import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/home_screen.dart';


void main() {
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
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
