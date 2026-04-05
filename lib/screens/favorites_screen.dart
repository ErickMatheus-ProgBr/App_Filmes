import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:app_film/screens/screen_details.dart';
import 'package:app_film/models/movie_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        title: const Text("Meus Favoritos", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: user == null
          ? const Center(
              child: Text(
                "Faça login para ver seus favoritos",
                style: TextStyle(color: Colors.white),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              // ACESSA A "PASTA" DE FAVORITOS DO USUÁRIO LOGADO
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(user.uid)
                  .collection('favoritos')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Erro ao carregar dados", style: TextStyle(color: Colors.white)),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Você ainda não salvou nenhum filme! ❤️",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];

                    // Criamos um objeto Movie a partir dos dados do Firebase
                    Movie movie = Movie(
                      id: doc['id'],
                      title: doc['title'],
                      posterPath: doc['posterPath'],
                      backdropPath: doc['backdropPath'],
                      overview: "", // Pode buscar a sinopse se salvou no banco
                      voteAverage: (doc['voteAverage'] as num).toDouble(),
                    );

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          '$urlImagemBase${movie.posterPath}',
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(movie.title, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        "Nota: ${movie.voteAverage}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          // REMOVE DO FIREBASE
                          doc.reference.delete();
                        },
                      ),
                      onTap: () {
                        // NAVEGA DE VOLTA PARA OS DETALHES
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScreenDetails(movie: movie)),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
