import 'package:app_film/models/movie_model.dart';
import 'package:app_film/screens/player_screen.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';

class ScreenDetails extends StatelessWidget {
  final Movie movie;

  const ScreenDetails({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: CustomScrollView(
        slivers: [
          // Barra de topo com a imagem de fundo (Backdrop)
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.blackColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network('$urlImagemBase${movie.backdropPath}', fit: BoxFit.cover),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e Nota
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // BOTÃO ASSISTIR AGORA
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlayerScreen(movieId: movie.id.toString(), title: movie.title),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("ASSISTIR AGORA"),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Sinopse",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      movie.overview.isEmpty
                          ? "Sinopse não disponível em português."
                          : movie.overview,
                      style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
                    ),

                    const SizedBox(height: 100), // Espaço final
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
