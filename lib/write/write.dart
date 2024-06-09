import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';

class WriteScreen extends StatefulWidget {
  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  List<int> steps = [];

  @override
  void initState() {
    super.initState();
    _fetchManuscriptData();
  }

  Future<void> _fetchManuscriptData() async {
    try {
      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.get('http://humanbook.kr/api/manuscripts/user');
      if (response.statusCode == 200) {
        setState(() {
          steps = List<int>.from(response.data.map((manuscript) => manuscript['step']));
          print(response.data);
          print(steps);
        });
      } else {
        throw Exception('Failed to load manuscripts');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HoverImage(assetPath: 'assets/card1.png', route: '/write/question1', isVisible: steps.contains(1)),
            SizedBox(width: 10),
            HoverImage(assetPath: 'assets/card2.png', route: '/write/question2', isVisible: steps.contains(2)),
            SizedBox(width: 10),
            HoverImage(assetPath: 'assets/card3.png', route: '/write/question3', isVisible: steps.contains(3)),
          ],
        ),
      ),
    );
  }
}

class HoverImage extends StatefulWidget {
  final String assetPath;
  final String route;
  final bool isVisible;

  HoverImage({required this.assetPath, required this.route, required this.isVisible});

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
          opacity: widget.isVisible ? (_isHovering ? 1.0 : 1.0) : 0.4,
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
