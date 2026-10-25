
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String _apiKey =
      String.fromEnvironment('TMDB_API_KEY');

  static const String _baseUrl = 'https://api.themoviedb.org/3';

  void _checkApiKey() {
    if (_apiKey.isEmpty) {
      throw Exception(
        'API key belum diatur. Jalankan aplikasi dengan '
        '--dart-define=TMDB_API_KEY=API_KEY_KAMU',
      );
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    _checkApiKey();

    final uri = Uri.parse('$_baseUrl/movie/popular').replace(
      queryParameters: {
        'api_key': _apiKey,
        'language': 'id-ID',
        'page': '1',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil film. Kode: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    return results
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    _checkApiKey();

    final uri = Uri.parse('$_baseUrl/search/movie').replace(
      queryParameters: {
        'api_key': _apiKey,
        'language': 'id-ID',
        'query': query,
        'page': '1',
        'include_adult': 'false',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mencari film. Kode: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    return results
        .map((item) => Movie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Movie> getMovieDetail(int id) async {
    _checkApiKey();

    final uri = Uri.parse('$_baseUrl/movie/$id').replace(
      queryParameters: {
        'api_key': _apiKey,
        'language': 'id-ID',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil detail film. Kode: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Movie.fromJson(data);
  }
}
