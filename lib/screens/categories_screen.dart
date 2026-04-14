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
    "Todos": 0,
    "Ação": 28,
    "Aventura": 12,
    "Animação": 16,
    "Comédia": 35,
    "Crime": 80,
    "Documentário": 99,
    "Drama": 18,
    "Família": 10751,
    "Fantasia": 14,
    "Ficção": 878,
    "Guerra": 10752,
    "Mistério": 9648,
    "Romance": 10749,
    "Terror": 27,
    "Suspense": 53,
  };

  List<Movie> filmes = []; // Lista que armazena os filmes exibidos na grade
  int currentPage = 1; // Controla a página atual da paginação
  bool isLoading = false; // Indica se o app está buscando dados no momento
  int? generoSelecionado; // Armazena qual gênero o usuário clicou

  final ScrollController _scrollController = ScrollController();

  final String apiKey = "839ee2f7b3c54705b7711a9920805bf0";
  final String urlImagemBase = 'https://image.tmdb.org/t/p/w500';

  @override
  void initState() {
    super.initState();
    fetchFilmes(0, page: 1);
  }

  // 🔥 BUSCA 30 FILMES POR PÁGINA (Fazendo 2 requisições internas)
  Future<void> fetchFilmes(int generoId, {int page = 1}) async {
    setState(() {
      isLoading = true;
      generoSelecionado = generoId;
    });

    String genreParam = generoId == 0 ? "" : "&with_genres=$generoId";

    // Buscamos 3 páginas da API para ter "folga" de sobra após os filtros
    // Mude a variável urls para:
    final urls = [
      'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=pt-BR$genreParam&page=${(page * 3) - 2}',
      'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=pt-BR$genreParam&page=${(page * 3) - 1}',
      'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=pt-BR$genreParam&page=${page * 3}',
    ];

    try {
      List<Movie> listaTemporaria = [];

      for (var url in urls) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final List results = json.decode(response.body)['results'];
          listaTemporaria.addAll(results.map((e) => Movie.fromJson(e)));
        }
      }

      // 🔥 FILTRO RIGOROSO: Remove tudo que não tem capa ou título
      List<Movie> listaFiltrada = listaTemporaria
          .where(
            (movie) =>
                movie.title.isNotEmpty &&
                movie.posterPath != null &&
                movie.posterPath.toString().length > 5,
          )
          .toList();

      setState(() {
        // 🔥 O SEGREDO: Pegamos exatamente 30.
        // Se houver menos de 30 (raro com 3 páginas), pegamos o maior múltiplo de 3.
        int quantidadeFinal = (listaFiltrada.length >= 30) ? 30 : (listaFiltrada.length ~/ 3) * 3;

        filmes = listaFiltrada.take(quantidadeFinal).toList();
        currentPage = page;
      });

      // Sobe para o topo
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      debugPrint("Erro: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0,
        title: const Text(
          "Categorias",
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        // centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // CATEGORIAS FIXAS NO TOPO
            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                children: generos.entries.map((entry) {
                  final bool isSelected = generoSelecionado == entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.accent : AppColors.background,
                        foregroundColor: AppColors.whiteColor,
                        elevation: isSelected ? 5 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: isSelected
                              ? const BorderSide(color: AppColors.whiteColor, width: 1.5)
                              : BorderSide(
                                  color: isSelected ? AppColors.accent : AppColors.whiteColor,
                                  width: 1.5,
                                ),
                        ),
                      ),
                      onPressed: () => fetchFilmes(entry.value, page: 1),
                      child: Text(entry.key),
                    ),
                  );
                }).toList(),
              ),
            ),

            Expanded(
              child: isLoading && filmes.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: Colors.red))
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(12),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3 colunas fixas
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 25, // Espaço maior entre as linhas
                              childAspectRatio: 0.38, // 🔥 AJUSTE DE PREENCHIMENTO DO CARD
                            ),
                            delegate: SliverChildBuilderDelegate((context, index) {
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
                                  image: "$urlImagemBase${movie.posterPath}",
                                ),
                              );
                            }, childCount: filmes.length),
                          ),
                        ),

                        // PAGINAÇÃO (Só aparece quando chegar no final)
                        if (filmes.isNotEmpty && !isLoading)
                          SliverToBoxAdapter(child: _buildDynamicPagination()),

                        if (isLoading)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(child: CircularProgressIndicator(color: Colors.red)),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicPagination() {
    // Lógica para mostrar a janela de páginas (Sempre centrada na atual)
    int startPage = currentPage > 2 ? currentPage - 2 : 1;

    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 60),
      child: Column(
        children: [
          const Divider(color: Colors.white10, indent: 30, endIndent: 30),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Voltar para a Página 1
              if (currentPage > 1)
                IconButton(
                  icon: const Icon(Icons.first_page, color: Colors.white70, size: 28),
                  onPressed: () => fetchFilmes(generoSelecionado ?? 0, page: 1),
                ),

              // Lista de Números (Mostra 5 por vez)
              ...List.generate(5, (index) {
                int pageNumber = startPage + index;
                bool isCurrent = currentPage == pageNumber;

                return GestureDetector(
                  onTap: () => fetchFilmes(generoSelecionado ?? 0, page: pageNumber),
                  child: Container(
                    width: 42,
                    height: 42,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isCurrent ? Colors.red : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isCurrent ? Colors.white : Colors.white24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$pageNumber",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),

              // Avançar uma página
              IconButton(
                icon: const Icon(Icons.navigate_next, color: Colors.white70, size: 28),
                onPressed: () => fetchFilmes(generoSelecionado ?? 0, page: currentPage + 1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Página $currentPage", style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}
