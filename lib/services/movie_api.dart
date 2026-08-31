import 'dart:convert';

import 'package:http/http.dart' as http;

class MovieApi {
  final String apiKey = '5b6dec430be13f9079300227748211cf';

  Future<List<dynamic>> getMovies() async {
    List<dynamic> allMovies = [];

    // Get 4 pages = up to 80 movies
    for (int page = 1; page <= 4; page++) {
      final url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie'
        '?api_key=$apiKey'
        '&with_genres=16'
        '&sort_by=popularity.desc'
        '&page=$page',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> movies = data['results'];

        allMovies.addAll(movies);
      } else {
        throw Exception('Failed to load movies');
      }
    }

    return allMovies;
  }
}
