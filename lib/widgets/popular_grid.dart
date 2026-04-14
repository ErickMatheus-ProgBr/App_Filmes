import 'package:flutter/material.dart';
import 'package:app_film/models/movie_model.dart';
import 'package:app_film/screens/screen_details.dart';
import 'package:app_film/widgets/card_film.dart';
import 'package:app_film/thema/app_colors.dart';

class PopularGrid extends StatelessWidget {
  final List<Movie> movies; // Filmes populares
  final bool isLoadingMore; // Para mostrar o carregando no botão
  final VoidCallback onLoadMore; // Função que será chamada ao clicar no botão
  final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

  const PopularGrid({
    super.key,
    required this.movies,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    // FUNCIONALIDADE: Renderiza a grade vertical de filmes e o botão de paginação

    final displayedMovies = movies;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "POPULARES",
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Deixa o scroll para o SingleChildScrollView da Home
            itemCount: displayedMovies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 2,
              childAspectRatio: 0.38,
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScreenDetails(movie: movies[index])),
              ),
              child: CardFilm(
                title: movies[index].title,
                image: "$urlImagemBase${movies[index].posterPath}",
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Botão Carregar Mais
          Center(
            child: isLoadingMore
                ? const CircularProgressIndicator(color: AppColors.accent)
                : ElevatedButton(
                    onPressed: onLoadMore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      "VER MAIS FILMES",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
