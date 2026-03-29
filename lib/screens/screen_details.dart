import 'package:app_film/models/movie_model.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';

class ScreenDetails extends StatelessWidget {
  final Movie movie;

  const ScreenDetails({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String urlBackdrop = 'https://image.tmdb.org/t/p/w500${movie.backdropPath}';

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        title: Text(movie.title.toUpperCase()),
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem de fundo (Backdrop)
            Image.network(
              urlBackdrop,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[900],
                child: const Icon(Icons.movie, color: Colors.white, size: 50),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Nota e Estrela
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      Text(
                        " ${movie.voteAverage.toStringAsFixed(1)} / 10",
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // --- BOTÃO ASSISTIR ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Botão branco com ícone preto (estilo Netflix)
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        // Por enquanto mostra apenas um aviso no rodapé
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Iniciando: ${movie.title}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, size: 30),
                      label: const Text(
                        "ASSISTIR",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // -----------------------
                  const SizedBox(height: 30),

                  const Text(
                    "Sinopse",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    movie.overview.isEmpty
                        ? "Nenhuma descrição disponível para este filme."
                        : movie.overview,
                    style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
