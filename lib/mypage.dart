import 'package:flutter/material.dart';
import 'book_list.dart';
import 'book.dart';
import 'book_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPage extends StatefulWidget {
  final List<Book> likedBooks;

  MyPage({required this.likedBooks});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userId = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/user/profile'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        userId = data['userId'];
        userName = data['userName'];
      });
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    'ID: $userId',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Name: $userName',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '좋아요 누른 책들',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          widget.likedBooks.isEmpty
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
                        Book book = widget.likedBooks[index];
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
                      childCount: widget.likedBooks.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
