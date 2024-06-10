import 'package:flutter/material.dart';
import 'package:flutter_java_humanbook/board.dart';
import 'package:flutter_java_humanbook/bookshelf.dart';
import 'package:flutter_java_humanbook/login.dart';
import 'package:flutter_java_humanbook/login_new.dart';
import 'package:flutter_java_humanbook/write/first_question.dart';
import 'package:flutter_java_humanbook/get_book.dart';
import 'package:flutter_java_humanbook/write/second_question.dart';
import 'package:flutter_java_humanbook/write/third_question.dart';
import 'package:flutter_java_humanbook/write/write.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'header.dart'; // 커스텀 헤더 위젯 파일
import 'book.dart';  // Book 모델 클래스 파일
import 'book_list.dart';  // BookList 위젯 파일
import 'mypage.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MyApp(),
    ),
  );
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => HomePage(onLike: _handleLike));
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/login_new':
            return MaterialPageRoute(builder: (_) => LoginScreenNew());
          case '/bookshelf':
            return MaterialPageRoute(builder: (_) => BookshelfScreen());
          case '/board':
            return MaterialPageRoute(builder: (_) => BoardScreen());
          case '/write':
            return MaterialPageRoute(builder: (_) => WriteScreen());
          case '/write/question1':
            return MaterialPageRoute(builder: (_) => FirstQuestionScreen());
          case '/write/question2':
            return MaterialPageRoute(builder: (_) => SecondQuestionScreen());
          case '/write/question3':
            return MaterialPageRoute(builder: (_) => ThirdQuestionScreen());
          case '/write/book':
            return MaterialPageRoute(builder: (_) => GetBookScreen());
          case '/mypage':
            return MaterialPageRoute(builder: (_) => MyPage(likedBooks: likedBooks));
          default:
            return MaterialPageRoute(builder: (_) => Scaffold(
              body: Center(child: Text('Page not found')),
            ));
        }
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
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: CustomHeader(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BannerSlider(),
          ),
          if (authProvider.isLoggedIn)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '환영합니다!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
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
