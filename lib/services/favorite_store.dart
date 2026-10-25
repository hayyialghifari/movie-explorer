
import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class FavoriteStore {
  FavoriteStore._();

  static final FavoriteStore instance = FavoriteStore._();

  final ValueNotifier<List<Movie>> favorites =
      ValueNotifier<List<Movie>>([]);

  bool isFavorite(int movieId) {
    return favorites.value.any((movie) => movie.id == movieId);
  }

  void toggleFavorite(Movie movie) {
    final currentFavorites = List<Movie>.from(favorites.value);

    if (isFavorite(movie.id)) {
      currentFavorites.removeWhere((item) => item.id == movie.id);
    } else {
      currentFavorites.add(movie);
    }

    favorites.value = currentFavorites;
  }
}
