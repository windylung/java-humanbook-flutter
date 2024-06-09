import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class AuthProvider with ChangeNotifier {
  Dio _dio;
  bool _isLoggedIn = false;
  CookieJar _cookieJar = CookieJar();

  AuthProvider() : _dio = Dio(BaseOptions(
    baseUrl: 'http://humanbook.kr',
    extra: {'withCredentials': true},
  )) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Dio get dio => _dio;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String loginId, String password) async {
    try {
      final response = await _dio.post('/api/loginProc',
          data: {'loginId': loginId, 'password': password},
          options: Options(contentType: Headers.formUrlEncodedContentType));
      if (response.statusCode == 200) {
        _isLoggedIn = true;
        notifyListeners();
        _printAuthDetails();  // 로그인 성공 후 디테일 출력
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    // 로그아웃 로직
    _isLoggedIn = false;
    notifyListeners();
    _printAuthDetails();  // 로그아웃 후 디테일 출력
  }

  void _printAuthDetails() async {
    print('Logged in: $_isLoggedIn');
    final cookies = await _cookieJar.loadForRequest(Uri.parse('http://humanbook.kr'));
    print('Cookies: $cookies');
  }
}
