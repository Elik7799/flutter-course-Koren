import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../bloc/movies_bloc.dart';
import '../../domain/entities/movie.dart';
import '../widgets/movie_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final Set<String> _likedIds = {};
  bool _showOnlyLiked = false;
  bool _isAdding = false;

  void _toggleLike(String id) {
    if (id.isEmpty) return;
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
  }

  Future<void> _showAddMovieDialog() async {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final imageController = TextEditingController();
    final categoriesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final movieData = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Добавить фильм'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Название фильма'),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Введите название' : null,
                  ),
                  TextFormField(
                    controller: subtitleController,
                    decoration: const InputDecoration(labelText: 'Подзаголовок', hintText: 'MARVEL - 2026'),
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: 'Ссылка на постер'),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return 'Введите ссылку';
                      final uri = Uri.tryParse(text);
                      if (uri == null || !uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https')) {
                        return 'Введите корректный URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: categoriesController,
                    decoration: const InputDecoration(labelText: 'Категории через запятую'),
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
                  });
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );

    if (movieData == null || !mounted) return;
    await _addMovie(movieData);
  }

  Future<void> _addMovie(Map<String, String> data) async {
    setState(() => _isAdding = true);
    try {
      final categories = (data['categories'] ?? '')
          .split(',')
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList();
          
      final newMovie = Movie(
        id: '',
        title: data['title']!,
        subtitle: data['subtitle'] ?? '',
        categories: categories,
        imageUrl: data['imageUrl']!,
      );

      await FirebaseFirestore.instance.collection('movies').add(newMovie.toJson());
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Фильм добавлен!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не удалось добавить фильм: $e')));
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог фильмов'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                'В избранном: ${_likedIds.length}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoviesLoadFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.read<MoviesBloc>().add(MoviesLoadRequested()),
                      child: const Text('Обновить'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is MoviesLoadSuccess) {
            final allMovies = state.movies;
            final displayedMovies = _showOnlyLiked
                ? allMovies.where((movie) => _likedIds.contains(movie.id)).toList()
                : allMovies;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Только избранные', style: TextStyle(fontSize: 16)),
                      Switch(
                        value: _showOnlyLiked,
                        onChanged: (value) => setState(() => _showOnlyLiked = value),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isAdding ? null : _showAddMovieDialog,
                      icon: const Icon(Icons.add),
                      label: Text(_isAdding ? 'Добавление...' : 'Добавить фильм'),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: displayedMovies.isEmpty
                      ? const Center(
                          child: Text(
                            'Ничего не нашлось',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: displayedMovies.length,
                          itemBuilder: (context, index) {
                            final movie = displayedMovies[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: MovieCard(
                                movie: movie,
                                isLiked: _likedIds.contains(movie.id),
                                onLikeTap: () => _toggleLike(movie.id),
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