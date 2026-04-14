import 'package:app_film/screens/cadastro.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controles de texto para capturar o que o usuário digita
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Variáveis de estado para controlar o carregamento e a visibilidade da senha
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    // Importante: limpa os controllers da memória quando a tela é fechada
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // 1. LÓGICA DE LOGIN COM GOOGLE
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true); // Inicia o círculo de carregamento
    try {
      // Abre a janela de seleção de contas do Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // O usuário fechou a janelinha sem escolher uma conta
      }

      // Obtém os tokens de autenticação da conta escolhida
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Cria a credencial necessária para o Firebase entender o login do Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Efetua o login de fato no Firebase com a credencial do Google
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Dica técnica importante para o desenvolvedor
      _mostrarErro("Erro no Google: Verifique se o SHA-1 está no Firebase.");
    } finally {
      // Finaliza o carregamento independente de sucesso ou erro
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 2. LÓGICA DE LOGIN COM E-MAIL E SENHA
  void _loginEmailSenha() async {
    // O .trim() remove espaços vazios antes e depois; .toLowerCase() padroniza o e-mail
    final email = _emailController.text.trim().toLowerCase();
    final senha = _senhaController.text.trim();

    // Validação básica para não enviar campos vazios ao Firebase
    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro("Preencha todos os campos!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Tenta autenticar no Firebase com e-mail e senha
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      // Captura erros específicos do Firebase (como senha errada ou usuário inexistente)
      _mostrarErro("E-mail ou senha incorretos.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Função utilitária para exibir mensagens rápidas no rodapé (SnackBar)
  void _mostrarErro(String texto) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // SingleChildScrollView permite que a tela role se o teclado cobrir os campos
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Logotipo ou ícone principal do App
            const Icon(Icons.movie_filter, size: 105, color: AppColors.accent),
            const SizedBox(height: 40),

            // CAMPO DE E-MAIL
            TextField(
              controller: _emailController,
              cursorColor: AppColors.accent,
              keyboardType: TextInputType.emailAddress, // Mostra o "@" no teclado do celular
              style: const TextStyle(color: AppColors.whiteColor),
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
                labelText: "E-mail:",
                labelStyle: TextStyle(color: AppColors.thirdColor),
              ),
            ),
            const SizedBox(height: 18),

            // CAMPO DE SENHA
            TextField(
              controller: _senhaController,
              cursorColor: AppColors.accent,
              obscureText: _obscureText, // Controla se a senha aparece ou fica oculta (***)
              style: const TextStyle(color: AppColors.whiteColor),
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.accent),
                ),
                labelText: "Senha:",
                labelStyle: const TextStyle(color: AppColors.thirdColor),
                // Ícone de "olhinho" para mostrar/esconder a senha
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.accent,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 55),

            // BOTÃO ENTRAR
            ElevatedButton(
              // Se estiver carregando, o botão fica desativado (null)
              onPressed: _isLoading ? null : _loginEmailSenha,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.accent,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: AppColors.background),
                    )
                  : const Text(
                      "ENTRAR",
                      style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 20),

            // BOTÃO GOOGLE
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _signInWithGoogle,
              icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white, size: 18),
              label: const Text("Entrar com Google", style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.white24),
              ),
            ),

            const SizedBox(height: 10),

            // BOTÃO CRIAR CONTA (Navegação)
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CadastroUsuario()),
              ),
              child: const Text("Criar conta", style: TextStyle(color: AppColors.accent)),
            ),
          ],
        ),
      ),
    );
  }
}
