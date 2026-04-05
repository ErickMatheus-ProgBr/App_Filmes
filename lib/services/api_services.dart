import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_film/models/movie_model.dart';

class ApiService {
  static const String apiKey = "SUA_API_KEY";

  static Future<List<Movie>> getActionMovies(int page) async {
    final url =
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=28&page=$page";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar filmes");
    }
  }

  // ADICIONE ESTAS NOVAS LINHAS ABAIXO
  static Future<List<Movie>> getPopularMovies(int page) async {
    final url = "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&page=$page";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao carregar filmes populares");
    }
  }
}
