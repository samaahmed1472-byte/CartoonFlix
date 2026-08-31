import 'package:flutter/material.dart';

import '../controllers/movie_controller.dart';

class MovieProvider extends ChangeNotifier {
  final MovieController controller = MovieController();

  // ==================== Getters ====================

  List<dynamic> get movies => controller.movies;

  List<dynamic> get filteredMovies => controller.filteredMovies;

  List<dynamic> get favorites => controller.favorites;

  List<dynamic> get watchingNow => controller.watchingNow;

  List<dynamic> get watched => controller.watched;

  List<dynamic> get wantToWatch => controller.wantToWatch;

  bool get isLoading => controller.isLoading;

  Map<String, int?> get genres => controller.genres;

  String get selectedGenre => controller.selectedGenre;

  // ==================== Load Movies ====================

  Future<void> loadMovies() async {
    await controller.loadMovies();
    notifyListeners();
  }

  // ==================== Search ====================

  void searchMovies(String query) {
    controller.searchMovies(query);
    notifyListeners();
  }

  // ==================== Genre Filter ====================

  void filterByGenre(String genre) {
    controller.filterByGenre(genre);
    notifyListeners();
  }

  // ==================== Favorite ====================

  void toggleFavorite(dynamic movie) {
    controller.toggleFavorite(movie);
    notifyListeners();
  }

  // ==================== Watching ====================

  void toggleWatching(dynamic movie) {
    controller.toggleWatching(movie);
    notifyListeners();
  }

  // ==================== Watched ====================

  void toggleWatched(dynamic movie) {
    controller.toggleWatched(movie);
    notifyListeners();
  }

  // ==================== Want To Watch ====================

  void toggleWantToWatch(dynamic movie) {
    controller.toggleWantToWatch(movie);
    notifyListeners();
  }

  bool isWantToWatch(dynamic movie) {
    return controller.isWantToWatch(movie);
  }

  // ==================== Check Status ====================

  bool isFavorite(dynamic movie) {
    return controller.isFavorite(movie);
  }

  bool isWatching(dynamic movie) {
    return controller.isWatching(movie);
  }

  bool isWatched(dynamic movie) {
    return controller.isWatched(movie);
  }
}
