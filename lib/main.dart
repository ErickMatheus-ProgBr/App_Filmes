import 'package:app_film/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:app_film/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyAppFilm());
}

class MyAppFilm extends StatelessWidget {
  const MyAppFilm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {"/": (context) => const SplashScreen(), "/homeScreen": (context) => HomeScreen()},
    );
  }
}
