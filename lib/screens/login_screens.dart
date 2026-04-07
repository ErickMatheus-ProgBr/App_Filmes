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
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // 1. LOGIN COM GOOGLE
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return; // Usuário cancelou o login
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      _mostrarErro("Erro no Google: Verifique se o SHA-1 está no Firebase.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 2. LOGIN COM E-MAIL E SENHA (COM TRIM)
  void _loginEmailSenha() async {
    final email = _emailController.text.trim().toLowerCase();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro("Preencha todos os campos!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      _mostrarErro("E-mail ou senha incorretos.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarErro(String texto) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.movie_filter, size: 100, color: AppColors.accent),
            const SizedBox(height: 40),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _senhaController,
              obscureText: _obscureText,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.accent,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isLoading ? null : _loginEmailSenha,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.accent,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text("ENTRAR"),
            ),
            const SizedBox(height: 15),

            OutlinedButton.icon(
              onPressed: _isLoading ? null : _signInWithGoogle,
              icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white, size: 18),
              label: const Text("Entrar com Google", style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.white24),
              ),
            ),

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
