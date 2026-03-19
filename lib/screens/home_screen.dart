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
  final List<Map<String, String>> myFilms = [
    {"title": "Brothers", "image": "assets/amigos.jpg"},
    {"title": "Vingadores", "image": "assets/vingadores.jpg"},
    {"title": "Interestelar", "image": "assets/interestelar.jpg"},
    {"title": "Batman", "image": "assets/batman.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Se quiser o fundo marrom que conversamos:
      // backgroundColor: const Color(0xFF3E2723),
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
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),

      body: Padding(
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

                  // O itemBuilder retorna APENAS este InkWell
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
                        title: films["title"] ?? films["titulo"] ?? "Sem Título",
                        image: films["image"] ?? films["imagem"] ?? "assets/placeholder.jpg",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
