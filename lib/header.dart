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
      Response response = await dio.get(
        'http://humanbook.kr/api/logout',
      );

      if (response.statusCode == 200) {
        // logout 성공 처리
        print('logout 성공');
        Provider.of<AuthProvider>(context, listen: false).logout(); // 로컬 로그아웃 처리
        Navigator.pushNamed(context, '/'); // 로그아웃 후 '/'로 이동
      } else {
        // logout 실패 처리
        print('logout 실패');
      }
    } catch (e) {
      // 네트워크 오류 등 예외 처리
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
                    Navigator.pushNamed(context, '/'); // 로고 클릭 시 '/'로 이동
                  },
                  child: Image.asset(
                    'assets/logo.png', // 이미지 경로 설정
                    height: 50,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/board'); // '/board'로 이동하도록 수정
                        },
                        child: Text(
                          'BOARD',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible, // 텍스트가 사라짐 없이 보이도록 설정
                          textAlign: TextAlign.center, // 텍스트 가운데 정렬
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/bookshelf'); // '/bookshelf'로 이동하도록 수정
                        },
                        child: Text(
                          'BOOK',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible, // 텍스트가 사라짐 없이 보이도록 설정
                          textAlign: TextAlign.center, // 텍스트 가운데 정렬
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoggedIn)
                      Row(
                        children: [
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/mypage'); // '/mypage'로 이동하도록 수정
                              },
                              child: Text(
                                'MY PAGE',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible, // 텍스트가 사라짐 없이 보이도록 설정
                                textAlign: TextAlign.center, // 텍스트 가운데 정렬
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
                                overflow: TextOverflow.visible, // 텍스트가 사라짐 없이 보이도록 설정
                                textAlign: TextAlign.center, // 텍스트 가운데 정렬
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
                                Navigator.pushNamed(context, '/login_new'); // '/login'으로 이동하도록 수정
                              },
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible, // 텍스트가 사라짐 없이 보이도록 설정
                                textAlign: TextAlign.center, // 텍스트 가운데 정렬
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/join'); // '/join'으로 이동하도록 수정
                              },
                              child: Text(
                                'JOIN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible, // 텍스트가 사라짐 없이 보이도록 설정
                                textAlign: TextAlign.center, // 텍스트 가운데 정렬
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/write'); // '/write'로 이동하도록 수정
                              },
                              child: Text(
                                'WRITE',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.visible, // 텍스트가 사라짐 없이 보이도록 설정
                                textAlign: TextAlign.center, // 텍스트 가운데 정렬
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
