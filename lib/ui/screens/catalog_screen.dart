import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../bloc/movies_bloc.dart';
import '../../domain/entities/movie.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool _showOnlyLiked = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _showAddMovieDialog() async {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final imageController = TextEditingController();
    final categoriesController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final movieData = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Добавить фильм'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Название *'),
                  validator: (v) => v!.isEmpty ? 'Обязательно' : null,
                ),
                TextFormField(
                  controller: subtitleController,
                  decoration: const InputDecoration(labelText: 'Подзаголовок'),
                ),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Ссылка на постер',
                  ),
                  validator: (v) =>
                      !v!.startsWith('http') ? 'Некорректный URL' : null,
                ),
                TextFormField(
                  controller: categoriesController,
                  decoration: const InputDecoration(
                    labelText: 'Категории (через запятую)',
                  ),
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, {
                  'title': titleController.text.trim(),
                  'subtitle': subtitleController.text.trim(),
                  'imageUrl': imageController.text.trim(),
                  'categories': categoriesController.text.trim(),
                  'description': descController.text.trim(),
                });
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );

    if (movieData != null && mounted) {
      final categories = (movieData['categories'] ?? '')
          .split(',')
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList();
      final newMovie = Movie(
        id: '',
        title: movieData['title']!,
        subtitle: movieData['subtitle'] ?? '',
        categories: categories,
        imageUrl: movieData['imageUrl']!,
        description: movieData['description'] ?? '',
      );
      context.read<MoviesBloc>().add(MovieAdded(newMovie));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoadInProgress)
            return const Center(child: CircularProgressIndicator());
          if (state is MoviesLoadFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<MoviesBloc>().add(MoviesLoadRequested()),
                    child: const Text('Обновить'),
                  ),
                ],
              ),
            );
          }

          if (state is MoviesLoadSuccess) {
            final baseMovies = state.filteredMovies;
            final displayedMovies = _showOnlyLiked
                ? baseMovies
                      .where((m) => state.likedMovieIds.contains(m.id))
                      .toList()
                : baseMovies;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Поиск по названию',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => context.read<MoviesBloc>().add(
                      MoviesSearchChanged(val),
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text('Только избранные'),
                  value: _showOnlyLiked,
                  onChanged: (val) => setState(() => _showOnlyLiked = val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _showAddMovieDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить фильм'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: displayedMovies.isEmpty
                      ? Center(
                          child: Text(
                            _showOnlyLiked
                                ? 'В избранном пока пусто'
                                : 'Ничего не найдено',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: displayedMovies.length,
                          itemBuilder: (context, index) {
                            final movie = displayedMovies[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: // В catalog_screen.dart
                              GestureDetector(
                                onTap: () {
                                  // Передаем текущий BLoC экрану деталей
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (navContext) =>
                                          BlocProvider.value(
                                            value: context.read<MoviesBloc>(),
                                            child: MovieDetailsScreen(
                                              movie: movie,
                                            ),
                                          ),
                                    ),
                                  );
                                },
                                child: MovieCard(
                                  movie: movie,
                                  isLiked: state.likedMovieIds.contains(
                                    movie.id,
                                  ),
                                  onLikeTap: () => context
                                      .read<MoviesBloc>()
                                      .add(MovieLikeToggled(movie.id)),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
