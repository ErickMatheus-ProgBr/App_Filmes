import 'package:app_film/thema/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text(
              "Filmes em Destaques",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.fourthColor,
              ),
            ),

            SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(12.0),
                      child: Image.asset(
                        "assets/amigos.jpg",
                        width: 105,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(width: 14.0),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BROTHERS",
                            style: TextStyle(
                              color: AppColors.fourthColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 13.0),
                          Text(
                            "Brothers tells the story of a reformed criminal (Josh Brolin) whose attempt at going straight is derailed when he reunites with his sanity-testing twin brother (Peter Dinklage) on a cross-country road trip for the score of a lifetime. Dodging bullets, the law, and an overbearing mother along the way, they must heal their severed family bond before they end up killing each other.",
                            style: TextStyle(color: Colors.black54),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
