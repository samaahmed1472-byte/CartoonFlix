import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import 'movie_details_screen.dart';

class WatchingScreen extends StatelessWidget {
  const WatchingScreen({super.key});

  // ==================== Movie Details ====================

  void openMovieDetails(BuildContext context, dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        final watchingMovies = provider.watchingNow;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),

          // ==================== App Bar ====================
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,

            title: const Text(
              'Watching Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // ==================== Body ====================
          body: watchingMovies.isEmpty
              ? const Center(
                  child: Text(
                    'No movies in Watching Now',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),

                  itemCount: watchingMovies.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.68,
                  ),

                  itemBuilder: (context, index) {
                    final movie = watchingMovies[index];

                    final String title = movie['title'] ?? 'No Title';

                    final String posterPath = movie['poster_path'] ?? '';

                    final double rating = (movie['vote_average'] ?? 0)
                        .toDouble();

                    return GestureDetector(
                      onTap: () {
                        openMovieDetails(context, movie);
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

                                  // ==================== Remove Watching ====================
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
                                          provider.toggleWatching(movie);
                                        },

                                        icon: const Icon(
                                          Icons.play_circle,
                                          color: Colors.deepPurpleAccent,
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
