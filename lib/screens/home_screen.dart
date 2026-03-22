import 'dart:async' as async_timer; // Resolvendo o conflito do Timer
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
  // 1. SUA LISTA DE FILMES (USANDO ASSETS QUE FUNCIONAM)
  final List<Map<String, String>> myFilms = [
    {"title": "Brothers", "image": "assets/amigos.jpg"},
    {"title": "Vingadores", "image": "assets/vingadores.jpg"},
    {"title": "Interestelar", "image": "assets/interestelar.jpg"},
    {"title": "Batman", "image": "assets/batman.jpg"},
  ];

  // 2. VARIÁVEIS DE CONTROLE
  late PageController _pageController;
  int _currentPage = 0;
  async_timer.Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // 3. O MOTOR DA ANIMAÇÃO (TROCA A CADA 2 SEGUNDOS)
    _timer = async_timer.Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPage < myFilms.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
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
    _timer?.cancel(); // IMPORTANTE: Mata o timer ao sair da tela
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.thirdColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: AppColors.fifthColor,
        title: const Text(
          "Filmes Flix",
          style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold, color: AppColors.fourthColor),
        ),
        iconTheme: const IconThemeData(color: AppColors.fourthColor),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.movie, color: AppColors.secondColor, size: 37),
                title: const Text(
                  "Categorias",
                  style: TextStyle(color: AppColors.firstColor, fontSize: 33),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BANNER ANIMADO (SEMPRE COLADO NO TOPO) ---
            Stack(
              children: [
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: myFilms.length,
                    onPageChanged: (index) => _currentPage = index,
                    itemBuilder: (context, index) {
                      return Image.asset(myFilms[index]["image"]!, fit: BoxFit.cover);
                    },
                  ),
                ),
                // DEGRADÊ PARA LEITURA
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                    ),
                  ),
                ),
                // TEXTO FIXO DO DESTAQUE
                const Positioned(
                  bottom: 30,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Destaques da Semana",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        "ASSISTA AGORA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // --- ÁREA COM PADDING (18.0) ---
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filmes em Destaques",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fourthColor,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: myFilms.length,
                      itemBuilder: (context, index) {
                        final films = myFilms[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScreenDetails(film: films)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: CardFilm(
                              title: films["title"] ?? "Sem Título",
                              image: films["image"] ?? "assets/placeholder.jpg",
                            ),
                          ),
                        );
                      },
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
}
