class Book {
  final String? title;
  final String? author;
  bool isLiked;

  Book({required this.title, required this.author, this.isLiked = false});

  factory Book.fromJson(Map<String, dynamic> json){
    return Book(
      title: json['title'], 
      author: json['author'],
      isLiked: json['isLiked'] ?? false,
      );
  }

  Map<String, dynamic> toJson() => {
    'title' : title,
    'author' : author,
    'isLiked' : isLiked,
  };
}
