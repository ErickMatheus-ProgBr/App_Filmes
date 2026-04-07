import 'package:app_film/screens/home_screen.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false; // Para mostrar um carregando ao clicar em finalizar

  // Controladores dos campos
  final _registerEmail = TextEditingController();
  final _registerName = TextEditingController();
  final _registerSenha = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _registerEmail.dispose();
    _registerName.dispose();
    _registerSenha.dispose();
    super.dispose();
  }

  // Função principal para avançar ou finalizar o cadastro
  void _nextStep() async {
    // 1. Validação de E-mail (na página 0)
    if (_currentPage == 0) {
      String email = _registerEmail.text.trim();
      bool emailValido = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(email);

      if (!emailValido) {
        _mostrarMensagem("E-mail inválido! Digite novamente.");
        return;
      }
    }

    // 2. Validação de Nome (na página 1)
    if (_currentPage == 1 && _registerName.text.trim().isEmpty) {
      _mostrarMensagem("Por favor, digite seu nome.");
      return;
    }

    // 3. Lógica para animar ou Salvar no Firebase
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      // ESTAMOS NA ÚLTIMA PÁGINA: HORA DE SALVAR NO BANCO DE DADOS
      if (_registerSenha.text.length < 6) {
        _mostrarMensagem("A senha deve ter pelo menos 6 caracteres.");
        return;
      }

      _executarCadastroFirebase();
    }
  }

  // Função que se comunica com o Firebase
  void _executarCadastroFirebase() async {
    setState(() => _isLoading = true);

    try {
      // A. Criar Usuário no Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _registerEmail.text.trim(),
        password: _registerSenha.text.trim(),
      );

      // B. Salvar o Nome e outros dados no Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(userCredential.user!.uid).set({
        'nome': _registerName.text.trim(),
        'email': _registerEmail.text.trim(),
        'uid': userCredential.user!.uid,
        'criadoEm': DateTime.now(),
      });

      // C. Sucesso! O StreamBuilder no main.dart cuidará da navegação.
      // Se quiser garantir a troca de tela:
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String erro = "Ocorreu um erro ao cadastrar.";
      if (e.code == 'email-already-in-use') erro = "Este e-mail já está em uso.";
      if (e.code == 'weak-password') erro = "Senha muito fraca.";

      _mostrarMensagem(erro);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: AppColors.whiteColor),
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
              );
              setState(() => _currentPage--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPage(
                titulo: "Qual o seu e-mail?",
                hint: "exemplo@email.com",
                controller: _registerEmail,
                icon: Icons.email_outlined,
                tipoTeclado: TextInputType.emailAddress,
              ),
              _buildPage(
                titulo: "Como quer ser chamado?",
                hint: "Nome de usuário",
                controller: _registerName,
                icon: Icons.person_outline,
              ),
              _buildPage(
                titulo: "Crie uma senha forte",
                hint: "Sua senha",
                controller: _registerSenha,
                icon: Icons.lock_outline,
                isObscure: true,
              ),
            ],
          ),
          // Mostra um loading na tela toda enquanto salva no Firebase
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: AppColors.accent)),
            ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String titulo,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isObscure = false,
    TextInputType tipoTeclado = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: AppColors.accent),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: controller,
            obscureText: isObscure,
            keyboardType: tipoTeclado,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.thirdColor),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent),
              ),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: _isLoading ? null : _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              _currentPage == 2 ? "FINALIZAR CADASTRO" : "PRÓXIMO",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
