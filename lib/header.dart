import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {

  CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Center(
        child: Image.asset(
          'assets/logo.png',  // 이미지 경로 설정
          height: 50,
        ),
      ),
      leading: Center(
        child: TextButton(
          onPressed: () {},
          child: Text(
            'MY PAGE',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            overflow: TextOverflow.visible,  // 텍스트가 사라짐 없이 보이도록 설정
          ),
        ),
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'BOOK',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              overflow: TextOverflow.visible,  // 텍스트가 사라짐 없이 보이도록 설정
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {Navigator.pushNamed(context, '/login');},
            child: Text(
              'LOGIN',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              overflow: TextOverflow.visible,  // 텍스트가 사라짐 없이 보이도록 설정
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.0);  // 높이를 길게 설정
}
