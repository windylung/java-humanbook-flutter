import 'package:flutter/material.dart';

class WriteScreen extends StatelessWidget {
  WriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HoverImage(assetPath: 'assets/card1.png', route: '/write/question1'),
            SizedBox(width: 10),
            HoverImage(assetPath: 'assets/card2.png', route: '/write/question2'),
            SizedBox(width: 10),
            HoverImage(assetPath: 'assets/card3.png', route: '/write/question3'),
          ],
        ),
      ),
    );
  }
}

class HoverImage extends StatefulWidget {
  final String assetPath;
  final String route;

  HoverImage({required this.assetPath, required this.route});

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _setHover(true),
      onExit: (event) => _setHover(false),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, widget.route);
        },
        child: AnimatedOpacity(
          opacity: _isHovering ? 1.0 : 0.4,
          duration: Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: _isHovering ? 262.5 : 250, // 5% 증가
            height: _isHovering ? 437.85 : 417, // 5% 증가
            child: Transform.scale(
              scale: _isHovering ? 1.05 : 1.0,
              child: Image.asset(widget.assetPath, fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }

  void _setHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }
}
