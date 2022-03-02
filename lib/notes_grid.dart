import 'package:flutter/material.dart';
import 'package:sticky_notes_gsheets/google_sheets_api.dart';
import 'package:sticky_notes_gsheets/textbox.dart';

class NotesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: GoogleSheetsApi.currentNotes.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) =>
            TextBox(text: GoogleSheetsApi.currentNotes[index]),
      ),
    );
  }
}
