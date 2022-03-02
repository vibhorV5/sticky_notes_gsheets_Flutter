import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  //create credentials
  static const _credentials = r''' 
  {
  "type": "service_account",
  "project_id": "flutter-gsheets-koko",
  "private_key_id": "9d54e60036d267db609bc320b3a30b76e335cc30",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCycAdXAJ5lmFG7\nFVEgkAMgrjdhZ48XNWVjYOczHpC5FgVXktF4Fdkv3Z3Qyk0kVftJRvUkCDy11MXg\nx07yEorOT04NKP2xRTrJiJCR7t9+OrKFIHFspDYAVsDcOFIHwzP+Qw+63u0N+hyZ\nn3yk4dZzhNWgaQ3nqJ8Z+BpTSLTbR9Qp4NxGt2eDG7eRyhKMhpluiA4QRyN0qYxJ\nV1sWYyFucG0yPkjCstUp6AT3vY7Wy2cU1FtOjgdfjep+YKN9ueBjeQdR56rjAt3t\n8qvc71cF4BrjHC1chyuezaucRzb88TF9rIzABHP22P9Vy5V8sPgoCG/Pd36sUDUl\n1gobmFQDAgMBAAECggEAD68EcM46HeiRznrPgv2FeNrh5+rSoJHt6RqRrQ7pCOD5\nno/mChhe2vPaCjRYgXLD6oCVIryinBd+k6+RAyVEFAwpFRkJlgo6t49hqEyxp4ZV\n6JjzFJR+YUXpdQcc7AJpUIDpIgi0F1Vo1svg3caH3ebKtsBlG3vZDXme1BErlwEH\nUWLWHmVJRcOkCQrgL6gXcuUxvAleQ8vbQkKm38B01P1M8hjYkptOtESBIIT7woLF\nSFOHE/T/9q7a5wOKSDN2BEp/E3AOPj3Bv9koOWwFIeyEKbwc76PaHqTxWu0hv/ZZ\n0PAKJSc8Uzrz49zes56CQr7LKFy4NDo/aO3ov1BwwQKBgQDblwTcpJeyfQM3BM7w\nD43JKVMvySCYnNCnLa3HjcvQFtjPW0hoziwuP/PQ67IapE/OzQOPS4qhRLVdAYc4\nhKEVio0uxqQj5Bvy/40L5+r9xRRtJSKox9gI/Qy72uQ4hRiiBAXkNtCDPfTHGzmk\nrDUByffaAPxsFJ4Ii2u90lVfIQKBgQDQBjVz0tvMxLIpU0ylUPKDT/oxG3l1Hls1\n/LC9g2BvivYO9MpKwi29WKY8FwgjUhZGzKkqm2LdD2rnRB8trzOQ+vDhkZGU2S+J\nQDBhV6b7M6gMGIjySgQxYRpPJfd1hhPiqFYRFZPtplyXru34MxswKQN6qRS6Osrb\nB5hAHS6CowKBgF+X5MPw2yEWjvm6nCOhgcXauZ4J3qjRS3wbxJUkw185MvVB9cm6\nRz1zFb8TfBthAGU0lqIg7p65/IIakjUmd8Ga6U89pmMBgLFOUqamNYR38SZ6jhYP\nuZpgHtUAu21nc4vEWJQ60Jbxt8edsIBhf0niFIXQ/BJI/2sU1rhyAjxBAoGAEFCs\nWI0tF/5FSuBxnnWez5WyNa/F8t2SocVTx0lKgvUPH1UrmHlqRPNy9juIM9z4Sk06\n51CQjG3tIH5DQ739+Vz1D3vvQxFVnRofsULCoekHQQubkgUkFwtamOKNafY+EQTK\n20Qp+fWWRX8+wryfYUOWNkSUj5aU2mDaHA0t3KkCgYBDEUzcvrpgSgLZ98myATGw\npKmBotwa7f3C5aIWMywM5nlFowxiQjkFW0WixLWpwObx/SG64klma6lnfcIRtdo5\nZT/zKeVWjzig9IY2TQ+K34xyQwSJqeLpFkBDCQ7etn67EOBShLq7RQK91Q+WnnKj\nU0cg5khjhTIxa7m9RW8+hw==\n-----END PRIVATE KEY-----\n",
  "client_email": "sticky-notes-app@flutter-gsheets-koko.iam.gserviceaccount.com",
  "client_id": "108013277890046077015",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/sticky-notes-app%40flutter-gsheets-koko.iam.gserviceaccount.com"
}
  ''';

  //set up and connect GSheets

  static const _spreadsheetId = '1i273fLuc6FPJnkoyrUvKJKxDFJbLge6RxV_NimWdq28';
  static final _gSheets = GSheets(_credentials);
  static Worksheet? _worksheet;
  static bool loading = true;

  //some variables to keep track of

  static int numberOfNotes = 0;
  static List<String> currentNotes = [];

  //initialize the spreadsheet
  Future init() async {
    //fetch spreadsheet
    final ss = await _gSheets.spreadsheet(_spreadsheetId);
    //fetch worksheet by title
    _worksheet = ss.worksheetByTitle('Sheet1');

    countRows();
  }

  //count existing notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    //we know how many notes we have
    loadNotes();
  }

  //load existing notes

  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add(newNote);
      }
    }
    loading = false;
  }

  //insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add(note);
    await _worksheet!.values.appendRow([note]);
  }
}
