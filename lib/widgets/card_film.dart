import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';

class CardFilm extends StatelessWidget {
  final String title;
  final String image;

  const CardFilm({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Faz o card se ajustar ao conteúdo
            children: [
              ClipRRect(
                // CORREÇÃO: Trocado BorderRadiusGeometry por BorderRadius
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(image, width: 160, height: 220, fit: BoxFit.cover),
              ),

              const SizedBox(height: 10.0),

              // O título do filme
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.fourthColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2, // Permite até 2 linhas
                overflow: TextOverflow.ellipsis, // Adiciona "..." se for muito longo
              ),

              // Removido o SizedBox de 12.0 do final para o card não ficar com espaço vazio
            ],
          ),
        ),
      ),
    );
  }
}
