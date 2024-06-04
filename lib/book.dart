class Book {
  final String? title;
  final String? author;

  Book({required this.title, required this.author});

  factory Book.fromJson(Map<String, dynamic> json){
    return Book(title: json['title'], author: json['author']);
  }

  Map<String, dynamic> toJson() => {
    'title' : title,
    'author' : author,
  };
}
