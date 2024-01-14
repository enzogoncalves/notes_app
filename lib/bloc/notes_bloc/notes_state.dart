import 'package:notes_app/models/note_model.dart';

abstract class NotesState {}

class NotesInitialState extends NotesState {
  NotesInitialState({required this.notes});

  List<Note> notes;
}

class NotesLoadedState extends NotesState {
  NotesLoadedState({required this.notes});

  List<Note> notes;
}

class NotesCreateNoteState extends NotesState {}

class NotesOpenNoteState extends NotesState {
  NotesOpenNoteState({required this.note});

  Note note;
}
