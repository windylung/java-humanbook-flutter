import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common_dialog.dart'; // CommonDialog 클래스를 import

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _responseMessage = '';
  String? _name;
  int? _id;
  String? body;

  Future<void> login(String username, String password) async {
    final url = Uri.parse('http://humanbook.kr/api/loginProc');
    final body = {'loginId': username, 'password': password};

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      setState(() {
        this.body = response.body;
      });

      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> memberJson = jsonDecode(response.body);
          setState(() {
            _name = memberJson['name'];
            _id = memberJson['id'];
            _responseMessage = 'Login successful';
          });
        } catch (e) {
          setState(() {
            _responseMessage = 'Login successful, but failed to parse JSON.';
          });
        }
      } else {
        setState(() {
          _responseMessage = 'Login failed: ${response.body}';
        });
        showCommonDialog(context, "Login Failed", _responseMessage, "OK", false);
        // _showErrorDialog('Login Failed', _responseMessage);
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
      });
      showCommonDialog(context, "Login Failed", _responseMessage, "OK", false);
      // _showErrorDialog('Error', _responseMessage);
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => CommonDialog(
        title: title,
        content: content,
        buttonText: 'OK',
        isSuccess: false,
      ),
    );
  }

  void _handleLogin() async {
    await login(_loginIdController.text, _passwordController.text);
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
              onPressed: _handleLogin,
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            if (body != null)
              SingleChildScrollView(
                child: Text(body!),
              ),
            Text(_responseMessage),
            if (_name != null && _id != null) ...[
              Text('ID: $_id'),
              Text('Name: $_name'),
            ],
          ],
        ),
      ),
    );
  }
}
