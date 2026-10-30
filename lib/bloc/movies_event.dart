part of 'movies_bloc.dart';

sealed class MoviesEvent {}

class MoviesLoadRequested extends MoviesEvent {}