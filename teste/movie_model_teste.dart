import 'package:flutter_test/flutter_test.dart';
import 'package:app_film/models/movie_model.dart'; // Ajuste o caminho conforme seu projeto

void main() {
  // O 'group' organiza vários testes relacionados
  group('Teste do Modelo de Filme', () {
    test('Deve converter um JSON corretamente para um objeto Movie', () {
      // 1. Simula um JSON vindo da API
      final Map<String, dynamic> jsonSimulado = {
        'title': 'Super Mario Bros',
        'poster_path': '/mario.jpg',
        'id': 123,
        'overview': 'Uma aventura no reino do cogumelo.',
      };

      // 2. Executa a função que queremos testar
      final movie = Movie.fromJson(jsonSimulado);

      // 3. Verifica se o resultado é o esperado (Expectativas)
      expect(movie.title, 'Super Mario Bros');
      expect(movie.posterPath, '/mario.jpg');
      // Adicione outros campos que sua Model possua
    });

    test('Deve tratar campos nulos se a API falhar', () {
      final Map<String, dynamic> jsonComErro = {'title': '', 'poster_path': null};

      final movie = Movie.fromJson(jsonComErro);

      // Aqui testamos se sua lógica de segurança (null safety) funciona
      expect(movie.posterPath, isNull);
    });
  });
}
