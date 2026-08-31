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
    if (favorites.contains(movie)) {
      favorites.remove(movie);
    } else {
      favorites.add(movie);
    }

    // Save to Hive
    await MovieDatabase.saveFavorites(favorites);

    notifyListeners();
  }

  // ==================== Watching ====================

  Future<void> toggleWatching(dynamic movie) async {
    if (watchingNow.contains(movie)) {
      watchingNow.remove(movie);
    } else {
      watchingNow.add(movie);

      // Remove from Watched
      watched.remove(movie);
    }

    // Save both lists
    await MovieDatabase.saveWatching(watchingNow);
    await MovieDatabase.saveWatched(watched);

    notifyListeners();
  }

  // ==================== Watched ====================

  Future<void> toggleWatched(dynamic movie) async {
    if (watched.contains(movie)) {
      watched.remove(movie);
    } else {
      watched.add(movie);

      // Remove from Watching Now
      watchingNow.remove(movie);
    }

    // Save both lists
    await MovieDatabase.saveWatched(watched);
    await MovieDatabase.saveWatching(watchingNow);

    notifyListeners();
  }

  // ==================== Want To Watch ====================

  Future<void> toggleWantToWatch(dynamic movie) async {
    if (wantToWatch.contains(movie)) {
      wantToWatch.remove(movie);
    } else {
      wantToWatch.add(movie);
    }

    await MovieDatabase.saveWantToWatch(wantToWatch);

    notifyListeners();
  }

  bool isWantToWatch(dynamic movie) {
    return wantToWatch.contains(movie);
  }

  // ==================== Check Favorite ====================

  bool isFavorite(dynamic movie) {
    return favorites.contains(movie);
  }

  // ==================== Check Watching ====================

  bool isWatching(dynamic movie) {
    return watchingNow.contains(movie);
  }

  // ==================== Check Watched ====================

  bool isWatched(dynamic movie) {
    return watched.contains(movie);
  }
}
