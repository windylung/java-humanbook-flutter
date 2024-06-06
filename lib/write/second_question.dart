import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecondQuestionScreen extends StatefulWidget {
  SecondQuestionScreen({super.key});

  @override
  _SecondQuestionScreenState createState() => _SecondQuestionScreenState();
}

class _SecondQuestionScreenState extends State<SecondQuestionScreen> {
  TextEditingController _controller = TextEditingController();
  final String _question = '두 번째 질문';
  final String _endpoint = 'http://yourserver.com/api/question2';

  @override
  void initState() {
    super.initState();
    _loadAnswer();
  }

  Future<void> _loadAnswer() async {
    final response = await http.get(Uri.parse(_endpoint));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _controller.text = data['answer'] ?? '';
      });
    } else {
      print('Failed to load answer');
    }
  }

  Future<void> _saveAnswer() async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'answer': _controller.text}),
    );
    if (response.statusCode == 200) {
      // 저장 성공
    } else {
      print('Failed to save answer');
    }
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
              controller: _controller,
              decoration: InputDecoration(
                labelText: '답을 입력하세요',
              ),
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
