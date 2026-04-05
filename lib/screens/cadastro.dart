import 'package:app_film/screens/home_screen.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final _emailUsuario = TextEditingController();
  final _nomeUsuario = TextEditingController();
  final _senhaUsuario = TextEditingController();

  @override
  void dispose() {
    _emailUsuario.dispose();
    _nomeUsuario.dispose();
    _senhaUsuario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_outlined, color: AppColors.whiteColor),

        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.person, color: AppColors.accent, size: 180),
                const Text(
                  "Cadastre-se",
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 35),
                ),

                const SizedBox(height: 60),

                TextField(
                  controller: _emailUsuario,
                  style: const TextStyle(color: AppColors.thirdColor),
                  decoration: const InputDecoration(
                    labelText: "E-mail:",
                    labelStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.thirdColor),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _nomeUsuario,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Nome Usuario:",
                    labelStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _senhaUsuario,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Senha:",
                    labelStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),

                const SizedBox(height: 55),

                ElevatedButton(
                  style: style,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Text("Cadastrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
