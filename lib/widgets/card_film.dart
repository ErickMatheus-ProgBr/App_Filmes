import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';

class CardFilm extends StatelessWidget {
  final String title;
  final String image;

  const CardFilm({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              image,
              height: 230,
              width: 160,
              fit: BoxFit.cover,
              // ADICIONE ISSO AQUI:
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 230,
                  width: 160,
                  color: Colors.grey[900],
                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              },
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 230, color: Colors.grey, child: const Icon(Icons.broken_image)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.thirdColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
