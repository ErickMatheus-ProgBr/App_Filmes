import 'package:flutter/material.dart';
import 'package:app_film/thema/app_colors.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(8.0),
                child: Image.asset(image, width: 160, height: 220, fit: BoxFit.cover),
              ),

              const SizedBox(height: 10.0),

              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.fourthColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
