import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/movie_provider.dart';

import 'movie_details_screen.dart';
import 'favorites_screen.dart';
import 'want_to_watch_screen.dart';
import 'watching_screen.dart';
import 'watched_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Load movies after the screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovies();
    });
  }

  // ==================== Movie Details ====================

  void openMovieDetails(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie)),
    );
  }

  // ==================== Favorites Screen ====================

  void openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
    );
  }

  // ==================== Want To Watch Screen ====================

  void openWantToWatch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WantToWatchScreen()),
    );
  }

  // ==================== Watching Screen ====================

  void openWatching() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WatchingScreen()),
    );
  }

  // ==================== Watched Screen ====================

  void openWatched() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WatchedScreen()),
    );
  }

  // ==================== Genre Filter ====================

  void showGenreFilter() {
    final provider = context.read<MovieProvider>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),

          title: const Text(
            'Filter by Genre',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: SizedBox(
            width: 300,

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: provider.genres.keys.map((genre) {
                  final bool isSelected = provider.selectedGenre == genre;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,

                    title: Text(
                      genre,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.deepPurpleAccent
                            : Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),

                    onTap: () {
                      provider.filterByGenre(genre);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==================== Profile ====================

  void showProfile() {
    final user = FirebaseAuth.instance.currentUser;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          title: const Row(
            children: [
              Icon(Icons.person, color: Colors.deepPurpleAccent, size: 28),

              SizedBox(width: 10),

              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                'Email',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),

              const SizedBox(height: 5),

              Text(
                user?.email ?? 'No email',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },

                  icon: const Icon(Icons.logout),

                  label: const Text('Logout'),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(vertical: 13),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================== Build ====================

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF121212),

          // ==================== App Bar ====================
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,

            title: const Text(
              'Cartoon Movies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            actions: [
              // Favorites
              IconButton(
                onPressed: openFavorites,
                icon: const Icon(Icons.favorite_border, color: Colors.white),
              ),

              // Want To Watch
              IconButton(
                onPressed: openWantToWatch,
                icon: const Icon(Icons.bookmark_border, color: Colors.white),
              ),

              // Watching
              IconButton(
                onPressed: openWatching,
                icon: const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                ),
              ),

              // Watched
              IconButton(
                onPressed: openWatched,
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                ),
              ),

              // Profile
              IconButton(
                onPressed: showProfile,
                icon: const Icon(Icons.person_outline, color: Colors.white),
              ),

              const SizedBox(width: 10),
            ],
          ),

          // ==================== Body ====================
          body: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ==================== Search ====================

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: provider.searchMovies,

                        style: const TextStyle(color: Colors.white),

                        decoration: InputDecoration(
                          hintText: 'Search for a movie...',

                          hintStyle: const TextStyle(color: Colors.white54),

                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),

                          filled: true,
                          fillColor: Colors.white10,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      height: 56,
                      width: 56,

                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: IconButton(
                        onPressed: showGenreFilter,

                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ==================== Genre ====================
                Row(
                  children: [
                    const Text(
                      'Genre: ',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),

                    Text(
                      provider.selectedGenre,

                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ==================== Title ====================
                Text(
                  provider.filteredMovies.isEmpty
                      ? 'No Movies Found'
                      : 'Popular Movies',

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // ==================== Grid ====================
                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        )
                      : provider.filteredMovies.isEmpty
                      ? const Center(
                          child: Text(
                            'No movies found',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : GridView.builder(
                          itemCount: provider.filteredMovies.length,

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 18,
                                childAspectRatio: 0.68,
                              ),

                          itemBuilder: (context, index) {
                            final movie = provider.filteredMovies[index];

                            return MovieCard(
                              movie: movie,

                              isFavorite: provider.isFavorite(movie),

                              onFavorite: () {
                                provider.toggleFavorite(movie);
                              },

                              onTap: () {
                                openMovieDetails(movie);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// Movie Card
// ============================================================

class MovieCard extends StatelessWidget {
  final dynamic movie;

  final bool isFavorite;

  final VoidCallback onFavorite;

  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String title = movie['title'] ?? 'No Title';

    final String posterPath = movie['poster_path'] ?? '';

    final double rating = (movie['vote_average'] ?? 0).toDouble();

    return GestureDetector(
      onTap: onTap,

      child: Card(
        color: const Color(0xFF1E1E1E),
        elevation: 3,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================== Poster ====================

            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),

                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),

                      image: posterPath.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500$posterPath',
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),

                    child: posterPath.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.movie,
                              size: 55,
                              color: Colors.white38,
                            ),
                          )
                        : null,
                  ),

                  // ==================== Favorite ====================
                  Positioned(
                    top: 5,
                    right: 5,

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: IconButton(
                        onPressed: onFavorite,

                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,

                          color: isFavorite ? Colors.red : Colors.white,

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
                      const Icon(Icons.star, color: Colors.amber, size: 17),

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
  }
}
