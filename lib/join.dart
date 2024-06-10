import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class JoinScreen extends StatefulWidget {
  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  Future<void> _handleJoin() async {
    String id = _idController.text;
    String password = _passwordController.text;
    String passwordCheck = _passwordCheckController.text;
    String name = _nameController.text;

    try {
      Dio dio = Dio();
      Response response = await dio.post(
        'http://humanbook.kr/api/join',
        data: {
          'loginId': id,
          'password': password,
          'name': name,
          'paswordCheck' : passwordCheck
        },
      );

      if (response.statusCode == 200) {
        // 회원가입 성공 처리
        print('회원가입 성공');
      } else {
        // 회원가입 실패 처리
        print('회원가입 실패');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
      print('오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordCheckController,
              decoration: InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleJoin,
              child: Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}
