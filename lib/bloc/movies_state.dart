part of 'movies_bloc.dart';

sealed class MoviesState {}

class MoviesLoadInProgress extends MoviesState {}

class MoviesLoadSuccess extends MoviesState {
  final List<Movie> movies;
  final Set<String> likedMovieIds;
  final String searchQuery;

  MoviesLoadSuccess(this.movies, this.likedMovieIds, {this.searchQuery = ''});

  List<Movie> get filteredMovies {
    if (searchQuery.isEmpty) return movies;
    return movies.where((m) => m.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  MoviesLoadSuccess copyWith({List<Movie>? movies, Set<String>? likedMovieIds, String? searchQuery}) {
    return MoviesLoadSuccess(
      movies ?? this.movies,
      likedMovieIds ?? this.likedMovieIds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MoviesLoadFailure extends MoviesState {
  final String message;
  MoviesLoadFailure(this.message);
}