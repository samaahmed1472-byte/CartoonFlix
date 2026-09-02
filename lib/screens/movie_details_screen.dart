import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';

class MovieDetailsScreen extends StatelessWidget {
  final dynamic movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        final String title = movie['title'] ?? 'No Title';

        final String posterPath = movie['poster_path'] ?? '';

        final String overview =
            movie['overview'] ?? 'No description available.';

        final double rating = (movie['vote_average'] ?? 0).toDouble();

        final bool isFavorite = provider.isFavorite(movie);

        final bool isWantToWatch = provider.isWantToWatch(movie);

        final bool isWatching = provider.isWatching(movie);

        final bool isWatched = provider.isWatched(movie);

        return Scaffold(
          backgroundColor: const Color(0xFF121212),

          // ==================== App Bar ====================
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),

            elevation: 0,

            title: const Text(
              'Movie Details',

              style: TextStyle(color: Colors.white),
            ),

            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // ==================== Body ====================
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ==================== Poster ====================

                if (posterPath.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),

                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500$posterPath',

                        height: 400,
                        width: 270,

                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                const SizedBox(height: 25),

                // ==================== Title ====================
                Text(
                  title,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // ==================== Rating ====================
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),

                    const SizedBox(width: 6),

                    Text(
                      rating.toStringAsFixed(1),

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      '/ 10',

                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ==================== Overview ====================
                const Text(
                  'Overview',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  overview,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // ====================================================
                // Movie Actions
                // ====================================================
                Column(
                  children: [
                    // ==================== First Row ====================

                    Row(
                      children: [
                        // ==================== Favorite ====================

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              provider.toggleFavorite(movie);
                            },

                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),

                            label: Text(isFavorite ? 'Favorited' : 'Favorite'),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,

                              foregroundColor: Colors.white,

                              padding: const EdgeInsets.symmetric(vertical: 14),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // ==================== Want To Watch ====================
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              provider.toggleWantToWatch(movie);
                            },

                            icon: Icon(
                              isWantToWatch
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                            ),

                            label: Text(
                              isWantToWatch ? 'Want to Watch' : 'Want to Watch',
                            ),

                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,

                              side: const BorderSide(color: Colors.deepPurple),

                              padding: const EdgeInsets.symmetric(vertical: 14),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ==================== Second Row ====================
                    Row(
                      children: [
                        // ==================== Watching ====================

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              provider.toggleWatching(movie);
                            },

                            icon: Icon(
                              isWatching
                                  ? Icons.play_circle
                                  : Icons.play_circle_outline,
                            ),

                            label: Text(isWatching ? 'Watching' : 'Watch Now'),

                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,

                              side: const BorderSide(color: Colors.deepPurple),

                              padding: const EdgeInsets.symmetric(vertical: 14),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // ==================== Watched ====================
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              provider.toggleWatched(movie);
                            },

                            icon: Icon(
                              isWatched
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                            ),

                            label: Text(
                              isWatched ? 'Watched' : 'Mark as Watched',
                            ),

                            style: OutlinedButton.styleFrom(
                              foregroundColor: isWatched
                                  ? Colors.green
                                  : Colors.white,

                              side: BorderSide(
                                color: isWatched
                                    ? Colors.green
                                    : Colors.deepPurple,
                              ),

                              padding: const EdgeInsets.symmetric(vertical: 14),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
