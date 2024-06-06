import 'package:flutter/material.dart';
import 'book.dart'; // Book 모델 클래스 파일
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book_detail.dart';

class BookList extends StatefulWidget {
  final String uri;

  BookList({required this.uri});

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  Future<List<Book>>? books;

  @override
  void initState() {
    super.initState();
    books = fetchBooks(widget.uri);
  }

  @override
  void didUpdateWidget(BookList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uri != widget.uri) {
      books = fetchBooks(widget.uri);
    }
  }

  Future<List<Book>> fetchBooks(String uri) async {
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      List<dynamic> booksJson = jsonDecode(response.body);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
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
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0), // 좌우 여백 설정
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 행에 3개의 카드
                crossAxisSpacing: 36.0,
                mainAxisSpacing: 36.0,
                childAspectRatio: 390 / 232, // 카드 비율
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
                      color: Colors.grey.shade100, // 배경색 설정
                      child: Row(
                        children: [
                          Container(
                            width: 157,
                            height: 213,
                            margin: EdgeInsets.symmetric(horizontal: 30.0), // 이미지와 폰트 사이의 간격 설정
                            child: Image.asset('assets/cover.png', fit: BoxFit.cover),
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
                                    fontSize: 20.0, // 폰트 크기 키우기
                                  ),
                                  softWrap: true, // 추가: 텍스트가 컨테이너를 넘어갈 때 자동으로 줄바꿈
                                  overflow: TextOverflow.ellipsis, // 추가: 긴 텍스트를 ...로 처리
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  book.author ?? 'No author',
                                  style: TextStyle(
                                      fontSize: 15.0, // 폰트 크기 키우기
                                      fontWeight: FontWeight.normal
                                  ),
                                  softWrap: true, // 추가
                                  maxLines: 1, // 추가: 최대 라인 수 설정
                                  overflow: TextOverflow.ellipsis, // 추가
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
