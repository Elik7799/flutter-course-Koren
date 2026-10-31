import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/movies_bloc.dart';
import '../../domain/entities/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(movie.imageUrl, height: 300, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(movie.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                BlocBuilder<MoviesBloc, MoviesState>(
                  builder: (context, state) {
                    final isLiked = state is MoviesLoadSuccess && state.likedMovieIds.contains(movie.id);
                    return IconButton(
                      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red, size: 32),
                      onPressed: () => context.read<MoviesBloc>().add(MovieLikeToggled(movie.id)),
                    );
                  },
                ),
              ],
            ),
            Text(movie.subtitle, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: movie.categories.map((c) => Chip(label: Text(c))).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Описание', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(movie.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}