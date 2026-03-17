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
        backgroundColor: Colors.black,
        title: const Text(
          "Filmes Flix",
          style: TextStyle(
            fontSize: 31,
            fontWeight: FontWeight.bold,
            color: Colors.lightGreenAccent,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.lightGreenAccent),
      ),

      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.movie, color: Colors.lightGreenAccent, size: 37),
                title: const Text(
                  "Categorias",
                  style: TextStyle(color: Colors.lightGreenAccent, fontSize: 33),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
