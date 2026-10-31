import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/entities/movie.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(MoviesLoadInProgress()) {
    on<MoviesLoadRequested>(_onLoadRequested);
    on<MovieAdded>(_onMovieAdded);
    on<MovieLikeToggled>(_onLikeToggled);
    on<MoviesSearchChanged>(_onSearchChanged);
  }

  Future<void> _onLoadRequested(
    MoviesLoadRequested event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoadInProgress());
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      final favsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          .get();
      final likedIds = favsSnapshot.docs.map((doc) => doc.id).toSet();

      await emit.forEach<QuerySnapshot>(
        FirebaseFirestore.instance.collection('movies').snapshots(),
        onData: (snapshot) {
          final movies = snapshot.docs
              .map((doc) => Movie.fromFirestore(doc))
              .toList();
          return MoviesLoadSuccess(movies, likedIds);
        },
        onError: (error, stackTrace) =>
            MoviesLoadFailure('Не удалось загрузить каталог'),
      );
    } catch (e) {
      emit(MoviesLoadFailure('Ошибка при загрузке данных'));
    }
  }

  Future<void> _onMovieAdded(
    MovieAdded event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('movies')
          .add(event.movie.toJson());
    } catch (e) {
      emit(MoviesLoadFailure('Не удалось добавить фильм'));
    }
  }

  Future<void> _onLikeToggled(
    MovieLikeToggled event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is! MoviesLoadSuccess) return;
    final currentState = state as MoviesLoadSuccess;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(event.movieId);
    final isLiked = currentState.likedMovieIds.contains(event.movieId);

    try {
      if (isLiked) {
        await favRef.delete();
        currentState.likedMovieIds.remove(event.movieId);
      } else {
        await favRef.set({'liked': true});
        currentState.likedMovieIds.add(event.movieId);
      }
      emit(currentState.copyWith(likedMovieIds: currentState.likedMovieIds));
    } catch (e) {debugPrint('Ошибка при переключении лайка: $e');}
  }

  void _onSearchChanged(MoviesSearchChanged event, Emitter<MoviesState> emit) {
    if (state is MoviesLoadSuccess) {
      final currentState = state as MoviesLoadSuccess;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }
}
