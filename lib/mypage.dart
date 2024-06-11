import 'package:flutter/material.dart';
import 'book_list.dart';
import 'book.dart';
import 'book_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Book> likedBooks = []; // 좋아하는 책 목록

  String userId = ''; // 사용자 아이디
  String userName = ''; // 사용자 이름

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // 사용자 정보 가져오기
  }

  // 사용자 정보를 서버에서 가져오는 메서드
  void fetchUserProfile() async {
    // 서버 URL
    var url = Uri.parse('http://서버주소/api/user/profile');

    // 서버로 HTTP GET 요청 보내기
    var response = await http.get(url);

    // 응답 데이터 확인
    if (response.statusCode == 200) {
      // JSON 데이터 파싱
      Map<String, dynamic> userData = jsonDecode(response.body);

      // 사용자 아이디와 이름 설정
      setState(() {
        userId = userData['userId'];
        userName = userData['userName'];
      });
    } else {
      // 오류 처리
      print('Failed to load user profile');
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

