class Book {
  final id;
  final String? title;
  final String? author;
  bool isLiked;
  // final List<int>? cover;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.isLiked = false,

  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id : json['id'],
      title: json['title'],
      author: json['author'],
      isLiked: json['isLiked'] ?? false,
      // cover: json['cover'] != null ? List<int>.from(json['cover']) : null,

    );
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title': title,
    'author': author,
    'isLiked': isLiked,
  };
}
