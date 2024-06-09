import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';

class FirstQuestionScreen extends StatefulWidget {
  FirstQuestionScreen({super.key});

  @override
  _FirstQuestionScreenState createState() => _FirstQuestionScreenState();
}

class _FirstQuestionScreenState extends State<FirstQuestionScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final String _question = '첫 번째 질문';
  final String _loadEndpoint = 'http://humanbook.kr/api/user/1'; // step을 1로 가정
  final String _saveEndpoint = 'http://humanbook.kr/api/manuscripts';

  @override
  void initState() {
    super.initState();
    _loadAnswer();
  }

  Future<void> _loadAnswer() async {
    try {
      final cookies = Provider.of<AuthProvider>(context, listen: false).getCookies();
      final response = await http.get(
        Uri.parse(_loadEndpoint),
        headers: {'Cookie': cookies},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _titleController.text = data['title'] ?? '';
          _contentController.text = data['content'] ?? '';
        });
      } else {
        print('Failed to load answer');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _saveAnswer() async {
    try {
      final cookies = Provider.of<AuthProvider>(context, listen: false).getCookies();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await http.put(
        Uri.parse(_saveEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': cookies,
        },
        body: jsonEncode({
          'step': 1,
          'title': _titleController.text,
          'content': _contentController.text,
        }),
      );
      if (response.statusCode == 200) {
        // 저장 성공
        _showDialog('성공', '저장 성공했습니다.', true);
      } else {
        _showDialog('실패', '저장되지 않았습니다.', false);
      }
    } catch (e) {
      print('Error: $e');
      _showDialog('오류', '저장되지 않았습니다.', false);
    }
  }

  void _showDialog(String title, String content, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isSuccess) {
                Navigator.of(context).pop();
              }
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_question, style: TextStyle(fontSize: 20)),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목을 입력하세요',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '내용을 입력하세요',
              ),
              maxLines: 10,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAnswer,
              child: Text('저장하기'),
            ),
          ],
        ),
      ),
    );
  }
}
