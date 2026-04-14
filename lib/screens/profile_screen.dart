import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_film/screens/login_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// FUNÇÃO DE LOGOUT: Responsável por desconectar o usuário completamente
  Future<void> _fazerLogout(BuildContext context) async {
    try {
      // 1. Encerra a sessão no Firebase Auth
      await FirebaseAuth.instance.signOut();

      // 2. Encerra a sessão no Google (evita que o app logue sozinho na próxima vez)
      await GoogleSignIn().signOut();

      // 3. Navegação: Remove todas as telas da memória e volta para a tela de Login
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Isso impede que o usuário consiga "voltar" para o perfil
        );
      }
    } catch (e) {
      // Caso ocorra erro no logout, ele imprime no console para debug
      debugPrint("Erro ao sair: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Puxa as informações do usuário logado diretamente do Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.blackColor, // Cor de fundo vinda do seu tema
      appBar: AppBar(
        title: const Text("Meu Perfil", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent, // Deixa a barra superior invisível
        iconTheme: const IconThemeData(color: Colors.white), // Cor da seta de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Margem geral da tela
        child: Column(
          children: [
            // Avatar circular com ícone de pessoa
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 30), // Espaço vertical
            // Exibição do Nome (Texto estático no momento)
            _itemPerfil("Nome", "Usuário FilmeFlix"),

            // Exibição do E-mail (Puxa o e-mail real do Google/Firebase se existir)
            _itemPerfil("E-mail", user?.email ?? "email@exemplo.com"),

            const SizedBox(height: 40),

            // Texto Informativo para o usuário (Placeholder)
            const Text(
              "As configurações de perfil estarão disponíveis em breve!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),

            // Spacer: Empurra tudo o que estiver abaixo dele para o final da tela
            const Spacer(),

            // Botão de Logout com margem inferior
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent, // Cor de destaque do seu tema
                  minimumSize: const Size(double.infinity, 50), // Largura total
                ),
                onPressed: () => _fazerLogout(context), // Chama a função de sair
                child: const Text("SAIR DA CONTA", style: TextStyle(color: AppColors.whiteColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// WIDGET REUTILIZÁVEL: Cria cada linha de informação (Nome, E-mail, etc.)
  Widget _itemPerfil(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10), // Espaço entre os itens
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rótulo cinza (ex: "Nome")
              Text(titulo, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              // Valor em destaque (ex: "Erick")
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Aqui não tem mais o botão de editar, deixando a UI limpa
        ],
      ),
    );
  }
}
