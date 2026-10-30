import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Stream<Set<String>> get _favoritesStream {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return Stream.value({});

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }

  Future<void> _toggleLike(String movieId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(movieId);

    if (_likedIds.contains(movieId)) {
      await favRef.delete();
    } else {
      await favRef.set({'liked': true});
    }
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
                    decoration: const InputDecoration(labelText: 'Подзаголовок'),
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(labelText: 'Ссылка на постер'),
                    validator: (value) => (value == null || !value.startsWith('http')) ? 'Некорректный URL' : null,
                  ),
                  TextFormField(
                    controller: categoriesController,
                    decoration: const InputDecoration(labelText: 'Категории (через запятую)'),
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
    );

    try {
      await FirebaseFirestore.instance.collection('movies').add(newMovie.toJson());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Фильм добавлен!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог фильмов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, moviesSnapshot) {
          if (moviesSnapshot.hasError) {
            return Center(child: Text('Ошибка: ${moviesSnapshot.error}'));
          }
          if (moviesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!moviesSnapshot.hasData || moviesSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Каталог пуст. Добавьте первый фильм!'));
          }

          final movies = moviesSnapshot.data!.docs.map((doc) => Movie.fromFirestore(doc)).toList();

          return StreamBuilder<Set<String>>(
            stream: _favoritesStream,
            builder: (context, favoritesSnapshot) {
              _likedIds.clear();
              if (favoritesSnapshot.hasData) {
                _likedIds.addAll(favoritesSnapshot.data!);
              }

              final displayedMovies = _showOnlyLiked
                  ? movies.where((m) => _likedIds.contains(m.id)).toList()
                  : movies;

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
                          onChanged: (val) => setState(() => _showOnlyLiked = val),
                        ),
                      ],
                    ),
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
                        ? const Center(child: Text('Ничего не нашлось'))
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
            },
          );
        },
      ),
    );
  }
}