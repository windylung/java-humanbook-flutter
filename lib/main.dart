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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'humanbook',
      theme: ThemeData( 
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // 기본 배경색을 흰색으로 설정
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/login_new': (context) => LoginScreenNew(),
        '/bookshelf' : (context) => BookshelfScreen(),
        '/board' : (context) => BoardScreen(),
        '/write' : (context) => WriteScreen(),
        '/write/question1' : (context) => FirstQuestionScreen(),
        '/write/question2' : (context) => SecondQuestionScreen(),
        '/write/question3' : (context) => ThirdQuestionScreen(),

      },
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(),  // 커스텀 헤더 사용
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BannerSlider(),
          ),
          BookList(uri: 'http://humanbook.kr/api/book/list'),// 책 목록을 보여주는 BookList 위젯
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
      // height: 600,  // 고정 높이 설정
      child: PageView(
        children: [
          Image.asset('assets/banner.png', fit: BoxFit.cover),
          Image.asset('assets/banner2.png', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
