import 'package:notes_app/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

String notesStorageKeyName = "notes";

class NotesRepository {
  List<Note> _notes = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<Note>> loadNotes() async {
    final SharedPreferences prefs = await _prefs;
    List<String>? prefsNotes = prefs.getStringList(notesStorageKeyName);

    if (prefsNotes != null) {
      List<Note> notesData = prefsNotes.map((String stringNote) => Note.decodeString(stringNote)).toList();

      _notes = notesData;
      return notesData;
    } else {
      return [];
    }
  }

  Future<void> createNote(Note note) async {
    _notes.insert(0, note);

    final SharedPreferences prefs = await _prefs;

    List<String> stringNotes = _notes.map((e) => e.noteToString()).toList();

    prefs.setStringList(notesStorageKeyName, stringNotes);
  }

  Future<void> deleteNote(Note note) async {
    _notes.remove(note);

    final SharedPreferences prefs = await _prefs;

    List<String> stringNotes = _notes.map((e) => e.noteToString()).toList();

    prefs.setStringList(notesStorageKeyName, stringNotes);
  }

  Future<void> editNote(Note note) async {
    int noteToBeEditedIndex = _notes.indexWhere((element) => element == note);

    _notes[noteToBeEditedIndex].text = note.text;
    _notes[noteToBeEditedIndex].title = note.title;

    final SharedPreferences prefs = await _prefs;

    List<String> stringNotes = _notes.map((e) => e.noteToString()).toList();

    prefs.setStringList(notesStorageKeyName, stringNotes);
  }
}
