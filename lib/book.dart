class Book {
  final String? title;
  final String? author;
  bool isLiked;
  final List<int>? cover;
  final List<int>? epubContent;

  Book({
    required this.title,
    required this.author,
    this.isLiked = false,
    this.cover,
    this.epubContent,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      isLiked: json['isLiked'] ?? false,
      cover: json['cover'] != null ? List<int>.from(json['cover']) : null,
      epubContent: json['epubContent'] != null ? List<int>.from(json['epubContent']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'isLiked': isLiked,
    'cover': cover,
    'epubContent': epubContent,
  };
}
