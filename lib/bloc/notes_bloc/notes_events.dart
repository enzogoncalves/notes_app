import 'package:notes_app/models/note_model.dart';

abstract class NotesEvent {}

class NotesLoadEvent extends NotesEvent {}

class NotesLoadCreateNotePageEvent extends NotesEvent {}

class NotesLoadNotePageEvent extends NotesEvent {
  NotesLoadNotePageEvent({required this.note});

  Note note;
}

class NotesCreateEvent extends NotesEvent {
  NotesCreateEvent({required this.note});

  Note note;
}

class NotesDeleteEvent extends NotesEvent {
  NotesDeleteEvent({required this.note});

  Note note;
}

class NotesEditEvent extends NotesEvent {
  NotesEditEvent({required this.note});

  Note note;
}

class NotesSearchEvent extends NotesEvent {
  NotesSearchEvent({this.queryTitle = ""});

  String queryTitle;
}
