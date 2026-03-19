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
        title: Text("Voltar", style: TextStyle(color: AppColors.thirdColor, fontSize: 20)),
        backgroundColor: AppColors.blackColor,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 400,

              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),

              clipBehavior: Clip.antiAlias,

              child: Image.asset(
                film["image"] ?? "assets.placeholder.jpg",
                width: double.infinity,
                height: 350,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),

            Padding(
              padding: const EdgeInsetsGeometry.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    film["title"] ?? "  Untitled.",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppColors.thirdColor,
                      letterSpacing: 1.3,
                    ),
                  ),

                  const SizedBox(height: 13),

                  const Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.whiteColor, size: 18),
                      SizedBox(width: 8),
                      Text("2024", style: TextStyle(color: AppColors.whiteColor)),
                      SizedBox(width: 20),
                      Icon(Icons.access_time, color: AppColors.whiteColor, size: 19),
                      SizedBox(width: 8),
                      Text("2h 30min", style: TextStyle(color: AppColors.whiteColor)),
                    ],
                  ),

                  const SizedBox(height: 12),

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
                    // Pegamos a chave 'resumo' ou 'description' que está na sua lista
                    film["description"] ?? film["resumo"] ?? "no description",
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
