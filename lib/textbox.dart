import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final text;

  TextBox({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
