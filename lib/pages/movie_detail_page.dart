
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/favorite_store.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MovieService _service = MovieService();
  late Future<Movie> _movieFuture;

  @override
  void initState() {
    super.initState();
    _movieFuture = _service.getMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Film'),
      ),
      body: FutureBuilder<Movie>(
        future: _movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat detail film.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _movieFuture =
                              _service.getMovieDetail(widget.movieId);
                        });
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final movie = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (movie.backdropUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    movie.backdropUrl,
                    height: 210,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 150,
                      child: Center(
                        child: Icon(Icons.movie, size: 60),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 6),
                  Text(movie.releaseYear),
                  const SizedBox(width: 16),
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(movie.rating.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Sinopsis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.overview,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<List<Movie>>(
                valueListenable: FavoriteStore.instance.favorites,
                builder: (context, favorites, child) {
                  final isFavorite = favorites.any(
                    (item) => item.id == movie.id,
                  );

                  return ElevatedButton.icon(
                    onPressed: () {
                      FavoriteStore.instance.toggleFavorite(movie);
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      isFavorite
                          ? 'Hapus dari Favorit'
                          : 'Tambah ke Favorit',
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
