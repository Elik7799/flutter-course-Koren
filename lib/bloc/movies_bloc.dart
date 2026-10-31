import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/movie.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(MoviesLoadInProgress()) {
    on<MoviesLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    MoviesLoadRequested event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoadInProgress());
    await emit.forEach<QuerySnapshot>(
      FirebaseFirestore.instance.collection('movies').snapshots(),
      onData: (snapshot) {
        final movies = snapshot.docs.map((doc) => Movie.fromFirestore(doc)).toList();
        return MoviesLoadSuccess(movies);
      },
      onError: (error, stackTrace) {
        return MoviesLoadFailure('Не удалось загрузить каталог');
      },
    );
  }
}