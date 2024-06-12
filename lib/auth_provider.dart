import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _cookie = '';
  String _userId = ''; // 사용자 아이디를 저장할 변수 추가
  Dio dio = Dio(BaseOptions(
    baseUrl: 'http://humanbook.kr',
    extra: {'withCredentials': true},
  ));

  AuthProvider() {
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  bool get isLoggedIn => _isLoggedIn;
  String get userId => _userId;

  Future<void> login(String loginId, String password) async {
    try {
      final response = await dio.post(
        '/api/loginProc',
        data: {
          'loginId': loginId,
          'password': password,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode == 200) {
        _isLoggedIn = true;
        _userId = loginId; // 로그인 성공 시 아이디 저장
        _cookie = response.headers['set-cookie']?.join('; ') ?? '';
        notifyListeners();
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void logout() {
    _isLoggedIn = false;
    _userId = ''; // 로그아웃 시 아이디 초기화
    _cookie = '';
    notifyListeners();
  }

  String getCookies() {
    return _cookie;
  }

  void _printAuthDetails() {
    print('Logged in: $_isLoggedIn');
    print('Cookies: $_cookie');
  }
}
