import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _responseMessage = '';
  String? _name;
  int? _id;

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/login/member'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'loginId': _loginIdController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> memberJson = jsonDecode(response.body);
        setState(() {
          _name = memberJson['name'];
          _id = memberJson['id'];
          _responseMessage = 'Login successful';
        });
      } else {
        setState(() {
          _responseMessage = 'Login failed: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        print(e);
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
