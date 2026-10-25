
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/favorite_store.dart';
import '../widgets/movie_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Movie>>(
      valueListenable: FavoriteStore.instance.favorites,
      builder: (context, favorites, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Film Favorit'),
          ),
          body: favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border, size: 64),
                      SizedBox(height: 12),
                      Text('Belum ada film favorit.'),
                      SizedBox(height: 4),
                      Text('Tekan ikon hati pada film pilihanmu.'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return MovieCard(movie: favorites[index]);
                  },
                ),
        );
      },
    );
  }
}
