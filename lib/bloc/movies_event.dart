part of 'movies_bloc.dart';

sealed class MoviesEvent {}

class MoviesLoadRequested extends MoviesEvent {}
class MovieAdded extends MoviesEvent {
  final Movie movie;
  MovieAdded(this.movie);
}
class MovieLikeToggled extends MoviesEvent {
  final String movieId;
  MovieLikeToggled(this.movieId);
}
class MoviesSearchChanged extends MoviesEvent {
  final String query;
  MoviesSearchChanged(this.query);
}