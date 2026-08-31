import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import 'movie_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        final favorites = provider.favorites;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),

          // ==================== App Bar ====================
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,

            title: const Text(
              'Favorites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // ==================== Body ====================
          body: favorites.isEmpty
              ? const Center(
                  child: Text(
                    'No favorite movies yet',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),

                  itemCount: favorites.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.68,
                  ),

                  itemBuilder: (context, index) {
                    final movie = favorites[index];

                    final String title = movie['title'] ?? 'No Title';

                    final String posterPath = movie['poster_path'] ?? '';

                    final double rating = (movie['vote_average'] ?? 0)
                        .toDouble();

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },

                      child: Card(
                        color: const Color(0xFF1E1E1E),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // ==================== Poster ====================

                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),

                                    child: posterPath.isNotEmpty
                                        ? Image.network(
                                            'https://image.tmdb.org/t/p/w500$posterPath',

                                            width: double.infinity,

                                            height: double.infinity,

                                            fit: BoxFit.cover,
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.movie,
                                              color: Colors.white38,
                                              size: 50,
                                            ),
                                          ),
                                  ),

                                  // ==================== Remove Favorite ====================
                                  Positioned(
                                    top: 5,
                                    right: 5,

                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      child: IconButton(
                                        onPressed: () {
                                          provider.toggleFavorite(movie);
                                        },

                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ==================== Movie Info ====================
                            Padding(
                              padding: const EdgeInsets.all(8),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    title,

                                    maxLines: 1,

                                    overflow: TextOverflow.ellipsis,

                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 17,
                                      ),

                                      const SizedBox(width: 4),

                                      Text(
                                        rating.toStringAsFixed(1),

                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
