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

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((category) => category.toString())
          .toList(),
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'categories': categories,
      'imageUrl': imageUrl,
    };
  }
}
