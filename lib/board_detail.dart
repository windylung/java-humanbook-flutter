import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';
import 'package:dio/dio.dart';

class BoardDetailScreen extends StatefulWidget {
  final int boardId;

  BoardDetailScreen({required this.boardId});

  @override
  _BoardDetailScreenState createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  late BoardViewResponse board;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBoardDetails();
  }

  Future<void> _fetchBoardDetails() async {
    try {
      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.get('http://humanbook.kr/api/getBoard/${widget.boardId}');
      if (response.statusCode == 200) {
        setState(() {
          board = BoardViewResponse.fromJson(response.data);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load board details');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(board.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('By ${board.author}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(board.content, style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: board.comments.length,
                itemBuilder: (context, index) {
                  final comment = board.comments[index];
                  return ListTile(
                    title: Text(comment.content),
                    subtitle: Text('By ${comment.author}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardViewResponse {
  final int id;
  final String title;
  final String content;
  final String author;
  final List<CommentResponse> comments;

  BoardViewResponse({required this.id, required this.title, required this.content, required this.author, required this.comments});

  factory BoardViewResponse.fromJson(Map<String, dynamic> json) {
    return BoardViewResponse(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      comments: List<CommentResponse>.from(json['comments'].map((comment) => CommentResponse.fromJson(comment))),
    );
  }
}

class CommentResponse {
  final String content;
  final String author;

  CommentResponse({required this.content, required this.author});

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      content: json['content'],
      author: json['author'],
    );
  }
}
