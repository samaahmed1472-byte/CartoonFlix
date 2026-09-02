import 'package:flutter/material.dart';

import '../services/movie_api.dart';
import '../database/movie_database.dart';

class MovieController extends ChangeNotifier {
  final MovieApi movieApi = MovieApi();

  // ==================== Movies ====================

  List<dynamic> movies = [];
  List<dynamic> filteredMovies = [];

  // ==================== My Lists ====================

  List<dynamic> favorites = [];
  List<dynamic> watchingNow = [];
  List<dynamic> watched = [];
  List<dynamic> wantToWatch = [];

  // ==================== Loading ====================

  bool isLoading = true;

  // ==================== Genres ====================

  final Map<String, int?> genres = {
    'All': null,
    'Comedy': 35,
    'Adventure': 12,
    'Family': 10751,
    'Fantasy': 14,
    'Action': 28,
    'Music': 10402,
  };

  String selectedGenre = 'All';

  // ==================== Load Movies ====================

  Future<void> loadMovies() async {
    try {
      isLoading = true;
      notifyListeners();

      // Load movies from API
      final result = await movieApi.getMovies();

      movies = result;
      filteredMovies = result;

      // Load saved user lists from Hive
      favorites = MovieDatabase.getFavorites();
      watchingNow = MovieDatabase.getWatching();
      watched = MovieDatabase.getWatched();
      wantToWatch = MovieDatabase.getWantToWatch();

      isLoading = false;

      notifyListeners();
    } catch (e) {
      isLoading = false;

      notifyListeners();

      debugPrint(e.toString());
    }
  }

  // ==================== Search ====================

  void searchMovies(String query) {
    if (query.isEmpty) {
      filteredMovies = movies;
    } else {
      filteredMovies = movies.where((movie) {
        final title = movie['title']?.toString().toLowerCase() ?? '';

        return title.contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  // ==================== Genre Filter ====================

  void filterByGenre(String genre) {
    selectedGenre = genre;

    if (genre == 'All') {
      filteredMovies = movies;
    } else {
      final genreId = genres[genre];

      filteredMovies = movies.where((movie) {
        final movieGenres = movie['genre_ids'] ?? [];

        return movieGenres.contains(genreId);
      }).toList();
    }

    notifyListeners();
  }

  // ==================== Favorite ====================

  Future<void> toggleFavorite(dynamic movie) async {
    final movieId = movie['id'];

    final index = favorites.indexWhere(
      (favorite) => favorite['id'] == movieId,
    );

    if (index != -1) {
      favorites.removeAt(index);
    } else {
      favorites.add(movie);
    }

    // Save to Hive
    await MovieDatabase.saveFavorites(favorites);

    notifyListeners();
  }

  // ==================== Watching ====================

  Future<void> toggleWatching(dynamic movie) async {
    final movieId = movie['id'];

    final index = watchingNow.indexWhere(
      (item) => item['id'] == movieId,
    );

    if (index != -1) {
      // Remove from Watching Now
      watchingNow.removeAt(index);
    } else {
      // Add to Watching Now
      watchingNow.add(movie);

      // Remove from Watched
      watched.removeWhere(
        (item) => item['id'] == movieId,
      );

      // Remove from Want To Watch
      wantToWatch.removeWhere(
        (item) => item['id'] == movieId,
      );
    }

    // Save all affected lists
    await MovieDatabase.saveWatching(watchingNow);
    await MovieDatabase.saveWatched(watched);
    await MovieDatabase.saveWantToWatch(wantToWatch);

    notifyListeners();
  }

  // ==================== Watched ====================

  Future<void> toggleWatched(dynamic movie) async {
    final movieId = movie['id'];

    final index = watched.indexWhere(
      (item) => item['id'] == movieId,
    );

    if (index != -1) {
      // Remove from Watched
      watched.removeAt(index);
    } else {
      // Add to Watched
      watched.add(movie);

      // Remove from Watching Now
      watchingNow.removeWhere(
        (item) => item['id'] == movieId,
      );

      // Remove from Want To Watch
      wantToWatch.removeWhere(
        (item) => item['id'] == movieId,
      );
    }

    // Save all affected lists
    await MovieDatabase.saveWatched(watched);
    await MovieDatabase.saveWatching(watchingNow);
    await MovieDatabase.saveWantToWatch(wantToWatch);

    notifyListeners();
  }

  // ==================== Want To Watch ====================

  Future<void> toggleWantToWatch(dynamic movie) async {
    final movieId = movie['id'];

    final index = wantToWatch.indexWhere(
      (item) => item['id'] == movieId,
    );

    if (index != -1) {
      // Remove from Want To Watch
      wantToWatch.removeAt(index);
    } else {
      // Add to Want To Watch
      wantToWatch.add(movie);

      // Remove from Watching Now
      watchingNow.removeWhere(
        (item) => item['id'] == movieId,
      );

      // Remove from Watched
      watched.removeWhere(
        (item) => item['id'] == movieId,
      );
    }

    // Save all affected lists
    await MovieDatabase.saveWantToWatch(wantToWatch);
    await MovieDatabase.saveWatching(watchingNow);
    await MovieDatabase.saveWatched(watched);

    notifyListeners();
  }

  // ==================== Check Favorite ====================

  bool isFavorite(dynamic movie) {
    final movieId = movie['id'];

    return favorites.any(
      (favorite) => favorite['id'] == movieId,
    );
  }

  // ==================== Check Watching ====================

  bool isWatching(dynamic movie) {
    final movieId = movie['id'];

    return watchingNow.any(
      (item) => item['id'] == movieId,
    );
  }

  // ==================== Check Watched ====================

  bool isWatched(dynamic movie) {
    final movieId = movie['id'];

    return watched.any(
      (item) => item['id'] == movieId,
    );
  }

  // ==================== Check Want To Watch ====================

  bool isWantToWatch(dynamic movie) {
    final movieId = movie['id'];

    return wantToWatch.any(
      (item) => item['id'] == movieId,
    );
  }
}
