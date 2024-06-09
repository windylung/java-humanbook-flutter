import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class LoginScreenNew extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenNew> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _responseMessage = '';
  String? _name;
  int? _id;
  Dio dio = Dio();
  var cookieJar = CookieJar();

  @override
  void initState() {
    super.initState();
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<void> _login() async {
    try {
      final response = await dio.post(
        'http://humanbook.kr/api/loginProc',
        data: {
          'loginId': _loginIdController.text,
          'password': _passwordController.text,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      setState(() {
        if (response.statusCode == 200) {
          try {
            Map<String, dynamic> memberJson = response.data;
            _name = memberJson['name'];
            _id = memberJson['id'];
            _responseMessage = 'Login successful';
          } catch (e) {
            _responseMessage = 'Login successful, but failed to parse JSON.';
          }
        } else {
          _responseMessage = 'Login failed: ${response.data}';
        }
      });
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
      });
    }
  }

  Future<void> _getUserDetails() async {
    try {
      final response = await dio.get(
        'http://humanbook.kr/api/user/mypage',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseMessage = 'User details: ${response.data}';
        });
      } else {
        setState(() {
          _responseMessage = 'Failed to get user details: ${response.data}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error: $e';
      });
    }
  }

  Future<void> _getUserName() async {
    try {
      final response = await dio.get(
        'http://humanbook.kr/api/user/mypage2',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseMessage = 'User name: ${response.data}';
        });
      } else {
        setState(() {
          _responseMessage = 'Failed to get user name: ${response.data}';
        });
      }
    } catch (e) {
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
            ElevatedButton(
              onPressed: _getUserDetails,
              child: Text('Get User Details'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getUserName,
              child: Text('Get User Name'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_responseMessage),
              ),
            ),
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
