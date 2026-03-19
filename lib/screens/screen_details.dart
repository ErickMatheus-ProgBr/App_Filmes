import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';

class ScreenDetails extends StatelessWidget {
  final Map<String, String> film;

  const ScreenDetails({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        // Usamos ?? "" para garantir que o app não trave se o título sumir
        title: Text((film["title"] ?? "Detalhes").toUpperCase()),
        backgroundColor: AppColors.fourthColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do pôster em destaque
            Image.asset(
              film["image"] ?? "assets/placeholder.jpg",
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
            ),

            Padding(
              // CORREÇÃO: Trocado EdgeInsetsGeometry por EdgeInsets
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (film["title"] ?? "Sem Título").toLowerCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.thirdColor,
                      letterSpacing: 1.3,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Descrição",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.thirdColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    // Tentamos pegar 'description', se não existir, usamos um texto padrão
                    film["description"] ?? "Nenhuma descrição disponível para este filme.",
                    style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
