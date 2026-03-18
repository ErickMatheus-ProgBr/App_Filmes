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
        title: Text(film["title"]!.toUpperCase()),
        backgroundColor: AppColors.fourthColor,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(film["image"]!, width: double.infinity, height: 350, fit: BoxFit.cover),

            Padding(
              padding: const EdgeInsetsGeometry.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    film["title"]!.toLowerCase(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fourthColor,
                    ),
                  ),

                  const SizedBox(height: 20), // Espaço
                  // 3. O RESUMO (Finalmente ele aparece completo!)
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    // Pegamos a chave 'resumo' ou 'description' que está na sua lista
                    film["description"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5, // Dá um respiro entre as linhas do texto
                    ),
                    textAlign: TextAlign.justify, // Texto alinhado dos dois lados
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
