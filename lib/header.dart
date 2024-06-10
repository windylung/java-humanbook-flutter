import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120, // 'MY PAGE' 버튼의 가로 길이 설정
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mypage'); // '/mypage'로 이동하도록 수정
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.0), // 패딩 설정
                minimumSize: Size(120, 40), // 최소 크기 설정
              ),
              child: Text(
                'MY PAGE',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // 글꼴 크기 조정
                ),
                overflow: TextOverflow.visible, // 텍스트가 넘칠 경우 생략하지 않음
                textAlign: TextAlign.center, // 텍스트 가운데 정렬
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/logo.png', // 이미지 경로 설정
              height: 50,
            ),
          ),
          Row(
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
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/join'); // '/write'로 이동하도록 수정
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
              if (!isLoggedIn)
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
                )
              else
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
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.0); // 높이를 길게 설정
}
