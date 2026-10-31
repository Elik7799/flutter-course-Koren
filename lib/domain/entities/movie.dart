import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String title;
  final String subtitle;
  final List<String> categories;
  final String imageUrl;
  final String description;

  const Movie({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
    required this.imageUrl,
    required this.description,
  });

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>? ?? {};
    return Movie(
      id: doc.id,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      categories: (json['genres'] as List<dynamic>? ?? []).map((c) => c.toString()).toList(),
      imageUrl: json['imageUrl'] as String? ?? '',
      description: json['description'] as String? ?? 'Описание пока отсутствует.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'genres': categories,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}