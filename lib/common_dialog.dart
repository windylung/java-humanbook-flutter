import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final bool isSuccess;
  final Color backgroundColor;
  final Color titleColor;
  final Color contentColor;
  final Color buttonColor;

  CommonDialog({
    required this.title,
    required this.content,
    required this.buttonText,
    required this.isSuccess,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
    this.contentColor = Colors.black,
    this.buttonColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: contentColor,
        ),
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isSuccess) {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              buttonText,
              style: TextStyle(
                color: buttonColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showCommonDialog(BuildContext context, String title, String content, String buttonText, bool isSuccess) {
  showDialog(
    context: context,
    builder: (context) => CommonDialog(
      title: title,
      content: content,
      buttonText: buttonText,
      isSuccess: isSuccess,
    ),
  );
}