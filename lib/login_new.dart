import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class LoginScreenNew extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenNew> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _responseMessage = '';

    void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // 배경색 흰색
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '확인',
                style: TextStyle(
                  color: COLOR_BLUE,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
        _loginIdController.text,
        _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      _showDialog('오류', '로그인에 실패했습니다.');
      setState(() {
        _responseMessage = 'Error: $e';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _loginIdController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Login ID',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            if (_responseMessage.isNotEmpty)
              Text(
                _responseMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
