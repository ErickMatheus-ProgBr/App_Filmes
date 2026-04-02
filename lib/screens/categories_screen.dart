import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_film/models/movie_model.dart';
import 'package:app_film/widgets/card_film.dart';
import 'package:app_film/screens/screen_details.dart';
import 'package:app_film/thema/app_colors.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final Map<String, int> generos = {
    "Ação": 28,
    "Comédia": 35,
    "Terror": 27,
    "Drama": 18,
    "Ficção": 878,
    "Animação": 16,
  };

  List<Movie> filmes = [];
  int currentPage = 1;
  bool isLoading = false;
  int? generoSelecionado;

  final String apiKey = "839ee2f7b3c54705b7711a9920805bf0";
  final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

  Future<void> fetchFilmes(int generoId, {int page = 1}) async {
    setState(() {
      isLoading = true;
      generoSelecionado = generoId;
    });

    final url =
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=pt-BR&region=BR&with_genres=$generoId&page=$page';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        // 🔥 FILTRO PROFISSIONAL (remove filmes sem tradução)
        List<Movie> novosFilmes = results
            .map((e) => Movie.fromJson(e))
            .where((movie) => movie.title.isNotEmpty && movie.overview.isNotEmpty)
            .toList();

        setState(() {
          if (page == 1) {
            filmes = novosFilmes;
          } else {
            filmes.addAll(novosFilmes);
          }
          currentPage = page;
        });
      }
    } catch (e) {
      debugPrint("Erro: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        title: const Text(
          "Categorias",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 CATEGORIAS
            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: generos.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        fetchFilmes(entry.value, page: 1);
                      },
                      child: Text(entry.key),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 FILMES
            Expanded(
              child: filmes.isEmpty
                  ? const Center(
                      child: Text("Selecione uma categoria", style: TextStyle(color: Colors.white)),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filmes.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.45,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        final movie = filmes[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ScreenDetails(movie: movie)),
                            );
                          },
                          child: CardFilm(
                            title: movie.title,

                            // 🔥 CORREÇÃO DE IMAGEM
                            image: (movie.posterPath.isNotEmpty)
                                ? "$urlImagemBase${movie.posterPath}"
                                : "https://via.placeholder.com/300x450?text=Sem+Imagem",
                          ),
                        );
                      },
                    ),
            ),

            // 🔥 BOTÃO PRÓXIMO
            if (filmes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: isLoading || generoSelecionado == null
                      ? null
                      : () {
                          fetchFilmes(generoSelecionado!, page: currentPage + 1);
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Carregar mais"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
