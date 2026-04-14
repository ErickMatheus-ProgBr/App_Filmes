import 'dart:async' as async_timer;
import 'dart:convert';
import 'package:app_film/screens/categories_screen.dart';
import 'package:app_film/screens/login_screens.dart';
import 'package:app_film/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:app_film/models/movie_model.dart';
import 'package:app_film/screens/screen_details.dart';
import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app_film/widgets/card_film.dart';
import 'package:app_film/widgets/home_banner.dart';
import 'package:app_film/widgets/movie_selection.dart';
import 'package:app_film/widgets/popular_grid.dart';
import 'package:app_film/widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- VARIÁVEIS DE ESTADO E CONTROLE ---
  bool isLoading = false; // Controla o carregamento principal (tela cheia)
  bool loadMore = false; // Controla o carregamento do botão "Carregar Mais"
  int apiPage = 1; // Controla qual página da API estamos baixando
  int _currentIndex = 0; // Controla qual aba da BottomNavigationBar está ativa
  int bannerIndex = 0; // Controla a página atual do Banner (Slides)

  // --- LISTAS DE DADOS ---
  List<Movie> listaFilmes = []; // Lista geral de filmes populares
  List<Movie> filmesBusca = []; // Lista de resultados da pesquisa

  // --- CONTROLADORES ---
  late PageController _pageController; // Controla o movimento do Banner
  async_timer.Timer? _timer; // Timer para o movimento automático do Banner
  final TextEditingController _controleBusca =
      TextEditingController(); // Captura o que o usuário digita

  // --- CONFIGURAÇÕES DA API ---
  final String apiKey = "839ee2f7b3c54705b7711a9920805bf0";
  final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

  // FUNCIONALIDADE: Busca filmes por nome na API
  Future<void> searchFilmes(String query) async {
    if (query.isEmpty) {
      setState(() => filmesBusca = []);
      return;
    }

    setState(() => isLoading = true);
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=pt-BR&query=$query';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        setState(() {
          filmesBusca = results.map((e) => Movie.fromJson(e)).toList();
        });
      }
    } catch (e) {
      debugPrint("Erro na busca: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // FUNCIONALIDADE: Realiza o logout do Firebase e do Google
  Future<void> _fazerLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Erro ao sair: $e");
    }
  }

  // FUNCIONALIDADE: Busca filmes populares (Início ou Próximas Páginas)
  Future<void> fetchMovie({bool carregarProxima = false}) async {
    if (carregarProxima) {
      setState(() => loadMore = true);
      apiPage++; // Incrementa para pegar a próxima página de filmes
    } else {
      if (mounted) setState(() => isLoading = true);
      apiPage = 1; // Reseta para a primeira página no início
    }

    final url =
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=pt-BR&page=$apiPage';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];
        final novosFilmes = results.map((e) => Movie.fromJson(e)).toList();

        if (mounted) {
          setState(() {
            if (carregarProxima) {
              listaFilmes.addAll(novosFilmes); // Soma os novos aos antigos
            } else {
              listaFilmes = novosFilmes; // Substitui a lista (primeira carga)
            }
            isLoading = false;
            loadMore = false;
          });
        }
      }
    } catch (e) {
      if (mounted)
        setState(() {
          isLoading = false;
          loadMore = false;
        });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchMovie().then(
      (_) => fetchMovie(carregarProxima: true),
    ); // Busca os filmes assim que a tela abre

    // FUNCIONALIDADE: Timer para rodar o Banner sozinho a cada 4 segundos
    _timer = async_timer.Timer.periodic(const Duration(seconds: 4), (timer) {
      if (listaFilmes.isNotEmpty && _pageController.hasClients) {
        bannerIndex = (bannerIndex + 1) % (listaFilmes.length > 5 ? 5 : listaFilmes.length);
        _pageController.animateToPage(
          bannerIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // Limpeza de memória ao fechar a tela
    _timer?.cancel();
    _pageController.dispose();
    _controleBusca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LOGICA: Divide a lista única da API em subseções para organizar o design
    final listaBanner = listaFilmes.take(3).toList(); // Primeiros 5 para o Banner
    final listaLancamentos = listaFilmes.skip(3).take(7).toList(); // Próximos 10 para o horizontal
    final listaPopulares = listaFilmes.skip(10).toList(); // O restante para o Grid de baixo

    return Scaffold(
      backgroundColor: AppColors.blackColor,

      drawer: CustomDrawer(onLogout: () => _fazerLogout(context)),
      appBar: AppBar(
        toolbarHeight: 70,
        iconTheme: const IconThemeData(color: AppColors.accent),
        backgroundColor: AppColors.blackColor,
        centerTitle: true,
        title: const Text(
          "Filmes Flix",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.accent),
        ),
      ),
      body: _currentIndex == 0
          ? _buildHome(listaBanner, listaLancamentos, listaPopulares) // TELA DE INÍCIO
          : _currentIndex == 1
          ? _buildSearch() // TELA DE PESQUISA
          : const CategoriesScreen(), // TELA DE CATEGORIAS
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.blackColor,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.thirdColor,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Pesquisar"),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: "Categorias"),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES PARA ORGANIZAÇÃO DO CÓDIGO ---

  Widget _buildHome(List<Movie> banner, List<Movie> lancamentos, List<Movie> populares) {
    if (listaFilmes.isEmpty) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeBanner(movies: banner, controller: _pageController),
          MovieSection(title: "LANÇAMENTOS", movies: lancamentos),
          PopularGrid(
            movies: populares,
            isLoadingMore: loadMore,
            onLoadMore: () => fetchMovie(carregarProxima: true),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controleBusca,
            style: const TextStyle(color: Colors.white),
            onChanged: (valor) => searchFilmes(valor),
            decoration: InputDecoration(
              hintText: 'Digite o nome do filme...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.accent),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _controleBusca.text.isEmpty
                ? const Center(
                    child: Text("Pesquisar Filmes", style: TextStyle(color: Colors.white)),
                  )
                : ListView.builder(
                    itemCount: filmesBusca.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScreenDetails(movie: filmesBusca[index]),
                        ),
                      ),
                      leading: Image.network(
                        '$urlImagemBase${filmesBusca[index].posterPath}',
                        width: 50,
                        errorBuilder: (c, e, s) => const Icon(Icons.movie, color: Colors.white),
                      ),
                      title: Text(
                        filmesBusca[index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
