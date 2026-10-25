
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/favorite_store.dart';
import '../pages/movie_detail_page.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(movieId: movie.id),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 115,
              height: 170,
              child: movie.posterUrl.isNotEmpty
                  ? Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const _PosterPlaceholder(),
                    )
                  : const _PosterPlaceholder(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(movie.releaseYear),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(movie.rating.toStringAsFixed(1)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ValueListenableBuilder<List<Movie>>(
                        valueListenable:
                            FavoriteStore.instance.favorites,
                        builder: (context, favorites, child) {
                          final isFavorite = favorites.any(
                            (item) => item.id == movie.id,
                          );

                          return IconButton(
                            tooltip: isFavorite
                                ? 'Hapus dari favorit'
                                : 'Tambah ke favorit',
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? Colors.red
                                  : null,
                            ),
                            onPressed: () {
                              FavoriteStore.instance
                                  .toggleFavorite(movie);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: const Center(
        child: Icon(
          Icons.movie,
          size: 42,
          color: Colors.white70,
        ),
      ),
    );
  }
}
