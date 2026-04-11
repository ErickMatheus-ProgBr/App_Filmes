// import 'package:app_film/screens/cadastro.dart';
// import 'package:app_film/thema/app_colors.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:app_film/screens/login_screens.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenStat extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _senhaController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscureText = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _senhaController.dispose();
//     super.dispose();
//   }

//   // 1. LOGIN COM GOOGLE
//   Future<void> _signInWithGoogle() async {
//     setState(() => _isLoading = true);
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         setState(() => _isLoading = false);
//         return; // Usuário cancelou o login
//       }

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       await FirebaseAuth.instance.signInWithCredential(credential);
//     } catch (e) {
//       _mostrarErro("Erro no Google: Verifique se o SHA-1 está no Firebase.");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   // 2. LOGIN COM E-MAIL E SENHA (COM TRIM)
//   void _loginEmailSenha() async {
//     final email = _emailController.text.trim().toLowerCase();
//     final senha = _senhaController.text.trim();

//     if (email.isEmpty || senha.isEmpty) {
//       _mostrarErro("Preencha todos os campos!");
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha);
//     } on FirebaseAuthException catch (e) {
//       _mostrarErro("E-mail ou senha incorretos.");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   void _mostrarErro(String texto) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(texto), backgroundColor: Colors.redAccent));
//   }
