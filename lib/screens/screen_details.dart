import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_film/models/movie_model.dart';
import 'package:app_film/screens/player_screen.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';

class ScreenDetails extends StatefulWidget {
  final Movie movie;

  const ScreenDetails({super.key, required this.movie});

  @override
  State<ScreenDetails> createState() => _ScreenDetailsState();
}

class _ScreenDetailsState extends State<ScreenDetails> {
  // FUNÇÃO PARA SALVAR NO FIREBASE
  void _favoritarFilme() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Salva na coleção: usuarios -> ID_DO_USER -> favoritos -> ID_DO_FILME
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .collection('favoritos')
          .doc(widget.movie.id.toString())
          .set({
            'id': widget.movie.id,
            'title': widget.movie.title,
            'posterPath': widget.movie.posterPath,
            'backdropPath': widget.movie.backdropPath,
            'voteAverage': widget.movie.voteAverage,
            'timestamp': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${widget.movie.title} adicionado aos favoritos! ❤️"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Você precisa estar logado para favoritar!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: AppColors.whiteColor, size: 35),
              onPressed: () => Navigator.pop(context),
            ),
            // --- BOTÃO DE FAVORITOS ADICIONADO AQUI ---
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.red, size: 30),
                onPressed: _favoritarFilme,
              ),
            ],
            // ------------------------------------------
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.blackColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                '$urlImagemBase${widget.movie.backdropPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.movie.title,
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
                            widget.movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

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
                              builder: (context) => PlayerScreen(
                                movieId: widget.movie.id.toString(),
                                title: widget.movie.title,
                              ),
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
                      widget.movie.overview.isEmpty
                          ? "Sinopse não disponível em português."
                          : widget.movie.overview,
                      style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
                    ),

                    const SizedBox(height: 100),
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
