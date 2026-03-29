class Movie {
  final String title;
  final String posterPath;
  final String backdropPath;
  final String overview;
  final double voteAverage;

  Movie({
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      overview: json['overview'] ?? 'Sinopse não disponível.',
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