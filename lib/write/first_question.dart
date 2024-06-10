import 'package:flutter/material.dart';
import 'package:flutter_java_humanbook/color.dart';
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
  final String _question = '나의 가장 무모한 도전은 무엇인가요?';
  final String _loadEndpoint = 'http://humanbook.kr/api/manuscripts/user/1'; // step을 1로 가정
  final String _saveEndpoint = 'http://humanbook.kr/api/manuscripts';
  String _titleError = '';
  String _contentError = '';

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
    setState(() {
      _titleError = '';
      _contentError = '';
    });

    if (_titleController.text.isEmpty) {
      setState(() {
        _titleError = '제목을 입력하세요';
      });
    }

    if (_contentController.text.isEmpty) {
      setState(() {
        _contentError = '내용을 입력하세요';
      });
    }

    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      return;
    }

    try {
      final cookies = Provider.of<AuthProvider>(context, listen: false).getCookies();
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
        backgroundColor: Colors.white, // 배경색 흰색
        title: Text(
          title,
          textAlign: TextAlign.center, // 제목 가운데 정렬
          style: TextStyle(
            color: Colors.black, // 제목 텍스트 색상 검은색
            fontWeight: FontWeight.bold, // 제목 볼드체
          ),
        ),
        content: Text(
          content,
          textAlign: TextAlign.center, // 내용 가운데 정렬
          style: TextStyle(
            color: Colors.black, // 내용 텍스트 색상 검은색
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                '확인',
                style: TextStyle(
                  color: COLOR_BLUE, // 버튼 텍스트 색상
                  fontWeight: FontWeight.bold, // 버튼 텍스트 볼드체
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_BLUE.withOpacity(0.9), // 헤더 색상 변경
        title: Text('첫 번째 질문', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView( // 스크롤 가능하게 변경
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                _question,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '제목을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // 둥근 외곽선 추가
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: COLOR_BLUE), // 포커스 시 외곽선 색상 변경
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _titleError.isNotEmpty ? _titleError : null,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: '내용을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // 둥근 외곽선 추가
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // 포커스 시 외곽선 색상 변경
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _contentError.isNotEmpty ? _contentError : null,
                ),
                minLines: 20,
                maxLines: 50,
              ),
              SizedBox(height: 80),
              Center(
                child: ElevatedButton(
                  onPressed: _saveAnswer,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                    textStyle: TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글게
                    ),
                    backgroundColor: COLOR_BLUE,
                  ),
                  child: Text('저장하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
