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
      final response = await dio.get('http://humanbook.kr/api/board/getBoard/${widget.boardId}');
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

  Future<void> _deleteBoard() async {
    try {
      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.delete('http://humanbook.kr/api/board/${widget.boardId}/del');
      if (response.statusCode == 200) {
        // 성공 시 팝업 띄우고 이전 페이지로 이동
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제되었습니다.')));
        Navigator.pop(context);
      } else {
        throw Exception('Failed to delete board');
      }
    } catch (e) {
      // 오류 발생 시 팝업 띄움
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제에 실패했습니다: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Board Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteBoard,
          ),
        ],
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
            Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: board.comments.length,
                itemBuilder: (context, index) {
                  final comment = board.comments[index];
                  return ListTile(
                    title: Text(comment.comment),
                    subtitle: Text('By ${comment.nickname} on ${comment.createdAt}'),
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
      author: json['owner'],
      comments: List<CommentResponse>.from(json['comments'].map((comment) => CommentResponse.fromJson(comment))),
    );
  }
}

class CommentResponse {
  final int id;
  final String comment;
  final String createdAt;
  final String modifiedAt;
  final String nickname;
  final int memberId;
  final int boardId;

  CommentResponse({
    required this.id,
    required this.comment,
    required this.createdAt,
    required this.modifiedAt,
    required this.nickname,
    required this.memberId,
    required this.boardId,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      id: json['id'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      modifiedAt: json['modifiedAt'],
      nickname: json['nickname'],
      memberId: json['memberId'],
      boardId: json['boardId'],
    );
  }
}
