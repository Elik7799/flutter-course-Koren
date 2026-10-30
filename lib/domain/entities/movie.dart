import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String id;
  final String title;
  final String subtitle;
  final List<String> categories;
  final String imageUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
    required this.imageUrl,
  });

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Movie(
      id: doc.id,
      title: data['title'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      categories: (data['genres'] as List<dynamic>? ?? [])
          .map((category) => category.toString())
          .toList(),
      imageUrl: data['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'genres': categories,
      'imageUrl': imageUrl,
    };
  }
}