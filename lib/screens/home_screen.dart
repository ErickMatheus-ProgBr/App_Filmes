import 'dart:async' as async_timer;
import 'dart:convert';
import 'package:app_film/screens/categories_screen.dart';
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
  TextEditingController _controleBusca = TextEditingController(); // O "controle" do campo
  List<Movie> filmesFiltrados = []; // Uma lista vazia que vai guardando o que a gente achar

  bool isLoading = false;
  List<Movie> filmesBusca = [];

  final String apiKey = "839ee2f7b3c54705b7711a9920805bf0"; // coloca sua chave aqui

  final Map<String, int> generos = {
    "Ação": 28,
    "Comédia": 35,
    "Terror": 27,
    "Drama": 18,
    "Ficção": 878,
    "Animação": 16,
  };

  // ESSA É A CHAVE: Diz qual aba está aberta agora
  int _currentIndex = 0;

  List<Movie> listaFilmes = [];
  late PageController _pageController;
  int _currentPage = 0;
  async_timer.Timer? _timer;
  final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

  List<Movie> filmesPorCategoria = [];

  Future<void> searchFilmes(String query) async {
    if (query.isEmpty) {
      setState(() {
        filmesBusca = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=pt-BR&query=$query';

    try {
      final response = await http.get(Uri.parse(url));

      print(response.body); // 👈 DEBUG

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        setState(() {
          filmesBusca = results.map((e) => Movie.fromJson(e)).toList();
        });
      }
    } catch (e) {
      print("ERRO REAL: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  // Lógica da API (Você já tinha feito e está ótima!)
  Future<void> fetchMovies() async {
    List<Movie> listaTemporaria = [];
    const String apiKey = "839ee2f7b3c54705b7711a9920805bf0";
    try {
      for (int pagina = 4; pagina <= 5; pagina++) {
        final url =
            'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=pt-BR&region=BRpage=$pagina';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List results = data['results'];
          for (var item in results) {
            listaTemporaria.add(Movie.fromJson(item));
          }
        }
      }
      if (mounted) {
        setState(() {
          listaFilmes = listaTemporaria;
        });
      }
    } catch (e) {
      print("Erro: $e");
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
    // Organizando os dados para a Home
    final listaBanner = listaFilmes.take(5).toList();
    final listaLancamentos = listaFilmes.skip(5).take(10).toList();
    final listaPopulares = listaFilmes.skip(20).toList();

    return Scaffold(
      drawer: Drawer(
        width: 290,
        backgroundColor: Colors.black,
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.accent),
              child: Center(
                child: Text(
                  "Olá,",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.favorite, color: AppColors.accent),
              title: const Text('FAVORITOS ', style: TextStyle(color: AppColors.thirdColor)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: AppColors.thirdColor),
              title: const Text(' My Course ', style: TextStyle(color: AppColors.thirdColor)),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.thirdColor),
              title: const Text('LogOut', style: TextStyle(color: AppColors.thirdColor)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 450, left: 150),
              child: Text("Versão 1.0.0", style: TextStyle(color: AppColors.whiteColor)),
            ),
          ],
        ),
      ),

      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        // leading: Image.asset("assets/ff.png", height: 20, fit: BoxFit.cover),
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: AppColors.blackColor,
        title: const Text(
          "Filmes Flix",
          style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold, color: AppColors.accent),
        ),
      ),

      // AQUI ESTÁ A LÓGICA SIMPLES:
      // Se _currentIndex for 0, mostra a Home. Se não, mostra o texto da aba.
      body: _currentIndex == 0
          // --- CAMINHO 0: TELA DE INÍCIO (Seu código original) ---
          ? (listaFilmes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // BANNER
                        SizedBox(
                          height: 500, // Ajuste a altura conforme seu design
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: listaBanner.length,
                            itemBuilder: (context, index) {
                              final movie = listaBanner[index];

                              return InkWell(
                                // 🔥 Ação de clique para abrir os detalhes
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScreenDetails(movie: movie),
                                    ),
                                  );
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // 1. A IMAGEM DE FUNDO (Backdrop é melhor para horizontal)
                                    Image.network(
                                      'https://image.tmdb.org/t/p/w780${movie.backdropPath}',
                                      fit: BoxFit.cover,
                                      // Caso a imagem falhe, mostra um carregando
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Center(child: Icon(Icons.error)),
                                    ),

                                    // 2. O GRADIENTE (Para dar leitura ao texto)
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.9), // Escuro embaixo
                                            Colors.transparent, // Transparente em cima
                                          ],
                                        ),
                                      ),
                                    ),

                                    // 3. O TEXTO QUE ACOMPANHA O FILME
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
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 8,
                                                  color: Colors.black,
                                                  offset: Offset(2, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.play_circle_fill,
                                                color: AppColors.accent,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "ASSISTIR AGORA",
                                                style: TextStyle(
                                                  color: AppColors.accent,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
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
                        ),
                        const SizedBox(height: 35),
                        // LANÇAMENTOS
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "LANÇAMENTOS",
                                style: TextStyle(
                                  fontSize: 21,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 340,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: listaLancamentos.length,
                                  itemBuilder: (context, index) {
                                    final movie = listaLancamentos[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ScreenDetails(movie: movie),
                                          ),
                                        );
                                      },
                                      child: CardFilm(
                                        title: movie.title,
                                        image: '$urlImagemBase${movie.posterPath}',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // POPULARES
                        Padding(
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
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listaPopulares.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 2,
                                  childAspectRatio: 0.38,
                                ),
                                itemBuilder: (context, index) {
                                  final movie = listaPopulares[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ScreenDetails(movie: movie),
                                        ),
                                      );
                                    },
                                    child: CardFilm(
                                      title: movie.title,
                                      image: "$urlImagemBase${movie.posterPath}",
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
          // --- CAMINHO 1: TELA DE PESQUISA (O que você pediu agora) ---
          : _currentIndex == 1
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controleBusca,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Digite o nome do filme...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // 🔥 AQUI ESTÁ A MUDANÇA IMPORTANTE
                    onChanged: (valor) {
                      searchFilmes(valor);
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _controleBusca.text.isEmpty
                        ? const Center(
                            child: Text("Pesquisar Filmes", style: TextStyle(color: Colors.white)),
                          )
                        : ListView.builder(
                            itemCount: filmesBusca.length,
                            itemBuilder: (context, index) {
                              final filme = filmesBusca[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScreenDetails(movie: filme),
                                    ),
                                  );
                                },
                                leading: Image.network(
                                  '$urlImagemBase${filme.posterPath}',
                                  width: 50,
                                ),
                                title: Text(
                                  filme.title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            )
          // --- CAMINHO FINAL: OUTRAS ABAS (Categorias/Perfil) ---
          : _currentIndex == 2
          ? const CategoriesScreen()
          : _currentIndex == 3
          ? const Center(
              child: Text("Perfil em breve", style: TextStyle(color: Colors.white, fontSize: 20)),
            )
          : const SizedBox(),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.blackColor,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.thirdColor,
        currentIndex: _currentIndex, // Diz qual ícone deve brilhar
        onTap: (int indexClicado) {
          // AQUI É O SEGREDO: Atualiza o estado para mudar a tela
          setState(() {
            _currentIndex = indexClicado;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Pesquisar"),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: "Categorias"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
