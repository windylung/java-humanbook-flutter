import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:epubx/epubx.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'book.dart';
// import 'package:image/image.dart' as img; // 표지 이미지 관련 라이브러리 생략

class GetBookScreen extends StatefulWidget {
  @override
  _GetBookScreenState createState() => _GetBookScreenState();
}

class _GetBookScreenState extends State<GetBookScreen> {
  bool _isLoading = false;
  String _statusMessage = "";
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  List<int>? _coverImageBytes; // 표지 이미지 생략

  Future<void> _fetchManuscriptsAndSaveBook() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Fetching manuscripts...";
    });

    try {
      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.get('http://humanbook.kr/api/manuscripts/user');

      if (response.statusCode == 200) {
        final manuscripts = response.data as List<dynamic>;
        manuscripts.sort((a, b) => a['step'].compareTo(b['step']));

        final title = _titleController.text;
        final author = _authorController.text;
        // final cover = _coverImageBytes; // 표지 이미지 생략

        final book = await _createEpub(manuscripts, title, author);

        await _saveBookToServer(book);

        setState(() {
          _isLoading = false;
          _statusMessage = "Book saved successfully: ${book.title}";
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = "Failed to load manuscripts";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Error: $e";
      });
    }
  }

  Future<Book> _createEpub(List<dynamic> manuscripts, String title, String author) async {
    var book = EpubBook();

    // 메타데이터 설정
    book.Title = title;
    book.AuthorList = [author];

    // 표지 추가 생략
    // if (cover != null && cover.isNotEmpty) {
    //   var coverImage = EpubByteContentFile();
    //   coverImage.Content = cover;
    //   coverImage.FileName = 'OEBPS/Images/cover.jpg';

    //   // book.Content가 null인 경우 초기화
    //   book.Content ??= EpubContent();
    //   book.Content.Images ??= {};
    //   book.Content.Images![coverImage.FileName!] = coverImage;
    // }

    // 콘텐츠 추가
    for (var manuscript in manuscripts) {
      var chapter = EpubTextContentFile();
      chapter.Content = '<html><body><h1>${manuscript['title']}</h1>${manuscript['content']}</body></html>';
      chapter.FileName = 'OEBPS/Text/chapter${manuscript['step']}.xhtml';

      // book.Content가 null인 경우 초기화
      book.Content ??= EpubContent();
      book.Content?.Html ??= {};
      book.Content?.Html![chapter.FileName!] = chapter;
    }

    // EPUB 파일 생성
    var epubBytes = await EpubWriter.writeBook(book);

    return Book(title: title, author: author, epubContent: epubBytes);
  }

  Future<void> _saveBookToServer(Book book) async {
    final dio = Provider.of<AuthProvider>(context, listen: false).dio;

    FormData formData = FormData.fromMap({
      'title': book.title,
      'author': book.author,
      'isLiked': book.isLiked,
      // 'cover': book.cover != null ? MultipartFile.fromBytes(book.cover!, filename: 'cover.jpg') : null, // 표지 이미지 생략
      'epub': book.epubContent != null ? MultipartFile.fromBytes(book.epubContent!, filename: '${book.title}.epub') : null,
    });

    try {
      final response = await dio.post('http://humanbook.kr/api/books', data: formData);
      if (response.statusCode == 200) {
        print('Book saved successfully');
      } else {
        print('Failed to save book');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // 표지 이미지 선택 기능 생략
  // Future<void> _selectCoverImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //   );

  //   if (result != null && result.files.single.bytes != null) {
  //     setState(() {
  //       _coverImageBytes = result.files.single.bytes;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get and Save Book'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Book Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // 표지 이미지 선택 버튼 생략
              // ElevatedButton(
              //   onPressed: _selectCoverImage,
              //   child: Text('Select Cover Image'),
              // ),
              // if (_coverImageBytes != null)
              //   Image.memory(
              //     _coverImageBytes!,
              //     height: 200,
              //   ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchManuscriptsAndSaveBook,
                child: Text('Fetch Manuscripts and Save Book'),
              ),
              SizedBox(height: 20),
              Text(_statusMessage),
            ],
          ),
        ),
      ),
    );
  }
}
