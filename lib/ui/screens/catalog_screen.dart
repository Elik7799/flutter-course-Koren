import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/movie.dart';
import '../widgets/movie_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const String _url =
      'https://6ad371f059dd78397bbbb682.mockapi.io/movies';

  List<Movie> _movies = [];
  final Set<String> _likedIds = {};

  bool _showOnlyLiked = false;
  bool _isLoading = true;
  bool _isAdding = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode != 200) {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }

      final List<dynamic> data = jsonDecode(response.body);

      final movies = data.map((item) {
        return Movie.fromJson(item as Map<String, dynamic>);
      }).toList();

      if (!mounted) return;

      setState(() {
        _movies = movies;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = 'Не удалось загрузить фильмы.\nПроверь соединение.';
        _isLoading = false;
      });
    }
  }

  void _toggleLike(String id) {
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('У фильма отсутствует ID на сервере')),
      );
      return;
    }

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
                    decoration: const InputDecoration(
                      labelText: 'Название фильма',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите название';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: subtitleController,
                    decoration: const InputDecoration(
                      labelText: 'Подзаголовок',
                      hintText: 'Например, MARVEL - 2026',
                    ),
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'Ссылка на постер',
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Введите ссылку на постер';
                      }
                      final uri = Uri.tryParse(text);
                      if (uri == null ||
                          !uri.hasScheme ||
                          !(uri.scheme == 'http' || uri.scheme == 'https')) {
                        return 'Введите корректный URL';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: categoriesController,
                    decoration: const InputDecoration(
                      labelText: 'Категории через запятую',
                      hintText: 'Фантастика, Боевик',
                    ),
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
    setState(() {
      _isAdding = true;
    });

    try {
      final categories = (data['categories'] ?? '')
          .split(',')
          .map((category) => category.trim())
          .where((category) => category.isNotEmpty)
          .toList();

      final newMovie = Movie(
        id: '',
        title: data['title']!,
        subtitle: data['subtitle'] ?? '',
        categories: categories,
        imageUrl: data['imageUrl']!,
      );

      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(newMovie.toJson()),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }

      final createdMovie = Movie.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );

      if (!mounted) return;

      setState(() {
        _movies.insert(0, createdMovie);
        _isAdding = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Фильм добавлен!')));
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isAdding = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Не удалось добавить фильм: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedMovies = _showOnlyLiked
        ? _movies.where((movie) => _likedIds.contains(movie.id)).toList()
        : _movies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог фильмов'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                'В избранном: ${_likedIds.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: _isLoading ? null : _loadMovies,
            tooltip: 'Обновить каталог',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Только избранные', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _showOnlyLiked,
                  onChanged: (value) {
                    setState(() {
                      _showOnlyLiked = value;
                    });
                  },
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_error!, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _loadMovies,
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  )
                : displayedMovies.isEmpty
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
      ),
    );
  }
}
