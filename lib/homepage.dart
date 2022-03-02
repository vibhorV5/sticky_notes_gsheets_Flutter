import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sticky_notes_gsheets/google_sheets_api.dart';
import 'package:sticky_notes_gsheets/loading_circle.dart';
import 'package:sticky_notes_gsheets/my_button.dart';
import 'package:sticky_notes_gsheets/notes_grid.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  //wait for the data to be fetched from google sheets
  void startLoading() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  void _post() {
    GoogleSheetsApi.insert(_controller.text);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //starts loading until the data arrives
    if (GoogleSheetsApi.loading == true) {
      startLoading();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'P O S T  A  N O T E',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(
              child: GoogleSheetsApi.loading ? LoadingCircle() : NotesGrid()),
          Container(
            decoration: BoxDecoration(),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
                border: OutlineInputBorder(),
                hintText: 'enter..',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('c r e a t e d  by  @v i b h o r V 5'),
              MyButton(text: 'P O S T', function: _post),
            ],
          ),
        ],
      ),
    );
  }
}
