import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_film/screens/login_screens.dart';
import 'package:app_film/screens/home_screen.dart'; // Certifique-se de ter criado este arquivo
import 'firebase_options.dart';

void main() async {
  // ESSA LINHA É OBRIGATÓRIA:
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FilmeApp',
      // O StreamBuilder decide qual tela mostrar automaticamente
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Se estiver carregando a checagem do Firebase
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.red)),
            );
          }
          // Se o usuário está logado, vai direto para a Home
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          // Se não está logado, vai para o Login
          return const LoginScreen();
        },
      ),
    );
  }
}
