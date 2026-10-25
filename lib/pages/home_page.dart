
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieService _service = MovieService();
  final TextEditingController _searchController =
      TextEditingController();

  late Future<List<Movie>> _moviesFuture;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _service.getPopularMovies();
  }

  void _searchMovies(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _isSearching = false;
        _moviesFuture = _service.getPopularMovies();
      } else {
        _isSearching = true;
        _moviesFuture = _service.searchMovies(query.trim());
      }
    });
  }

  void _resetMovies() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _moviesFuture = _service.getPopularMovies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie Explorer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Film Favorit',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _searchMovies,
              decoration: InputDecoration(
                hintText: 'Cari judul film...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: 'Cari',
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    _searchMovies(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isSearching ? 'Hasil Pencarian' : 'Film Populer',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_isSearching)
                  TextButton.icon(
                    onPressed: _resetMovies,
                    icon: const Icon(Icons.close),
                    label: const Text('Reset'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _moviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Film gagal dimuat.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _moviesFuture = _isSearching
                                    ? _service.searchMovies(
                                        _searchController.text.trim(),
                                      )
                                    : _service.getPopularMovies();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final movies = snapshot.data ?? [];

                if (movies.isEmpty) {
                  return const Center(
                    child: Text('Film tidak ditemukan.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(movie: movies[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
