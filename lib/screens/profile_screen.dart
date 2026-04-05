import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_film/screens/login_screens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // FUNÇÃO DE LOGOUT COMPLETA
  Future<void> _fazerLogout(BuildContext context) async {
    try {
      // 1. Sai do Firebase
      await FirebaseAuth.instance.signOut();

      // 2. Sai do Google (Importante para não logar automático depois)
      await GoogleSignIn().signOut();

      // 3. Volta para o Login e apaga o histórico de telas
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Erro ao sair: $e");
    }
  }

  void _abrirDialogEditarNome(BuildContext context, String userId, String nomeAtual) {
    final controller = TextEditingController(text: nomeAtual);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Editar Nome", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
                'nome': controller.text.trim(),
              });
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        title: const Text("Meu Perfil", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Usuário não encontrado no banco", style: TextStyle(color: Colors.white)),
            );
          }

          var dados = snapshot.data!;
          String userId = user?.uid ?? "";

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 30),

                // Note que passei podeEditar: true aqui para o Nome
                _itemPerfil(
                  "Nome",
                  dados['nome'],
                  podeEditar: true,
                  context: context,
                  userId: userId,
                ),

                _itemPerfil("E-mail", dados['email']),

                const Spacer(),

                // BOTÃO DE SAIR CORRIGIDO
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () => _fazerLogout(context),
                  child: const Text("SAIR DA CONTA", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemPerfil(
    String titulo,
    String valor, {
    bool podeEditar = false,
    BuildContext? context,
    String? userId,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(color: Colors.grey, fontSize: 14)),
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
          if (podeEditar)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.redAccent),
              onPressed: () => _abrirDialogEditarNome(context!, userId!, valor),
            ),
        ],
      ),
    );
  }
}
