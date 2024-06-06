import 'package:flutter/material.dart';
import 'book_list.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String _uri = 'http://humanbook.kr/api/search?type=author&keyword=test_final'; // 초기 URI 값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: CustomScrollView(
        slivers: [
          BookList(uri: _uri), // _uri 변수를 사용하여 BookList 위젯 생성
        ],
      ),
    );
  }
}
