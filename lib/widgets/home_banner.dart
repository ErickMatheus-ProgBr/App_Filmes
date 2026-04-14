import 'package:flutter/material.dart';
import 'package:app_film/models/movie_model.dart';
import 'package:app_film/screens/screen_details.dart';
import 'package:app_film/thema/app_colors.dart';

class HomeBanner extends StatelessWidget {
  final List<Movie> movies;
  final PageController controller;

  const HomeBanner({super.key, required this.movies, required this.controller});

  @override
  Widget build(BuildContext context) {
    // FUNCIONALIDADE: Renderiza apenas o carrossel de imagens do topo
    return SizedBox(
      height: 480,
      child: PageView.builder(
        controller: controller,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenDetails(movie: movie)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.play_circle_fill, color: AppColors.accent, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "ASSISTIR AGORA",
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
