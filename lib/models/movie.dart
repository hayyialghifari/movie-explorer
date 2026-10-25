
class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double rating;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      overview: json['overview'] ?? 'Sinopsis tidak tersedia.',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? '',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get posterUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return '';
    }
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get backdropUrl {
    if (backdropPath == null || backdropPath!.isEmpty) {
      return '';
    }
    return 'https://image.tmdb.org/t/p/w780$backdropPath';
  }

  String get releaseYear {
    if (releaseDate.length >= 4) {
      return releaseDate.substring(0, 4);
    }
    return 'Tahun tidak diketahui';
  }
}
