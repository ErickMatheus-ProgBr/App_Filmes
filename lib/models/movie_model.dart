class Movie {
  final int id;
  final String title;
  final String backdropPath;
  final String posterPath; // <--- ADICIONE ESTA LINHA
  final String overview;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.posterPath, // <--- ADICIONE ESTA LINHA
    required this.overview,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      posterPath: json['poster_path'] ?? '', // <--- GARANTA QUE ESTÁ ASSIM
      overview: json['overview'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}
// Por que usamos factory e Map<String, dynamic>?
// Map<String, dynamic>: O JSON é sempre um "Mapa". 
//As chaves são sempre textos (String), mas os valores 
//podem ser qualquer coisa (dynamic): números, outros 
//textos ou até listas.

// factory: É uma palavra mágica que diz: 
//"Eu não vou apenas criar um objeto novo, 
//eu vou seguir uma receita para construir 
//um objeto baseado em algo que recebi".