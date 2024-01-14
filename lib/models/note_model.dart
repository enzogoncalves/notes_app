import 'dart:convert';

class Note {
  Note({this.text, this.title});

  String? text;
  String? title;

  Note.decodeString(String stringNote) {
    const JsonDecoder decoder = JsonDecoder();

    Map<String, dynamic> mapNote = decoder.convert(stringNote);

    title = mapNote["title"];
    text = mapNote["text"];
  }

  String noteToString() {
    const JsonEncoder enconder = JsonEncoder();

    Map<String, dynamic> mapNote = {"title": title, "text": text};

    final noteString = enconder.convert(mapNote);

    return noteString;
  }
}
