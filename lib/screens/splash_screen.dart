import 'dart:ui'; // 1. Para usar o ImageFilter (Blur)
import 'package:flutter/material.dart';

// 2. StatefulWidget: Usamos porque a tela vai "mudar" (animar) sozinha.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// 3. SingleTickerProviderStateMixin: Isso aqui é o "relógio" da animação.
// Ele diz ao Flutter: "Siga o ritmo da tela do celular".
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // 4. AnimationController: O "Maestro". Ele controla o tempo (começa, para, repete).
  late AnimationController _controller;

  // 5. Animation: O "Valor". Ele guarda o número que vai mudar (ex: de 0.0 até 10.0).
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 6. Configurando o Maestro:
    _controller = AnimationController(
      vsync:
          this, // Garante que a animação não rode se a tela estiver desligada (economiza bateria).
      duration: const Duration(seconds: 2), // Quanto tempo dura UM ciclo de desfoque.
    )..repeat(reverse: true); // .repeat faz o "loop", reverse: true faz o "vai e volta".

    // 7. Tween (Between): Significa "entre".
    // Dizemos que o desfoque vai de 0.0 (nítido) até 8.0 (bem embaçado).
    _animation = Tween<double>(begin: 0.0, end: 4.0).animate(_controller);

    // 8. Timer para mudar de tela:
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          "/homeScreen",
        ); // Vai para a Home e "mata" a Splash.
      }
    });
  }

  @override
  void dispose() {
    // 9. Dispose: Muito importante! Quando saímos da tela, "desligamos o motor"
    // para o app não ficar gastando processamento à toa.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto para destacar a logo.
      body: Center(
        // 10. AnimatedBuilder: Ele "escuta" a animação.
        // Toda vez que o número mudar, ele reconstrói o que está dentro dele.
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ImageFiltered(
              // 11. ImageFilter.blur: Aqui a mágica acontece.
              // O sigmaX e sigmaY recebem o valor que está variando na animação.
              imageFilter: ImageFilter.blur(sigmaX: _animation.value, sigmaY: _animation.value),
              child: Image.asset(
                'assets/logo_app_film.jpg', // Verifique se o caminho está certo no seu projeto!
                width: 650,
              ),
            );
          },
        ),
      ),
    );
  }
}
