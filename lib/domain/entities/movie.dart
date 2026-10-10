class Movie {
  final int id;
  final String title;
  final String subtitle;
  final List<String> categories;
  final String? description;
  final String imageUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categories,
    required this.imageUrl,
    this.description,
  });
}