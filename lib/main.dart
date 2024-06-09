import 'package:flutter/material.dart';
import 'package:flutter_java_humanbook/board.dart';
import 'package:flutter_java_humanbook/bookshelf.dart';
import 'package:flutter_java_humanbook/login.dart';
import 'package:flutter_java_humanbook/login_new.dart';
import 'package:flutter_java_humanbook/write/first_question.dart';
import 'package:flutter_java_humanbook/write/second_question.dart';
import 'package:flutter_java_humanbook/write/third_question.dart';
import 'package:flutter_java_humanbook/write/write.dart';
import 'header.dart'; // 커스텀 헤더 위젯 파일
import 'book.dart';  // Book 모델 클래스 파일
import 'book_list.dart';  // BookList 위젯 파일
import 'mypage.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Book> likedBooks = [];

  void _handleLike(Book book) {
    setState(() {
      if (book.isLiked) {
        likedBooks.add(book);
      } else {
        likedBooks.removeWhere((b) => b.title == book.title && b.author == book.author);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'humanbook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(onLike: _handleLike),
        '/login': (context) => LoginScreen(),
        '/login_new': (context) => LoginScreenNew(),
        '/bookshelf' : (context) => BookshelfScreen(),
        '/board' : (context) => BoardScreen(),
        '/write' : (context) => WriteScreen(),
        '/write/question1' : (context) => FirstQuestionScreen(),
        '/write/question2' : (context) => SecondQuestionScreen(),
        '/write/question3' : (context) => ThirdQuestionScreen(),
      '/mypage': (context) => MyPage(likedBooks: likedBooks),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(Book) onLike;

  HomePage({required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BannerSlider(),
          ),
          BookList(uri: 'http://humanbook.kr/api/book/list', onLike: onLike),
        ],
      ),
    );
  }
}

class BannerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: PageView(
        children: [
          Image.asset('assets/banner.png', fit: BoxFit.cover),
          Image.asset('assets/banner2.png', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
