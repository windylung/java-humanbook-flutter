import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_list.dart';
import 'book.dart';
import 'book_detail.dart';
import 'auth_provider.dart';

class MyPage extends StatelessWidget {
  final List<Book> likedBooks;

  MyPage({required this.likedBooks});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    String userId = authProvider.userId; // AuthProvider에서 사용자 아이디를 가져옴

    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '현재 접속한 아이디: $userId', // 로그인한 사용자 아이디 출력
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '좋아요 누른 책들',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          likedBooks.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(child: Text("좋아요 누른 책이 없어요.")),
                )
              : SliverPadding(
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
                        Book book = likedBooks[index];
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: likedBooks.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
