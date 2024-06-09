import 'package:flutter/material.dart';
import 'package:flutter_java_humanbook/board_detail.dart';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';
import 'package:dio/dio.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  List<BoardListViewResponse> boards = [];

  @override
  void initState() {
    super.initState();
    _fetchBoardList();
  }

  Future<void> _fetchBoardList() async {
    try {
      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.get('http://humanbook.kr/api/getBoardList');
      if (response.statusCode == 200) {
        setState(() {
          boards = List<BoardListViewResponse>.from(response.data.map((board) => BoardListViewResponse.fromJson(board)));
        });
      } else {
        throw Exception('Failed to load boards');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board List'),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return ListTile(
            title: Text(board.title),
            subtitle: Text(board.author),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BoardDetailScreen(boardId: board.id)),
              );
            },
          );
        },
      ),
    );
  }
}

class BoardListViewResponse {
  final int id;
  final String title;
  final String author;

  BoardListViewResponse({required this.id, required this.title, required this.author});

  factory BoardListViewResponse.fromJson(Map<String, dynamic> json) {
    return BoardListViewResponse(
      id: json['id'],
      title: json['title'],
      author: json['author'],
    );
  }
}
