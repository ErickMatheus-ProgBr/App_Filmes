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
    List<Movie> listaTemporaria = [];
    const String apiKey = "839ee2f7b3c54705b7711a9920805bf0";
    // const url =
    //     'https://api.themoviedb.org/3/movie/popular?api_key=839ee2f7b3c54705b7711a9920805bf0&language=pt-BR';

    try {
      // 2. O Loop: vai rodar 3 vezes (página 1, depois 2, depois 3)
      for (int pagina = 1; pagina <= 3; pagina++) {
        final url =
            'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=pt-BR&page=$pagina';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List results = data['results'];

          // 3. O 'map' transforma o JSON em objeto Movie (que você acabou de aprender!)
          // O 'addAll' vai adicionando os novos filmes ao que já tinha na sacola
          listaTemporaria.addAll(results.map((item) => Movie.fromJson(item)).toList());
        }
      }

      // 4. Quando o loop acabar, atualizamos a tela
      if (mounted) {
        setState(() {
          // .take(50) garante que, mesmo vindo 60 filmes (20x3), a gente só use 50
          listaFilmes = listaTemporaria.take(51).toList();
        });
      }
    } catch (e) {
      print("Erro na API: $e");
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
    final listaBanner = listaFilmes.take(5).toList(); // Pega os 5 primeiros
    final listaLancamentos = listaFilmes.skip(5).take(10).toList(); // Pula 5, pega 10
    final listaPopulares = listaFilmes.skip(15).toList(); // Pula os 15 que já usamos e pega o resto

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
                      itemCount: listaBanner.length,
                      itemBuilder: (context, index) {
                        final movie = listaBanner[index];
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
                            itemCount: listaLancamentos.length,
                            itemBuilder: (context, index) {
                              final movie = listaLancamentos[index];
                              final linkFinal = '$urlImagemBase${movie.posterPath}';

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScreenDetails(movie: movie),
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
                      // Garante que o título "POPULARES" fique na esquerda
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

                        const SizedBox(height: 25), // Diminuí o espaço de 200 para 15

                        GridView.builder(
                          // ESSAS DUAS LINHAS SÃO OBRIGATÓRIAS:
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),

                          itemCount: listaPopulares.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 3 filmes na horizontal
                            crossAxisSpacing: 5, // Espaço entre colunas
                            mainAxisSpacing: 1, // Espaço entre linhas
                            childAspectRatio:
                                0.38, // Ajusta a altura do card (aumente se o texto sumir)
                          ),
                          itemBuilder: (context, index) {
                            final movie = listaPopulares[index];
                            final linkFinal = "$urlImagemBase${movie.posterPath}";
                            // return CardFilm(title: movie.title, image: linkFinal);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScreenDetails(movie: movie),
                                  ),
                                );
                              },
                              child: CardFilm(title: movie.title, image: linkFinal),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
