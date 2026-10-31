part of 'movies_bloc.dart';

sealed class MoviesState {}

class MoviesLoadInProgress extends MoviesState {}

class MoviesLoadSuccess extends MoviesState {
  final List<Movie> movies;
  MoviesLoadSuccess(this.movies);
}

class MoviesLoadFailure extends MoviesState {
  final String message;
  MoviesLoadFailure(this.message);
}