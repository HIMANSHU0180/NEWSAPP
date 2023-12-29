class Article {
  final String title;
  final String description;
  final String? urlToImage;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'],
    );
  }

  @override
  String toString() {
    return 'Article{title: $title, description: $description, urlToImage: $urlToImage}';
  }
}
