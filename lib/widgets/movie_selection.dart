import 'package:flutter/material.dart';
import 'package:app_film/models/movie_model.dart';
import 'package:app_film/screens/screen_details.dart';
import 'package:app_film/widgets/card_film.dart';
import 'package:app_film/thema/app_colors.dart';

class MovieSection extends StatelessWidget {
  final String title; // Título da seção (ex: "LANÇAMENTOS")
  final List<Movie> movies; // Lista de filmes para essa seção
  final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

  const MovieSection({super.key, required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    // FUNCIONALIDADE: Cria uma linha horizontal com título e cards de filmes
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 21,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScreenDetails(movie: movies[index])),
                ),
                child: CardFilm(
                  title: movies[index].title,
                  image: '$urlImagemBase${movies[index].posterPath}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
