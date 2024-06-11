import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  CustomHeader({Key? key}) : super(key: key);

  @override
  _CustomHeaderState createState() => _CustomHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(70.0); // 높이를 길게 설정
}

class _CustomHeaderState extends State<CustomHeader> {

  Future<void> _handleLogout() async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        'http://humanbook.kr/api/logout',
      );

      if (response.statusCode == 200) {
        print('logout 성공');
        Provider.of<AuthProvider>(context, listen: false).logout();
        Navigator.pushNamed(context, '/');
      } else {
        print('logout 실패');
      }
    } catch (e) {
      print('오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        bool isLoggedIn = authProvider.isLoggedIn;

        return AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Image.asset(
                    'assets/logo.png',
                    height: 50,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/board');
                        },
                        child: Text(
                          'BOARD',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/bookshelf');
                        },
                        child: Text(
                          'BOOK',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (isLoggedIn)
                      Row(
                        children: [
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/mypage');
                              },
                              child: Text(
                                'MY PAGE',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                _handleLogout();
                              },
                              child: Text(
                                'LOGOUT',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/write');
                              },
                              child: Text(
                                'WRITE',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login_new');
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/join');
                              },
                              child: Text(
                                'JOIN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
