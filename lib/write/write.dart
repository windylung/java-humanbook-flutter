import 'package:flutter/material.dart';
import 'package:flutter_java_humanbook/color.dart';
import 'package:flutter_java_humanbook/header.dart';
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
      appBar: CustomHeader(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HoverImage(
              assetPath: 'assets/card1.png',
              route: '/write/question1',
              isVisible: steps.contains(1),
              stepRequired: 1,
              currentSteps: steps.length,
            ),
            SizedBox(width: 10),
            HoverImage(
              assetPath: 'assets/card2.png',
              route: '/write/question2',
              isVisible: steps.contains(2),
              stepRequired: 2,
              currentSteps: steps.length,
            ),
            SizedBox(width: 10),
            HoverImage(
              assetPath: 'assets/card3.png',
              route: '/write/question3',
              isVisible: steps.contains(3),
              stepRequired: 3,
              currentSteps: steps.length,
            ),
            SizedBox(width: 10),
            HoverImage(
              assetPath: 'assets/final_card.png',
              route: '/book/create',
              isVisible: steps.length >= 3,
              stepRequired: 3,
              currentSteps: steps.length,
              showStepDialog: true,
            ),
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
  final int stepRequired;
  final int currentSteps;
  final bool showStepDialog;

  HoverImage({
    required this.assetPath,
    required this.route,
    required this.isVisible,
    required this.stepRequired,
    required this.currentSteps,
    this.showStepDialog = false,
  });

  @override
  _HoverImageState createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  bool _isAnimating = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 4.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _setHover(true),
      onExit: (event) => _setHover(false),
      child: GestureDetector(
        onTap: () {
          if (widget.isVisible) {
            if (widget.route == '/write/final' && widget.currentSteps < 3) {
              _showStepDialog();
            } else if (widget.route == '/write/final') {
              _startAnimation();
            } else {
              Navigator.pushNamed(context, widget.route);
            }
          } else if (widget.route != '/write/final'){
            Navigator.pushNamed(context, widget.route);
          } else {
            _showStepDialog();
          }
        },
        child: Transform.scale(
          scale: _isAnimating ? _animation.value : (_isHovering ? 1.05 : 1.0),
          child: AnimatedOpacity(
            opacity: widget.isVisible ? (_isHovering ? 1.0 : 1.0) : 0.4,
            duration: Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: _isHovering ? 262.5 : 250, // 5% 증가
              height: _isHovering ? 437.85 : 417, // 5% 증가
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

  void _showStepDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // 배경색 흰색
        title: Text(
          '알림',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '현재 단계: ${widget.currentSteps}/3\n단계가 부족합니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '확인',
                style: TextStyle(
                  color: COLOR_BLUE,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = true;
    });
    _animationController.forward().then((_) {
      Navigator.pushNamed(context, widget.route);
      _isAnimating = false;
    });
  }
}
