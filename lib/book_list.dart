import 'package:flutter/material.dart';
import 'book.dart'; // Book 모델 클래스 파일
import 'book_detail.dart';
import 'package:dio/dio.dart';

class BookList extends StatefulWidget {
  final String _uri = 'http://humanbook.kr/api/book/list';
  final Function(Book)? onLike; // 추가: 좋아요 상태가 변경될 때 호출되는 콜백
  final String? uri;
  BookList({this.onLike, this.uri});

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  Future<List<Book>>? books;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    books = _fetchBooks(widget._uri);
  }

  @override
  void didUpdateWidget(BookList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uri != widget._uri) {
      books = _fetchBooks(widget._uri);
    }
  }

  Future<List<Book>> _fetchBooks(String uri) async {
    try {
      final response = await _dio.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> booksJson = response.data;
        return booksJson.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load books');
    }
  }

  void _toggleLike(Book book) {
    setState(() {
      book.isLiked = !book.isLiked;
    });
    if (widget.onLike != null) {
      widget.onLike!(book);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: books,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text("사람책이 없어요")),
          );
        } else {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 36.0,
                mainAxisSpacing: 36.0,
                childAspectRatio: 390 / 232,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  Book book = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(book: book),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.grey.shade100,
                      child: Row(
                        children: [
                          Container(
                            width: 157,
                            height: 213,
                            margin: EdgeInsets.symmetric(horizontal: 30.0),
                            child: book.id % 2 == 1? Image.asset('assets/cover.png', fit: BoxFit.cover) : Image.asset('assets/cover.png', fit: BoxFit.cover),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.title ?? 'No title',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  book.author ?? 'No author',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal
                                  ),
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                  icon: Icon(
                                    book.isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: book.isLiked ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () => _toggleLike(book),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: snapshot.data!.length,
              ),
            ),
          );
        }
      },
    );
  }
}
