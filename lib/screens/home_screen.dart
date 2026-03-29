import 'dart:async' as async_timer;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_film/models/movie_model.dart';
import 'package:app_film/screens/screen_details.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app_film/widgets/card_film.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> listaFilmes = [];
  late PageController _pageController;
  int _currentPage = 0;
  async_timer.Timer? _timer;

  // URL Base necessária para as imagens do TMDB funcionarem
  final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

  Future<void> fetchMovies() async {
    const url =
        'https://api.themoviedb.org/3/movie/popular?api_key=839ee2f7b3c54705b7711a9920805bf0&language=pt-BR';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        if (mounted) {
          setState(() {
            listaFilmes = results.map((item) => Movie.fromJson(item)).toList();
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar filmes: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchMovies();

    _timer = async_timer.Timer.periodic(const Duration(seconds: 4), (timer) {
      if (listaFilmes.isNotEmpty && _pageController.hasClients) {
        _currentPage = (_currentPage + 1) % (listaFilmes.length > 5 ? 5 : listaFilmes.length);
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: AppColors.blackColor,
        title: const Text(
          "Filmes Flix",
          style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold, color: AppColors.whiteColor),
        ),
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.movie, color: AppColors.whiteColor, size: 37),
                title: const Text(
                  "Categorias",
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 33),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      body: listaFilmes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BANNER
                  SizedBox(
                    height: 580,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: listaFilmes.length > 5 ? 5 : listaFilmes.length,
                      itemBuilder: (context, index) {
                        final movie = listaFilmes[index];
                        return Image.network(
                          '$urlImagemBase${movie.posterPath}',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 35),

                  // LISTA HORIZONTAL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LANÇAMENTOS",
                          style: TextStyle(
                            fontSize: 21,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 350,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: listaFilmes.length,
                            itemBuilder: (context, index) {
                              final movie = listaFilmes[index];
                              final linkFinal = '$urlImagemBase${movie.posterPath}';

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScreenDetails(
                                        film: {"title": movie.title, "image": linkFinal},
                                      ),
                                    ),
                                  );
                                },
                                child: CardFilm(title: movie.title, image: linkFinal),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Text(
                          "POPULARES",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
