class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final double rating;
  final String overview;
  final List<dynamic> genreIds;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.overview,
    required this.genreIds,
  });

  factory MovieModel.fromMap(Map<String, dynamic> movie) {
    return MovieModel(
      id: movie['id'] ?? 0,
      title: movie['title'] ?? 'No Title',
      posterPath: movie['poster_path'] ?? '',
      rating: (movie['vote_average'] ?? 0).toDouble(),
      overview: movie['overview'] ?? '',
      genreIds: movie['genre_ids'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'vote_average': rating,
      'overview': overview,
      'genre_ids': genreIds,
    };
  }
}
